create extension if not exists "pgcrypto";

-- Block table 

create table blocks
(
    block_id        uuid default gen_random_uuid() not null
        primary key,    
    block_hash      VARCHAR                   not null,   
    chain_id        VARCHAR                   not null,
    height          VARCHAR                   not null,
    tx_num          VARCHAR                   not null,
    created_at      timestamp                      not null
);



-- Transactions table

create table transactions
(
    tx_id         uuid default gen_random_uuid() not null
        primary key,
    block_id      uuid                       not null,    
    memo       VARCHAR                  not null,   
    fee_denom      VARCHAR              not null,
    fee_amount     VARCHAR              not null,
    gas_limit  VARCHAR                  not null,
    created_at timestamp                      not null,
    tx_info    jsonb                          not null,
    FOREIGN KEY (block_id) REFERENCES blocks(block_id)
);



-- alliance_alliance_MsgClaimDelegationRewards table

create table alliance_claimdelegationrewards_msg
(
    message_id         uuid default gen_random_uuid() not null
        primary key,
    tx_id                           uuid             not null,
    delegator_address_id            uuid             not null,
    validator_address_id            uuid             not null,
    tx_type                         VARCHAR          not null,   
    tx_denom                        VARCHAR          not null,
    FOREIGN KEY (tx_id) REFERENCES transactions(tx_id),
    FOREIGN KEY (delegator_address_id) REFERENCES address(address_id),
    FOREIGN KEY (validator_address_id) REFERENCES address(address_id)
);


-- cosmos.distribution.v1beta1.MsgWithdrawValidatorCommission

create table cosmos_withdrawvalidatorcommission_msg
(
    message_id         uuid default gen_random_uuid() not null
        primary key,
    tx_id               uuid             not null,
    validator_address_id          uuid             not null,
    tx_type                       VARCHAR          not null,
    FOREIGN KEY (tx_id) REFERENCES transactions(tx_id),
    FOREIGN KEY (validator_address_id) REFERENCES address(address_id)
);




-- alliance_alliance_MsgClaimDelegate table

create table alliance_delegate_msg
(
    message_id         uuid default gen_random_uuid() not null
        primary key,
    tx_id               uuid                  not null,
    delegator_address_id          uuid             not null,
    validator_address_id          uuid             not null, 
    tx_type             VARCHAR          not null,   
    tx_denom            VARCHAR          not null,
    amount              VARCHAR         not null,
    FOREIGN KEY (tx_id) REFERENCES transactions(tx_id),
    FOREIGN KEY (delegator_address_id) REFERENCES address(address_id),
    FOREIGN KEY (validator_address_id) REFERENCES address(address_id)
);





-- alliance_alliance_MsgRedelegate table

create table alliance_redelegate_msg
(
    message_id         uuid default gen_random_uuid() not null
        primary key,
    tx_id               uuid                  not null,
    delegator_address_id              uuid             not null,
    validator_src_address_id          uuid             not null,
    validator_dst_address_id          uuid             not null,    
    tx_type             VARCHAR          not null,
    tx_denom            VARCHAR          not null,
    amount              VARCHAR          not null,
    FOREIGN KEY (tx_id) REFERENCES transactions(tx_id),
    FOREIGN KEY (delegator_address_id) REFERENCES address(address_id),
    FOREIGN KEY (validator_src_address_id) REFERENCES address(address_id),
    FOREIGN KEY (validator_dst_address_id) REFERENCES address(address_id)
);





-- alliance_alliance_MsgUndelegate table

create table alliance_undelegate_msg
(
    message_id         uuid default gen_random_uuid() not null
        primary key,
    tx_id               uuid                  not null,
    delegator_address_id          uuid             not null,
    validator_address_id          uuid             not null, 
    tx_type             VARCHAR          not null,   
    tx_denom            VARCHAR          not null,
    amount              VARCHAR         not null,
    FOREIGN KEY (tx_id) REFERENCES transactions(tx_id),
    FOREIGN KEY (delegator_address_id) REFERENCES address(address_id),
    FOREIGN KEY (validator_address_id) REFERENCES address(address_id)
);





-- cosmos_authz_v1beta1_MsgExec table

create table cosmos_exec_msg
(
    message_id         uuid default gen_random_uuid() not null
        primary key,
    tx_id               uuid                  not null,
    receive_address_id          uuid             not null,
    tx_type             VARCHAR          not null,    
    msg_num             VARCHAR          not null,
    FOREIGN KEY (tx_id) REFERENCES transactions(tx_id),
    FOREIGN KEY (receive_address_id) REFERENCES address(address_id)

);




-- cosmos_authz_v1beta1_MsgGrant table 

