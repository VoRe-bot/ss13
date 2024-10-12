import { toFixed } from 'common/math';
import { useBackend } from 'tgui/backend';
import { Flex, LabeledList, Section, Slider } from 'tgui/components';

import { abilities } from './types';

export const VoreAbilities = (props: { abilities: abilities }) => {
  const { act } = useBackend();

  const { abilities } = props;

  const { nutrition, current_size, minimum_size, maximum_size, resize_cost } =
    abilities;

  function is_enabled(nutri: number, cost: number): boolean {
    return nutri >= cost;
  }

  return (
    <Section title="Abilities" buttons={'Nutrition: ' + toFixed(nutrition, 1)}>
      <LabeledList>
        <LabeledList.Item label="Resize">
          <Flex align="baseline">
            <Flex.Item>
              <Slider
                disabled={!is_enabled(nutrition, resize_cost)}
                width="250px"
                ranges={
                  is_enabled(nutrition, resize_cost)
                    ? {
                        bad: [1, 25],
                        average: [25, 50],
                        green: [50, 150],
                        yellow: [150, 200],
                        red: [200, 600],
                      }
                    : { black: [0, 600] }
                }
                format={(value: number) => toFixed(value, 2) + '%'}
                value={current_size * 100}
                minValue={minimum_size * 100}
                maxValue={maximum_size * 100}
                onChange={(e, value: number) =>
                  act('adjust_own_size', {
                    new_mob_size: value / 100,
                  })
                }
              />
            </Flex.Item>
            <Flex.Item color="label">&nbsp;&nbsp;Cost:&nbsp;</Flex.Item>
            <Flex.Item>{resize_cost}</Flex.Item>
          </Flex>
        </LabeledList.Item>
      </LabeledList>
    </Section>
  );
};
