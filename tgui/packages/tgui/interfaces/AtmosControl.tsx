import { useState } from 'react';

import { useBackend } from '../backend';
import { Box, Button, Icon, NanoMap, Section, Tabs } from '../components';
import { Window } from '../layouts';

type alarm = {
  name: string;
  ref: string;
  danger: number;
  x: number;
  y: number;
  z: number;
};

type Data = {
  alarms: alarm[];
  zoomScale: number;
};

export const AtmosControl = (props) => {
  return (
    <Window width={600} height={440}>
      <Window.Content scrollable>
        <AtmosControlContent />
      </Window.Content>
    </Window>
  );
};

export const AtmosControlContent = (props) => {
  const { act, data, config } = useBackend<Data>();

  const { alarms } = data;
  alarms.sort((a, b) => a.name.localeCompare(b.name));

  const [tabIndex, setTabIndex] = useState(0);
  const [zoom, setZoom] = useState(1);

  let body;
  // Alarms View
  if (tabIndex === 0) {
    body = (
      <Section title="Alarms">
        {alarms.map((alarm) => (
          <Button
            key={alarm.name}
            color={
              alarm.danger === 2 ? 'bad' : alarm.danger === 1 ? 'average' : ''
            }
            onClick={() => act('alarm', { alarm: alarm.ref })}
          >
            {alarm.name}
          </Button>
        ))}
      </Section>
    );
  } else if (tabIndex === 1) {
    // Please note, if you ever change the zoom values,
    // you MUST update styles/components/Tooltip.scss
    // and change the @for scss to match.
    body = (
      <Box height="526px" mb="0.5rem" overflow="hidden">
        <NanoMap zoomScale={data.zoomScale} onZoom={(v) => setZoom(v)}>
          {alarms
            .filter((x) => ~~x.z === ~~config.mapZLevel)
            .map((cm) => (
              <NanoMap.Marker
                key={cm.ref}
                x={cm.x}
                y={cm.y}
                zoom={zoom}
                icon="bell"
                tooltip={cm.name}
                color={cm.danger ? 'red' : 'green'}
                onClick={() => act('alarm', { alarm: cm.ref })}
              />
            ))}
        </NanoMap>
      </Box>
    );
  }

  return (
    <>
      <Tabs>
        <Tabs.Tab
          key="AlarmView"
          selected={0 === tabIndex}
          onClick={() => setTabIndex(0)}
        >
          <Icon name="table" /> Alarm View
        </Tabs.Tab>
        <Tabs.Tab
          key="MapView"
          selected={1 === tabIndex}
          onClick={() => setTabIndex(1)}
        >
          <Icon name="map-marked-alt" /> Map View
        </Tabs.Tab>
      </Tabs>
      <Box m={2}>{body}</Box>
    </>
  );
};