create table cosmos_grant_msg
(
    message_id         uuid default gen_random_uuid() not null
        primary key,
    tx_id               uuid                  not null,
    send_address_id          uuid             not null,
    receive_address_id          uuid             not null,
    tx_type             VARCHAR          not null,
    authorizationtype   VARCHAR          not null,
    max_tokens          VARCHAR          not null,
    authorization_type   VARCHAR         not null,
    msg                   VARCHAR        not null,
    expiration            VARCHAR        not null,
    FOREIGN KEY (tx_id) REFERENCES transactions(tx_id),
    FOREIGN KEY (send_address_id) REFERENCES address(address_id),
    FOREIGN KEY (receive_address_id) REFERENCES address(address_id)

);

create table cosmos_grant_allowlist
(
    address_id      uuid default gen_random_uuid() not null
        primary key,
    message_id      uuid                    not null,
    addresses       VARCHAR                 not null,
    FOREIGN KEY (message_id) REFERENCES cosmos_grant_msg(message_id)
    
);



-- cosmos_authz_v1beta1_MsgRevoke table 

create table cosmos_revoke_msg
(
    message_id         uuid default gen_random_uuid() not null
        primary key,
    tx_id               uuid                  not null,
    send_address_id     uuid             not null,
    receive_address_id  uuid             not null,
    tx_type             VARCHAR          not null,
    msg_type_url        VARCHAR         not null,
    FOREIGN KEY (tx_id) REFERENCES transactions(tx_id),
    FOREIGN KEY (send_address_id) REFERENCES address(address_id),
    FOREIGN KEY (receive_address_id) REFERENCES address(address_id)
);



-- cosmos_bank_v1beta1_MsgSend table

create table cosmos_send_msg
(
    message_id         uuid default gen_random_uuid() not null
        primary key,
    tx_id               uuid                  not null,
    from_address_id          uuid             not null,
    to_address_id          uuid             not null,    
    tx_type             VARCHAR          not null,
    tx_denom            VARCHAR          not null,
    amount              VARCHAR          not null,
    FOREIGN KEY (tx_id) REFERENCES transactions(tx_id),
    FOREIGN KEY (from_address_id) REFERENCES address(address_id),
    FOREIGN KEY (to_address_id) REFERENCES address(address_id)
);





-- cosmos_distribution_v1beta1_MsgWithdrawDelegatorReward table

create table cosmos_withdrawdelegatorreward_msg
(
    message_id         uuid default gen_random_uuid() not null
        primary key,
    tx_id               uuid                  not null,
    delegator_address_id          uuid             not null,
    validator_address_id          uuid             not null,    
    tx_type             VARCHAR          not null,
    FOREIGN KEY (tx_id) REFERENCES transactions(tx_id),
    FOREIGN KEY (delegator_address_id) REFERENCES address(address_id),
    FOREIGN KEY (validator_address_id) REFERENCES address(address_id)
);





-- cosmos_staking_v1beta1_MsgBeginRedelegate table

create table cosmos_beginredelegate_msg
(
    message_id         uuid default gen_random_uuid() not null
        primary key,
    tx_id               uuid                  not null,
    delegator_address_id              uuid             not null,
    validator_src_address_id          uuid             not null,
    validator_dst_address_id          uuid             not null,    
    tx_type             VARCHAR          not null,
    tx_denom            VARCHAR          not null,
    amount              VARCHAR          not null,
    FOREIGN KEY (tx_id) REFERENCES transactions(tx_id),
    FOREIGN KEY (delegator_address_id) REFERENCES address(address_id),
    FOREIGN KEY (validator_src_address_id) REFERENCES address(address_id),
    FOREIGN KEY (validator_dst_address_id) REFERENCES address(address_id)
);





-- cosmos_staking_v1beta1_MsgDelegate table

create table cosmos_delegate_msg
(
    message_id         uuid default gen_random_uuid() not null
        primary key,
    tx_id               uuid                  not null,
    delegator_address_id          uuid             not null,
    validator_address_id          uuid             not null, 
    tx_type             VARCHAR          not null,   
    tx_denom            VARCHAR          not null,
    amount              VARCHAR         not null,
    FOREIGN KEY (tx_id) REFERENCES transactions(tx_id),
    FOREIGN KEY (delegator_address_id) REFERENCES address(address_id),
    FOREIGN KEY (validator_address_id) REFERENCES address(address_id)
);




-- cosmos_staking_v1beta1_MsgUndelegate table

create table cosmos_undelegate_msg
(
    message_id         uuid default gen_random_uuid() not null
        primary key,
    tx_id               uuid                  not null,
    delegator_address_id          uuid             not null,
    validator_address_id          uuid             not null, 
    tx_type             VARCHAR          not null,   
    tx_denom            VARCHAR          not null,
    amount              VARCHAR         not null,
    FOREIGN KEY (tx_id) REFERENCES transactions(tx_id),
    FOREIGN KEY (delegator_address_id) REFERENCES address(address_id),
    FOREIGN KEY (validator_address_id) REFERENCES address(address_id)
);




