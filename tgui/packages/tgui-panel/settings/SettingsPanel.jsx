/**
 * @file
 * @copyright 2020 Aleksej Komarov
 * @license MIT
 */

import { toFixed } from 'common/math';
import { useLocalState } from 'tgui/backend';
import { useDispatch, useSelector } from 'tgui/backend';
import {
  Box,
  Button,
  ColorBox,
  Divider,
  Dropdown,
  Flex,
  Input,
  LabeledList,
  NumberInput,
  Section,
  Stack,
  Tabs,
  TextArea,
} from 'tgui/components';
import { ChatPageSettings } from '../chat';
import {
  rebuildChat,
  saveChatToDisk,
  purgeChatMessageArchive,
} from '../chat/actions';
import { THEMES } from '../themes';
import {
  changeSettingsTab,
  updateSettings,
  addHighlightSetting,
  removeHighlightSetting,
  updateHighlightSetting,
} from './actions';
import { SETTINGS_TABS, FONTS, MAX_HIGHLIGHT_SETTINGS } from './constants';
import {
  selectActiveTab,
  selectSettings,
  selectHighlightSettings,
  selectHighlightSettingById,
} from './selectors';

export const SettingsPanel = (props) => {
  const activeTab = useSelector(selectActiveTab);
  const dispatch = useDispatch();
  return (
    <Stack fill>
      <Stack.Item>
        <Section fitted fill minHeight="8em">
          <Tabs vertical>
            {SETTINGS_TABS.map((tab) => (
              <Tabs.Tab
                key={tab.id}
                selected={tab.id === activeTab}
                onClick={() =>
                  dispatch(
                    changeSettingsTab({
                      tabId: tab.id,
                    }),
                  )
                }
              >
                {tab.name}
              </Tabs.Tab>
            ))}
          </Tabs>
        </Section>
      </Stack.Item>
      <Stack.Item grow={1} basis={0}>
        {activeTab === 'general' && <SettingsGeneral />}
        {activeTab === 'limits' && <MessageLimits />}
        {activeTab === 'export' && <ExportTab />}
        {activeTab === 'chatPage' && <ChatPageSettings />}
        {activeTab === 'textHighlight' && <TextHighlightSettings />}
      </Stack.Item>
    </Stack>
  );
};

export const SettingsGeneral = (props) => {
  const { theme, fontFamily, fontSize, lineHeight, showReconnectWarning } =
    useSelector(selectSettings);
  const dispatch = useDispatch();
  const [freeFont, setFreeFont] = useLocalState('freeFont', false);
  return (
    <Section>
      <LabeledList>
        <LabeledList.Item label="Theme">
          <Dropdown
            selected={theme}
            options={THEMES}
            onSelected={(value) =>
              dispatch(
                updateSettings({
                  theme: value,
                }),
              )
            }
          />
        </LabeledList.Item>
        <LabeledList.Item label="Font style">
          <Stack inline align="baseline">
            <Stack.Item>
              {(!freeFont && (
                <Dropdown
                  selected={fontFamily}
                  options={FONTS}
                  onSelected={(value) =>
                    dispatch(
                      updateSettings({
                        fontFamily: value,
                      }),
                    )
                  }
                />
              )) || (
                <Input
                  value={fontFamily}
                  onChange={(e, value) =>
                    dispatch(
                      updateSettings({
                        fontFamily: value,
                      }),
                    )
                  }
                />
              )}
            </Stack.Item>
            <Stack.Item>
              <Button
                content="Custom font"
                icon={freeFont ? 'lock-open' : 'lock'}
                color={freeFont ? 'good' : 'bad'}
                ml={1}
                onClick={() => {
                  setFreeFont(!freeFont);
                }}
              />
            </Stack.Item>
          </Stack>
        </LabeledList.Item>
        <LabeledList.Item label="Font size">
          <NumberInput
            width="4em"
            step={1}
            stepPixelSize={10}
            minValue={8}
            maxValue={32}
            value={fontSize}
            unit="px"
            format={(value) => toFixed(value)}
            onChange={(e, value) =>
              dispatch(
                updateSettings({
                  fontSize: value,
                }),
              )
            }
          />
        </LabeledList.Item>
        <LabeledList.Item label="Line height">
          <NumberInput
            width="4em"
            step={0.01}
            stepPixelSize={2}
            minValue={0.8}
            maxValue={5}
            value={lineHeight}
            format={(value) => toFixed(value, 2)}
            onDrag={(e, value) =>
              dispatch(
                updateSettings({
                  lineHeight: value,
                }),
              )
            }
          />
        </LabeledList.Item>
        <LabeledList.Item label="Enable disconnection/afk warning">
          <Button.Checkbox
            checked={showReconnectWarning}
            content=""
            tooltip="Unchecking this will disable the red afk/reconnection warning bar at the bottom of the chat."
            mr="5px"
            onClick={() =>
              dispatch(
                updateSettings({
                  showReconnectWarning: !showReconnectWarning,
                }),
              )
            }
          />
        </LabeledList.Item>
      </LabeledList>
    </Section>
  );
};

