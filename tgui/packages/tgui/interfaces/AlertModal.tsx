import { useState } from 'react';
import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import { Autofocus, Box, Button, Section, Stack } from 'tgui-core/components';
import { isEscape, KEY } from 'tgui-core/keys';

import { Loader } from './common/Loader';

type AlertModalData = {
  autofocus: boolean;
  buttons: string[];
  large_buttons: boolean;
  message: string;
  swapped_buttons: boolean;
  timeout: number;
  title: string;
};

const KEY_DECREMENT = -1;
const KEY_INCREMENT = 1;

export const AlertModal = (props) => {
  const { act, data } = useBackend<AlertModalData>();
  const {
    autofocus,
    buttons = [],
    large_buttons,
    message = '',
    timeout,
    title,
  } = data;
  const [selected, setSelected] = useState(0);
  // Dynamically sets window dimensions
  const windowHeight =
    115 +
    (message.length > 30 ? Math.ceil(message.length / 4) : 0) +
    (message.length && large_buttons ? 5 : 0);
  const windowWidth = 325 + (buttons.length > 2 ? 55 : 0);
  const onKey = (direction: number) => {
    if (selected === 0 && direction === KEY_DECREMENT) {
      setSelected(buttons.length - 1);
    } else if (selected === buttons.length - 1 && direction === KEY_INCREMENT) {
      setSelected(0);
    } else {
      setSelected(selected + direction);
    }
  };

  function handleKeyDown(event: React.KeyboardEvent<HTMLDivElement>) {
    const key = event.key;
    /**
     * Simulate a click when pressing space or enter,
     * allow keyboard navigation, override tab behavior
     */
    if (key === KEY.Space || key === KEY.Enter) {
      act('choose', { choice: buttons[selected] });
    } else if (isEscape(key)) {
      act('cancel');
    } else if (key === KEY.Left) {
      event.preventDefault();
      onKey(KEY_DECREMENT);
    } else if (key === KEY.Tab || key === KEY.Right) {
      event.preventDefault();
      onKey(KEY_INCREMENT);
    }
  }

  return (
    <Window height={windowHeight} title={title} width={windowWidth}>
      {!!timeout && <Loader value={timeout} />}
      <Window.Content onKeyDown={(e) => handleKeyDown(e)}>
        <Section fill>
          <Stack fill vertical>
            <Stack.Item grow m={1}>
              <Box color="label" overflow="hidden">
                {message}
              </Box>
            </Stack.Item>
            <Stack.Item>
              {!!autofocus && <Autofocus />}
              <ButtonDisplay selected={selected} />
            </Stack.Item>
          </Stack>
        </Section>
      </Window.Content>
    </Window>
  );
};

/**
 * Displays a list of buttons ordered by user prefs.
 * Technically this handles more than 2 buttons, but you
 * should just be using a list input in that case.
 */
const ButtonDisplay = (props) => {
  const { data } = useBackend<AlertModalData>();
  const { buttons = [], large_buttons, swapped_buttons } = data;
  const { selected } = props;

  return (
    <Stack
      align="center"
      direction={!swapped_buttons ? 'row-reverse' : 'row'}
      fill
      justify="space-around"
      wrap
    >
      {buttons?.map((button, index) =>
        !!large_buttons && buttons.length < 3 ? (
          <Stack.Item grow key={index}>
            <AlertButton
              button={button}
              id={index.toString()}
              selected={selected === index}
            />
          </Stack.Item>
        ) : (
          <Stack.Item key={index}>
            <AlertButton
              button={button}
              id={index.toString()}
              selected={selected === index}
            />
          </Stack.Item>
        ),
      )}
    </Stack>
  );
};

/**
 * Displays a button with variable sizing.
 */
const AlertButton = (props) => {
  const { act, data } = useBackend<AlertModalData>();
  const { large_buttons } = data;
  const { button, selected } = props;
  const buttonWidth = button.length > 7 ? button.length : 7;

  return (
    <Button
      fluid={!!large_buttons}
      height={!!large_buttons && 2}
      onClick={() => act('choose', { choice: button })}
      m={0.5}
      pl={2}
      pr={2}
      pt={large_buttons ? 0.33 : 0}
      selected={selected}
      textAlign="center"
      width={!large_buttons && buttonWidth}
    >
      {!large_buttons ? button : button.toUpperCase()}
    </Button>
  );
};