-- cosmwasm_wasm_v1_MsgExecuteContract table   contracts to another table 

create table cosmwasm_executecontract_msg
(
    message_id         uuid default gen_random_uuid() not null
        primary key,
    tx_id               uuid                  not null,
    send_address_id          uuid             not null,    
    tx_type             VARCHAR          not null,
    contracts           VARCHAR         not null,
    msg                 VARCHAR          not null,
    tx_denom            VARCHAR        not null,
    amount              VARCHAR          not null,
    FOREIGN KEY (tx_id) REFERENCES transactions(tx_id),
    FOREIGN KEY (send_address_id) REFERENCES address(address_id)
);



-- cosmwasm_wasm_v1_MsgInstantiateContract table

create table cosmwasm_instantiatecontract_msg
(
    message_id         uuid default gen_random_uuid() not null
        primary key,
    tx_id               uuid                  not null,
    send_address_id          uuid             not null,
    admin_address_id    uuid             not null, 
    tx_type             VARCHAR          not null,
    code_id             VARCHAR          not null,
    label               VARCHAR          not null,
    msg                 VARCHAR          not null,
    funds               VARCHAR          not null,
    FOREIGN KEY (tx_id) REFERENCES transactions(tx_id),
    FOREIGN KEY (send_address_id) REFERENCES address(address_id),
    FOREIGN KEY (admin_address_id) REFERENCES address(address_id)

);



-- cosmwasm_wasm_v1_MsgStoreCode table

create table cosmwasm_storecode_msg
(
    message_id         uuid default gen_random_uuid() not null
        primary key,
    tx_id                   uuid               not null,
    sender_address_id          uuid             not null,    
    tx_type             VARCHAR          not null,
    wasm_byte_code          VARCHAR          not null,
    instantiate_permission  VARCHAR         not null,
    FOREIGN KEY (tx_id) REFERENCES transactions(tx_id),
    FOREIGN KEY (sender_address_id) REFERENCES address(address_id)
);



-- ibc_applications_transfer_v1_MsgTransfer table

create table ibc_transfer_msg
(
    message_id         uuid default gen_random_uuid() not null
        primary key,
    tx_id                                   uuid             not null,
    sender_address_id                       uuid             not null,
    receiver_address_id                     uuid             not null,    
    tx_type                                 VARCHAR          not null,
    source_port                             VARCHAR          not null,
    source_channel                          VARCHAR          not null,
    token_denom                             VARCHAR          not null,
    token_amount                            VARCHAR          not null,
    timeout_height_revision_num             VARCHAR          not null,
    timeout_height_revision_height          VARCHAR          not null,
    timeout_timestamp                       VARCHAR          not null,
    memo                                    VARCHAR          not null,
    FOREIGN KEY (tx_id) REFERENCES transactions(tx_id),
    FOREIGN KEY (sender_address_id) REFERENCES address(address_id),
    FOREIGN KEY (receiver_address_id) REFERENCES address(address_id)
);



-- ibc_core_client_v1_MsgUpdateClient table

create table ibc_updateclient_msg
(
    message_id         uuid default gen_random_uuid() not null
        primary key,
    tx_id                           uuid               not null,    
    tx_type                         VARCHAR          not null,
    client_id                       VARCHAR          not null,
    client_message                  jsonb              not null,
    signer                          VARCHAR          not null,
    FOREIGN KEY (tx_id) REFERENCES transactions(tx_id)
);


-- ibc.core.channel.v1.MsgTimeout table 

create table ibc_timeout_msg
(
    message_id         uuid default gen_random_uuid() not null
        primary key,
    tx_id                           uuid               not null,    
    tx_type                         VARCHAR          not null,
    sequence_num                    VARCHAR          not null,
    source_port                     VARCHAR          not null,
    source_channel                  VARCHAR          not null,
    destination_port                VARCHAR          not null,
    destination_channel             VARCHAR          not null,
    data                            VARCHAR          not null,
    timeout_height_revision_number  VARCHAR          not null,
    timeout_height_revision_height  VARCHAR          not null,
    timeout_timestamp               VARCHAR          not null,
    proof_unreceived                VARCHAR          not null,
    proof_height_revision_number    VARCHAR          not null,
    proof_height_revision_height    VARCHAR          not null,
    next_seq_recv                   VARCHAR          not null,
    signer                          VARCHAR          not null,
    FOREIGN KEY (tx_id) REFERENCES transactions(tx_id)
);