export const MessageLimits = (props) => {
  const dispatch = useDispatch();
  const {
    visibleMessageLimit,
    persistentMessageLimit,
    combineMessageLimit,
    combineIntervalLimit,
  } = useSelector(selectSettings);
  return (
    <Section>
      <LabeledList>
        <LabeledList.Item label="Amount of lines to display 500-10000 (Default: 2500)">
          <NumberInput
            width="5em"
            step={100}
            stepPixelSize={2}
            minValue={500}
            maxValue={10000}
            value={visibleMessageLimit}
            format={(value) => toFixed(value)}
            onDrag={(e, value) =>
              dispatch(
                updateSettings({
                  visibleMessageLimit: value,
                }),
              )
            }
          />
        </LabeledList.Item>
        <LabeledList.Item label="Amount of visually persistent lines 500-10000 (Default: 1000)">
          <NumberInput
            width="5em"
            step={100}
            stepPixelSize={2}
            minValue={500}
            maxValue={10000}
            value={persistentMessageLimit}
            format={(value) => toFixed(value)}
            onDrag={(e, value) =>
              dispatch(
                updateSettings({
                  persistentMessageLimit: value,
                }),
              )
            }
          />
        </LabeledList.Item>
        <LabeledList.Item label="Amount of different lines in between to combine 0-10 (Default: 5)">
          <NumberInput
            width="5em"
            step={1}
            stepPixelSize={10}
            minValue={0}
            maxValue={10}
            value={combineMessageLimit}
            format={(value) => toFixed(value)}
            onDrag={(e, value) =>
              dispatch(
                updateSettings({
                  combineMessageLimit: value,
                }),
              )
            }
          />
        </LabeledList.Item>
        <LabeledList.Item label="Time to combine messages 0-10 (Default: 5 Seconds)">
          <NumberInput
            width="5em"
            step={1}
            stepPixelSize={10}
            minValue={0}
            maxValue={10}
            value={combineIntervalLimit}
            unit="s"
            format={(value) => toFixed(value)}
            onDrag={(e, value) =>
              dispatch(
                updateSettings({
                  combineIntervalLimit: value,
                }),
              )
            }
          />
        </LabeledList.Item>
      </LabeledList>
    </Section>
  );
};

export const ExportTab = (props) => {
  const dispatch = useDispatch();
  const { logRetainDays, logLineCount, totalStoredMessages } =
    useSelector(selectSettings);
  const [purgeConfirm, setPurgeConfirm] = useLocalState('purgeConfirm', 0);
  return (
    <Section>
      <LabeledList>
        {/* FIXME: Implement this later on
        <LabeledList.Item label="Days to retain logs (-1 = inf.)">
          <Input
            width="5em"
            monospace
            value={logRetainDays}
            onInput={(e, value) =>
              dispatch(
                updateSettings({
                  logRetainDays: value,
                })
              )
            }
          />
        </LabeledList.Item>
        */}
        <LabeledList.Item label="Amount of lines to export (-1 = inf.)">
          <NumberInput
            width="5em"
            step={100}
            stepPixelSize={2}
            minValue={-1}
            maxValue={50000}
            value={logLineCount}
            format={(value) => toFixed(value)}
            onDrag={(e, value) =>
              dispatch(
                updateSettings({
                  logLineCount: value,
                }),
              )
            }
          />
        </LabeledList.Item>
        <LabeledList.Item label="Totally stored messages">
          <Box>{totalStoredMessages}</Box>
        </LabeledList.Item>
      </LabeledList>
      <Divider />
      <Button icon="save" onClick={() => dispatch(saveChatToDisk())}>
        Save chat log
      </Button>
      {purgeConfirm > 0 ? (
        <Button
          icon="trash"
          color="red"
          onClick={() => {
            dispatch(purgeChatMessageArchive());
            setPurgeConfirm(2);
          }}
        >
          {purgeConfirm > 1 ? 'Purged!' : 'Are you sure?'}
        </Button>
      ) : (
        <Button
          icon="trash"
          color="red"
          onClick={() => {
            setPurgeConfirm(1);
            setTimeout(() => {
              setPurgeConfirm(false);
            }, 5000);
          }}
        >
          Purge message archive
        </Button>
      )}
    </Section>
  );
};

