From: Hal Rosenstock <hal@dev.mellanox.co.il>
Subject: Re: [PATCH IB/core 2/2] IB/cm: Send authentic pkey in REQ msg and
 check eligibility of the pkeys
Date: Thu, 10 May 2018 10:01:22 -0400
Message-ID: <3bee76df-49a6-cf3c-6df4-749a6309358e@dev.mellanox.co.il>
References: <20180509093020.24503-1-Haakon.Bugge@oracle.com>
 <20180509093020.24503-3-Haakon.Bugge@oracle.com>
 <ab1f16cd-aa60-0c43-841c-aed301fd2a7e@dev.mellanox.co.il>
 <F9802EE9-4420-44EE-93DC-27CC799B427E@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <F9802EE9-4420-44EE-93DC-27CC799B427E@oracle.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: =?UTF-8?Q?H=c3=a5kon_Bugge?= <haakon.bugge@oracle.com>
Cc: Doug Ledford <dledford@redhat.com>, Don Hiatt <don.hiatt@intel.com>, Ira Weiny <ira.weiny@intel.com>, Sean Hefty <sean.hefty@intel.com>, OFED mailing list <linux-rdma@vger.kernel.org>, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On 5/10/2018 5:16 AM, Håkon Bugge wrote:
> 
> 
>> On 9 May 2018, at 13:28, Hal Rosenstock <hal@dev.mellanox.co.il> wrote:
>>
>> On 5/9/2018 5:30 AM, Håkon Bugge wrote:
>>> There is no point in using RDMA CM to establish a connection between
>>> two QPs that cannot possible communicate. Particularly, if both the
>>> active and passive side use limited pkeys, they are not able to
>>> communicate.
>>>
>>> In order to detect this situation, the authentic pkey is used in the
>>> CM REQ message. The authentic pkey is the one that the HCA inserts
>>> into the BTH in the IB packets.
>>>
>>> When the passive side receives the REQ, commit ("ib_core: A full pkey
>>> is required to match a limited one") ensures that
>>> ib_find_matched_cached_pkey() fails unless at least one of the pkeys
>>> compared has the full-member bit.
>>>
>>> In the limited-to-limited case, this will prohibit the connection to
>>> be formed, and thus, Pkey Violation Traps will not be sent to the SM.
>>>
>>> Signed-off-by: Håkon Bugge <haakon.bugge@oracle.com>
>>> ---
>>> drivers/infiniband/core/cm.c | 39 ++++++++++++++++++++++++++++++++-------
>>> include/rdma/ib_cm.h         |  4 +++-
>>> 2 files changed, 35 insertions(+), 8 deletions(-)
>>>
>>> diff --git a/drivers/infiniband/core/cm.c b/drivers/infiniband/core/cm.c
>>> index a92e1a5c202b..52ed51d5bd2a 100644
>>> --- a/drivers/infiniband/core/cm.c
>>> +++ b/drivers/infiniband/core/cm.c
>>> @@ -3,6 +3,7 @@
>>>  * Copyright (c) 2004 Topspin Corporation.  All rights reserved.
>>>  * Copyright (c) 2004, 2005 Voltaire Corporation.  All rights reserved.
>>>  * Copyright (c) 2005 Sun Microsystems, Inc. All rights reserved.
>>> + * Copyright (c) 2018 Oracle and/or its affiliates. All rights reserved.
>>>  *
>>>  * This software is available to you under a choice of one of two
>>>  * licenses.  You may choose to be licensed under the terms of the GNU
>>> @@ -91,6 +92,7 @@ static const char * const ibcm_rej_reason_strs[] = {
>>> 	[IB_CM_REJ_INVALID_CLASS_VERSION]	= "invalid class version",
>>> 	[IB_CM_REJ_INVALID_FLOW_LABEL]		= "invalid flow label",
>>> 	[IB_CM_REJ_INVALID_ALT_FLOW_LABEL]	= "invalid alt flow label",
>>> +	[IB_CM_REJ_INVALID_PKEY]		= "invalid PKey",
>>
>> If this patch goes ahead, IBA spec for CM should be updated to include this.
> 
> Sure, I see:
> 
>  33 Invalid Alternate Flow Label
> 
> as the latest in the spec.

This appears to be an implementation rather than architectural issue. If
there is limited <-> limited CM, then the MAD would never get up to the
CM layer as it would be filtered by end port pkey enforcement. This is
only needed to protect against current code which can send on the full
rather than limited pkey (in BTH), right ?

>>
>>> };
>>>
>>> const char *__attribute_const__ ibcm_reject_msg(int reason)
>>> @@ -518,8 +520,8 @@ static int cm_init_av_by_path(struct sa_path_rec *path, struct cm_av *av,
>>> 		return -EINVAL;
>>> 	cm_dev = port->cm_dev;
>>>
>>> -	ret = ib_find_cached_pkey(cm_dev->ib_device, port->port_num,
>>> -				  be16_to_cpu(path->pkey), &av->pkey_index);
>>> +	ret = ib_find_matched_cached_pkey(cm_dev->ib_device, port->port_num,
>>> +					  be16_to_cpu(path->pkey), &av->pkey_index);
>>> 	if (ret)
>>> 		return ret;
>>>
>>> @@ -1241,7 +1243,7 @@ static void cm_format_req(struct cm_req_msg *req_msg,
>>> 	cm_req_set_starting_psn(req_msg, cpu_to_be32(param->starting_psn));
>>> 	cm_req_set_local_resp_timeout(req_msg,
>>> 				      param->local_cm_response_timeout);
>>> -	req_msg->pkey = param->primary_path->pkey;
>>> +	req_msg->pkey = cpu_to_be16(cm_id_priv->pkey);
>>> 	cm_req_set_path_mtu(req_msg, param->primary_path->mtu);
>>> 	cm_req_set_max_cm_retries(req_msg, param->max_cm_retries);
>>>
>>> @@ -1396,7 +1398,23 @@ int ib_send_cm_req(struct ib_cm_id *cm_id,
>>> 	cm_id_priv->responder_resources = param->responder_resources;
>>> 	cm_id_priv->retry_count = param->retry_count;
>>> 	cm_id_priv->path_mtu = param->primary_path->mtu;
>>> -	cm_id_priv->pkey = param->primary_path->pkey;
>>> +
>>> +	/*
>>> +	 * We want to send the pkey used in the BTH in packets
>>> +	 * sent. This, in order for the passive side to determine if
>>> +	 * communication is permitted by the respective pkeys.
>>> +	 *
>>> +	 * The pkey in the paths are derived from the MGID, which has
>>> +	 * the full membership bit set. Hence, we retrieve the pkey by
>>> +	 * using the address vector's pkey_index.
>>
>> The paths usually come from the SM and I don't expect SM to provide path
>> between ports of only limited members of partition.
> 
> In my case, it does. 

Which OpenSM flavor are you talking about (upstream, MLNX, or other) ?
What is OpenSM version string ? Is allow_both_pkeys TRUE or FALSE ?

>> Default ACM provider
>> forms path from multicast group parameters including pkey. Is that the
>> scenario of concern ?
> 
> Also RDMA CM does that. Do an ibdump of a CM REQ message sent from a limited port, and you will see the PKey is the full member in the CM REQ msg.

Not exactly sure what you mean by RDMA CM does this as there are a
number of different ways to use RDMA CM. Are you referring to using
IPoIB for address resolution ? Another way is for a path record to be
passed in from user space and there is no control over it's contents.

At a minimum, I think the comment mentioning MGID should be clarified.

>> If so, I still don't fully understand the scenario
>> because limited members are not supposed to be part of a multicast
>> group. There was some work started to extend this for client/server
>> model but it was never completed. However, there may be hole(s) in
>> various components of implementation which open(s) this door.
> 
> I view OpenSM not returning a valid path between two limited members an orthogonal issue, as OpenSM is another component.

Agreed. I think that there are other components too...

> I think the CM REQ message should contain the correct PKey (fixed by this patch series).
> 
> And in the event the passive side being a limited member and receives a CM REQ with a limited PKey, that connection should not be formed (fixed by this patch series).
This is the backward compatibility for the current behavior on the
active side so that REQ gets rejected rather than accepted, right ?

In general, the approach used when there is pkey mismatch is to silently
drop packet rather than respond which causes a timeout on the requester
side. In this specific case, I'm not sure which approach is better.

Also, is there a similar issue with SIDR_REQ ?

> Read me correct, I am also in favour of fixing the OpenSM to not return a valid (but useless) path record in this case.

Understood and agreed.

-- Hal

> 
> Thxs, Håkon
> 
> 
>>
>> -- Hal
>>
>>> +	 */
>>> +	ret = ib_get_cached_pkey(cm_id_priv->id.device,
>>> +				 cm_id_priv->av.port->port_num,
>>> +				 cm_id_priv->av.pkey_index,
>>> +				 &cm_id_priv->pkey);
>>> +	if (ret)
>>> +		goto error1;
>>> +
>>> 	cm_id_priv->qp_type = param->qp_type;
>>>
>>> 	ret = cm_alloc_msg(cm_id_priv, &cm_id_priv->msg);
>>> @@ -1956,16 +1974,19 @@ static int cm_req_handler(struct cm_work *work)
>>> 				 cm_id_priv);
>>> 	if (ret) {
>>> 		int err;
>>> +		int rej_reason = (ret == -ENOENT ?
>>> +				  IB_CM_REJ_INVALID_PKEY :
>>> +				  IB_CM_REJ_INVALID_GID);
>>>
>>> 		err = ib_get_cached_gid(work->port->cm_dev->ib_device,
>>> 					work->port->port_num, 0,
>>> 					&work->path[0].sgid,
>>> 					NULL);
>>> 		if (err)
>>> -			ib_send_cm_rej(cm_id, IB_CM_REJ_INVALID_GID,
>>> +			ib_send_cm_rej(cm_id, rej_reason,
>>> 				       NULL, 0, NULL, 0);
>>> 		else
>>> -			ib_send_cm_rej(cm_id, IB_CM_REJ_INVALID_GID,
>>> +			ib_send_cm_rej(cm_id, rej_reason,
>>> 				       &work->path[0].sgid,
>>> 				       sizeof(work->path[0].sgid),
>>> 				       NULL, 0);
>>> @@ -1975,7 +1996,11 @@ static int cm_req_handler(struct cm_work *work)
>>> 		ret = cm_init_av_by_path(&work->path[1], &cm_id_priv->alt_av,
>>> 					 cm_id_priv);
>>> 		if (ret) {
>>> -			ib_send_cm_rej(cm_id, IB_CM_REJ_INVALID_ALT_GID,
>>> +			int rej_reason = (ret == -ENOENT ?
>>> +					  IB_CM_REJ_INVALID_PKEY :
>>> +					  IB_CM_REJ_INVALID_ALT_GID);
>>> +
>>> +			ib_send_cm_rej(cm_id, rej_reason,
>>> 				       &work->path[0].sgid,
>>> 				       sizeof(work->path[0].sgid), NULL, 0);
>>> 			goto rejected;
>>> diff --git a/include/rdma/ib_cm.h b/include/rdma/ib_cm.h
>>> index 7979cb04f529..56b62303946a 100644
>>> --- a/include/rdma/ib_cm.h
>>> +++ b/include/rdma/ib_cm.h
>>> @@ -3,6 +3,7 @@
>>>  * Copyright (c) 2004 Topspin Corporation.  All rights reserved.
>>>  * Copyright (c) 2004 Voltaire Corporation.  All rights reserved.
>>>  * Copyright (c) 2005 Sun Microsystems, Inc. All rights reserved.
>>> + * Copyright (c) 2018 Oracle and/or its affiliates. All rights reserved.
>>>  *
>>>  * This software is available to you under a choice of one of two
>>>  * licenses.  You may choose to be licensed under the terms of the GNU
>>> @@ -183,7 +184,8 @@ enum ib_cm_rej_reason {
>>> 	IB_CM_REJ_DUPLICATE_LOCAL_COMM_ID	= 30,
>>> 	IB_CM_REJ_INVALID_CLASS_VERSION		= 31,
>>> 	IB_CM_REJ_INVALID_FLOW_LABEL		= 32,
>>> -	IB_CM_REJ_INVALID_ALT_FLOW_LABEL	= 33
>>> +	IB_CM_REJ_INVALID_ALT_FLOW_LABEL	= 33,
>>> +	IB_CM_REJ_INVALID_PKEY			= 34,
>>> };
>>>
>>> struct ib_cm_rej_event_param {
>>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
