import { Fragment } from 'react';
import { useBackend } from '../../backend';
import { Box, Button, NoticeBox } from '../../components';

export const MiningUser = (props) => {
  const { act, data } = useBackend();
  const { insertIdText } = props;
  const { has_id, id } = data;
  return (
    <NoticeBox success={has_id}>
      {has_id ? (
        <>
          <Box
            display="inline-block"
            verticalAlign="middle"
            style={{
              float: 'left',
            }}
          >
            Logged in as {id.name}.<br />
            You have {id.points.toLocaleString('en-US')} points.
          </Box>
          <Button
            icon="eject"
            content="Eject ID"
            style={{
              float: 'right',
            }}
            onClick={() => act('logoff')}
          />
          <Box
            style={{
              clear: 'both',
            }}
          />
        </>
      ) : (
        insertIdText
      )}
    </NoticeBox>
  );
};