const TextHighlightSettings = (props) => {
  const highlightSettings = useSelector(selectHighlightSettings);
  const dispatch = useDispatch();
  return (
    <Section fill scrollable height="200px">
      <Section p={0}>
        <Flex direction="column">
          {highlightSettings.map((id, i) => (
            <TextHighlightSetting
              key={i}
              id={id}
              mb={i + 1 === highlightSettings.length ? 0 : '10px'}
            />
          ))}
          {highlightSettings.length < MAX_HIGHLIGHT_SETTINGS && (
            <Flex.Item>
              <Button
                color="transparent"
                icon="plus"
                content="Add Highlight Setting"
                onClick={() => {
                  dispatch(addHighlightSetting());
                }}
              />
            </Flex.Item>
          )}
        </Flex>
      </Section>
      <Divider />
      <Box>
        <Button icon="check" onClick={() => dispatch(rebuildChat())}>
          Apply now
        </Button>
        <Box inline fontSize="0.9em" ml={1} color="label">
          Can freeze the chat for a while.
        </Box>
      </Box>
    </Section>
  );
};

const TextHighlightSetting = (props) => {
  const { id, ...rest } = props;
  const highlightSettingById = useSelector(selectHighlightSettingById);
  const dispatch = useDispatch();
  const {
    highlightColor,
    highlightText,
    blacklistText,
    highlightWholeMessage,
    highlightBlacklist,
    matchWord,
    matchCase,
  } = highlightSettingById[id];
  return (
    <Flex.Item {...rest}>
      <Flex mb={1} color="label" align="baseline">
        <Flex.Item grow>
          <Button
            content="Delete"
            color="transparent"
            icon="times"
            onClick={() =>
              dispatch(
                removeHighlightSetting({
                  id: id,
                }),
              )
            }
          />
        </Flex.Item>
        <Flex.Item>
          <Button.Checkbox
            checked={highlightBlacklist}
            content="Highlight Blacklist"
            tooltip="If this option is selected, you can blacklist senders not to highlight their messages."
            mr="5px"
            onClick={() =>
              dispatch(
                updateHighlightSetting({
                  id: id,
                  highlightBlacklist: !highlightBlacklist,
                }),
              )
            }
          />
        </Flex.Item>
        <Flex.Item>
          <Button.Checkbox
            checked={highlightWholeMessage}
            content="Whole Message"
            tooltip="If this option is selected, the entire message will be highlighted in yellow."
            mr="5px"
            onClick={() =>
              dispatch(
                updateHighlightSetting({
                  id: id,
                  highlightWholeMessage: !highlightWholeMessage,
                }),
              )
            }
          />
        </Flex.Item>
        <Flex.Item>
          <Button.Checkbox
            content="Exact"
            checked={matchWord}
            tooltipPosition="bottom-start"
            tooltip="If this option is selected, only exact matches (no extra letters before or after) will trigger. Not compatible with punctuation. Overriden if regex is used."
            onClick={() =>
              dispatch(
                updateHighlightSetting({
                  id: id,
                  matchWord: !matchWord,
                }),
              )
            }
          />
        </Flex.Item>
        <Flex.Item>
          <Button.Checkbox
            content="Case"
            tooltip="If this option is selected, the highlight will be case-sensitive."
            checked={matchCase}
            onClick={() =>
              dispatch(
                updateHighlightSetting({
                  id: id,
                  matchCase: !matchCase,
                }),
              )
            }
          />
        </Flex.Item>
        <Flex.Item shrink={0}>
          <ColorBox mr={1} color={highlightColor} />
          <Input
            width="5em"
            monospace
            placeholder="#ffffff"
            value={highlightColor}
            onInput={(e, value) =>
              dispatch(
                updateHighlightSetting({
                  id: id,
                  highlightColor: value,
                }),
              )
            }
          />
        </Flex.Item>
      </Flex>
      <TextArea
        height="3em"
        value={highlightText}
        placeholder="Put words to highlight here. Separate terms with commas, i.e. (term1, term2, term3)"
        onChange={(e, value) =>
          dispatch(
            updateHighlightSetting({
              id: id,
              highlightText: value,
            }),
          )
        }
      />
      {highlightBlacklist ? (
        <TextArea
          height="3em"
          value={blacklistText}
          placeholder="Put names of senders you don't want highlighted here. Separate names with commas, i.e. (name1, name2, name3)"
          onChange={(e, value) =>
            dispatch(
              updateHighlightSetting({
                id: id,
                blacklistText: value,
              }),
            )
          }
        />
      ) : (
        ''
      )}
    </Flex.Item>
  );
};