-- ibc_core_channel_v1_MsgRecvPacket table

create table ibc_recvpacket_msg
(
    message_id         uuid default gen_random_uuid() not null
        primary key,
    tx_id                           uuid               not null,    
    tx_type                         VARCHAR          not null,
    sequence_num                    VARCHAR          not null,
    source_port                     VARCHAR          not null,
    source_channel                  VARCHAR          not null,
    destination_port                VARCHAR          not null,
    destination_channel             VARCHAR          not null,
    data                            VARCHAR          not null,
    timeout_height_revision_number  VARCHAR          not null,
    timeout_height_revision_height  VARCHAR          not null,
    timeout_timestamp               VARCHAR          not null,
    proof_commitment                VARCHAR          not null,
    proof_height_revision_number    VARCHAR          not null,
    proof_height_revision_height    VARCHAR          not null,
    signer                          VARCHAR          not null,
    FOREIGN KEY (tx_id) REFERENCES transactions(tx_id)
);



-- ibc_core_channel_v1_MsgAcknowledgement table

create table ibc_acknowledgement_msg
(
    message_id         uuid default gen_random_uuid() not null
        primary key,
    tx_id                           uuid               not null,    
    tx_type                         VARCHAR          not null,
    sequence_num                    VARCHAR          not null,
    source_port                     VARCHAR          not null,
    source_channel                  VARCHAR          not null,
    destination_port                VARCHAR          not null,
    destination_channel             VARCHAR          not null,
    data                            VARCHAR          not null,
    timeout_height_revision_number  VARCHAR          not null,
    timeout_height_revision_height  VARCHAR          not null,
    timeout_timestamp               VARCHAR          not null,
    acknowledgement                 VARCHAR          not null,
    proof_acked                     VARCHAR          not null,
    proof_height_revision_number    VARCHAR          not null,
    proof_height_revision_height    VARCHAR          not null,
    signer                          VARCHAR          not null,
    FOREIGN KEY (tx_id) REFERENCES transactions(tx_id)
);


-- ibc.core.channel.v1.MsgChannelOpenConfirm table

create table ibc_channelopenconfirm_msg
(
    message_id         uuid default gen_random_uuid() not null
        primary key,
    tx_id                           uuid               not null,    
    tx_type                         VARCHAR          not null,
    port_id                         VARCHAR          not null,
    channel_id                      VARCHAR          not null,
    proof_acked                     VARCHAR          not null,
    proof_height_revision_number    VARCHAR          not null,
    proof_height_revision_height    VARCHAR          not null,
    signer                          VARCHAR          not null,
    FOREIGN KEY (tx_id) REFERENCES transactions(tx_id)
);



-- ibc.core.channel.v1.MsgChannelOpenTry table

create table ibc_channelopentry_msg
(
    message_id         uuid default gen_random_uuid() not null
        primary key,
    tx_id                           uuid               not null,    
    tx_type                         VARCHAR          not null,
    port_id                         VARCHAR          not null,
    previous_channel_id             VARCHAR          not null,
    channel_state                   VARCHAR          not null,
    channel_ordering                VARCHAR          not null,
    counterparty_port_id            VARCHAR          not null,
    counterparty_channel_id         VARCHAR          not null,
    connection_hops                 VARCHAR          not null,
    version                         VARCHAR          not null,
    counterparty_version            VARCHAR          not null,
    proof_init                      VARCHAR          not null,
    proof_height_revision_number    VARCHAR          not null,
    proof_height_revision_height    VARCHAR          not null,
    signer                          VARCHAR          not null,
    FOREIGN KEY (tx_id) REFERENCES transactions(tx_id)
);



-- cosmos.staking.v1beta1.MsgEditValidator Table

create table cosmos_editvalidator_msg
(
    message_id         uuid default gen_random_uuid() not null
        primary key,
    tx_id                           uuid               not null,
    validator_address_id            uuid             not null,    
    tx_type                         VARCHAR          not null,
    description_moniker             VARCHAR          not null,
    description_identity            VARCHAR          not null,
    description_website             VARCHAR          not null,
    description_security_contact    VARCHAR          not null,
    description_details             VARCHAR          not null,
    commission_rate                 VARCHAR          not null,
    min_self_delegation             VARCHAR          not null,
    FOREIGN KEY (tx_id) REFERENCES transactions(tx_id),
    FOREIGN KEY (validator_address_id) REFERENCES address(address_id)
);


-- address table for all types of addresses

create table address 
(
    address_id         uuid default gen_random_uuid() not null
        primary key,   
    address_type    VARCHAR       not null,
    address         VARCHAR       not null,
    comment         VARCHAR       not null,
    created_at      timestamp     not null,
    updated_at      timestamp     not null
);

