From: =?utf-8?Q?H=C3=A5kon_Bugge?= <haakon.bugge@oracle.com>
Subject: Re: [PATCH IB/core 2/2] IB/cm: Send authentic pkey in REQ msg and
 check eligibility of the pkeys
Date: Thu, 10 May 2018 17:16:28 +0200
Message-ID: <B3360947-5905-47BD-ABC4-6C4BB32F5DA6@oracle.com>
References: <20180509093020.24503-1-Haakon.Bugge@oracle.com>
 <20180509093020.24503-3-Haakon.Bugge@oracle.com>
 <ab1f16cd-aa60-0c43-841c-aed301fd2a7e@dev.mellanox.co.il>
 <F9802EE9-4420-44EE-93DC-27CC799B427E@oracle.com>
 <3bee76df-49a6-cf3c-6df4-749a6309358e@dev.mellanox.co.il>
Mime-Version: 1.0 (Mac OS X Mail 11.3 \(3445.6.18\))
Content-Type: text/plain;
        charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <3bee76df-49a6-cf3c-6df4-749a6309358e@dev.mellanox.co.il>
Sender: linux-kernel-owner@vger.kernel.org
To: Hal Rosenstock <hal@dev.mellanox.co.il>
Cc: Doug Ledford <dledford@redhat.com>, Don Hiatt <don.hiatt@intel.com>, Ira Weiny <ira.weiny@intel.com>, Sean Hefty <sean.hefty@intel.com>, OFED mailing list <linux-rdma@vger.kernel.org>, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org



> On 10 May 2018, at 16:01, Hal Rosenstock <hal@dev.mellanox.co.il> =
wrote:
>=20
> On 5/10/2018 5:16 AM, H=C3=A5kon Bugge wrote:
>>=20
>>=20
>>> On 9 May 2018, at 13:28, Hal Rosenstock <hal@dev.mellanox.co.il> =
wrote:
>>>=20
>>> On 5/9/2018 5:30 AM, H=C3=A5kon Bugge wrote:
>>>> There is no point in using RDMA CM to establish a connection =
between
>>>> two QPs that cannot possible communicate. Particularly, if both the
>>>> active and passive side use limited pkeys, they are not able to
>>>> communicate.
>>>>=20
>>>> In order to detect this situation, the authentic pkey is used in =
the
>>>> CM REQ message. The authentic pkey is the one that the HCA inserts
>>>> into the BTH in the IB packets.
>>>>=20
>>>> When the passive side receives the REQ, commit ("ib_core: A full =
pkey
>>>> is required to match a limited one") ensures that
>>>> ib_find_matched_cached_pkey() fails unless at least one of the =
pkeys
>>>> compared has the full-member bit.
>>>>=20
>>>> In the limited-to-limited case, this will prohibit the connection =
to
>>>> be formed, and thus, Pkey Violation Traps will not be sent to the =
SM.
>>>>=20
>>>> Signed-off-by: H=C3=A5kon Bugge <haakon.bugge@oracle.com>
>>>> ---
>>>> drivers/infiniband/core/cm.c | 39 =
++++++++++++++++++++++++++++++++-------
>>>> include/rdma/ib_cm.h         |  4 +++-
>>>> 2 files changed, 35 insertions(+), 8 deletions(-)
>>>>=20
>>>> diff --git a/drivers/infiniband/core/cm.c =
b/drivers/infiniband/core/cm.c
>>>> index a92e1a5c202b..52ed51d5bd2a 100644
>>>> --- a/drivers/infiniband/core/cm.c
>>>> +++ b/drivers/infiniband/core/cm.c
>>>> @@ -3,6 +3,7 @@
>>>> * Copyright (c) 2004 Topspin Corporation.  All rights reserved.
>>>> * Copyright (c) 2004, 2005 Voltaire Corporation.  All rights =
reserved.
>>>> * Copyright (c) 2005 Sun Microsystems, Inc. All rights reserved.
>>>> + * Copyright (c) 2018 Oracle and/or its affiliates. All rights =
reserved.
>>>> *
>>>> * This software is available to you under a choice of one of two
>>>> * licenses.  You may choose to be licensed under the terms of the =
GNU
>>>> @@ -91,6 +92,7 @@ static const char * const ibcm_rej_reason_strs[] =
=3D {
>>>> 	[IB_CM_REJ_INVALID_CLASS_VERSION]	=3D "invalid class =
version",
>>>> 	[IB_CM_REJ_INVALID_FLOW_LABEL]		=3D "invalid flow =
label",
>>>> 	[IB_CM_REJ_INVALID_ALT_FLOW_LABEL]	=3D "invalid alt flow =
label",
>>>> +	[IB_CM_REJ_INVALID_PKEY]		=3D "invalid PKey",
>>>=20
>>> If this patch goes ahead, IBA spec for CM should be updated to =
include this.
>>=20
>> Sure, I see:
>>=20
>> 33 Invalid Alternate Flow Label
>>=20
>> as the latest in the spec.
>=20
> This appears to be an implementation rather than architectural issue. =
If
> there is limited <-> limited CM, then the MAD would never get up to =
the
> CM layer as it would be filtered by end port pkey enforcement. This is
> only needed to protect against current code which can send on the full
> rather than limited pkey (in BTH), right ?

We are talking about two things here. The PKey in the BTH and the PKey =
in the CM REQ payload. They differ.

I am out of office, but if my memory serves me correct, the PKey in the =
BTH in the MAD packet will be the default PKey. Further, we have per =
IBTA:

C10-132: Packets sent to the General Service Interface QP (QP1) shall be =
accepted if the P_Key in the packet matches any valid P_Key in the P_Key =
Table of the port on which the packet arrived. Matching is defined in =
10.9.3 Partition Key Matching.

So, by architecture, the MAD arrives.

>=20
>=20
>>>=20
>>>> };
>>>>=20
>>>> const char *__attribute_const__ ibcm_reject_msg(int reason)
>>>> @@ -518,8 +520,8 @@ static int cm_init_av_by_path(struct =
sa_path_rec *path, struct cm_av *av,
>>>> 		return -EINVAL;
>>>> 	cm_dev =3D port->cm_dev;
>>>>=20
>>>> -	ret =3D ib_find_cached_pkey(cm_dev->ib_device, port->port_num,
>>>> -				  be16_to_cpu(path->pkey), =
&av->pkey_index);
>>>> +	ret =3D ib_find_matched_cached_pkey(cm_dev->ib_device, =
port->port_num,
>>>> +					  be16_to_cpu(path->pkey), =
&av->pkey_index);
>>>> 	if (ret)
>>>> 		return ret;
>>>>=20
>>>> @@ -1241,7 +1243,7 @@ static void cm_format_req(struct cm_req_msg =
*req_msg,
>>>> 	cm_req_set_starting_psn(req_msg, =
cpu_to_be32(param->starting_psn));
>>>> 	cm_req_set_local_resp_timeout(req_msg,
>>>> 				      param->local_cm_response_timeout);
>>>> -	req_msg->pkey =3D param->primary_path->pkey;
>>>> +	req_msg->pkey =3D cpu_to_be16(cm_id_priv->pkey);
>>>> 	cm_req_set_path_mtu(req_msg, param->primary_path->mtu);
>>>> 	cm_req_set_max_cm_retries(req_msg, param->max_cm_retries);
>>>>=20
>>>> @@ -1396,7 +1398,23 @@ int ib_send_cm_req(struct ib_cm_id *cm_id,
>>>> 	cm_id_priv->responder_resources =3D param->responder_resources;
>>>> 	cm_id_priv->retry_count =3D param->retry_count;
>>>> 	cm_id_priv->path_mtu =3D param->primary_path->mtu;
>>>> -	cm_id_priv->pkey =3D param->primary_path->pkey;
>>>> +
>>>> +	/*
>>>> +	 * We want to send the pkey used in the BTH in packets
>>>> +	 * sent. This, in order for the passive side to determine if
>>>> +	 * communication is permitted by the respective pkeys.
>>>> +	 *
>>>> +	 * The pkey in the paths are derived from the MGID, which has
>>>> +	 * the full membership bit set. Hence, we retrieve the pkey by
>>>> +	 * using the address vector's pkey_index.
>>>=20
>>> The paths usually come from the SM and I don't expect SM to provide =
path
>>> between ports of only limited members of partition.
>>=20
>> In my case, it does.=20
>=20
> Which OpenSM flavor are you talking about (upstream, MLNX, or other) ?

I guess other is the right term, as its Oracle=E2=80=99s flavour, =
3.2.6_20170609.

> What is OpenSM version string ? Is allow_both_pkeys TRUE or FALSE ?

The ports do have both limited and full memberships, and the =
partitions.conf file contains both =E2=80=9Climited=E2=80=9D, =
=E2=80=9Cboth=E2=80=9D, and the =E2=80=9Cfull=E2=80=9D keywords.

>>> Default ACM provider
>>> forms path from multicast group parameters including pkey. Is that =
the
>>> scenario of concern ?
>>=20
>> Also RDMA CM does that. Do an ibdump of a CM REQ message sent from a =
limited port, and you will see the PKey is the full member in the CM REQ =
msg.
>=20
> Not exactly sure what you mean by RDMA CM does this as there are a
> number of different ways to use RDMA CM.

I am talking specifically about the CM REQ message. For example, if you =
run an IB-UV test program and specifies that RDMA CM should be used for =
connection management. Or it could be kernel ULPs. My point is that the =
pkey field in the CM REQ message (i.e. not the one in the BTH) is always =
the full one, even though the port uses the limited one.

> Are you referring to using
> IPoIB for address resolution ? Another way is for a path record to be
> passed in from user space and there is no control over it=E2=80=99s =
contents.

I did not bring up the path record or address resolution issue ;-)

But I guess you are alluding to the limited-to-limited case should 1) =
not have been able to perform address resolution and/or 2) the path =
record should not have been returned. I agree to both 1) and 2).

But if both 1) and 2) succeeds, this patch series is a last resort to =
stop the connection to be established and avoid pkey trap violation =
traps being sent.

> At a minimum, I think the comment mentioning MGID should be clarified.

Is the question if an MC group attached by a limited port will include =
other limited ports or only full member ports?=20

With the OpenSM I am running, the MC group contains limited members.

>>> If so, I still don't fully understand the scenario
>>> because limited members are not supposed to be part of a multicast
>>> group. There was some work started to extend this for client/server
>>> model but it was never completed. However, there may be hole(s) in
>>> various components of implementation which open(s) this door.
>>=20
>> I view OpenSM not returning a valid path between two limited members =
an orthogonal issue, as OpenSM is another component.
>=20
> Agreed. I think that there are other components too...
>=20
>> I think the CM REQ message should contain the correct PKey (fixed by =
this patch series).
>>=20
>> And in the event the passive side being a limited member and receives =
a CM REQ with a limited PKey, that connection should not be formed =
(fixed by this patch series).
> This is the backward compatibility for the current behavior on the
> active side so that REQ gets rejected rather than accepted, right ?

Not sure about the backwards compatibility part, but I certainly agree =
to the rest. Put it another way, when the MAD payload=E2=80=99s pkey is =
limited in the CM REQ, and there is only a limited matching key in the =
pkey cache, a REJ is sent back.

> In general, the approach used when there is pkey mismatch is to =
silently
> drop packet rather than respond which causes a timeout on the =
requester
> side. In this specific case, I=E2=80=99m not sure which approach is =
better.

It is not silently dropped when the port supports pkey trap messages. =
Then a trap message is sent to the OpenSM.

> Also, is there a similar issue with SIDR_REQ ?

Good point, most probaly!

> Read me correct, I am also in favour of fixing the OpenSM to not =
return a valid (but useless) path record in this case.
>=20
> Understood and agreed.


Thxs, H=C3=A5kon

>=20
> -- Hal
>=20
>>=20
>> Thxs, H=C3=A5kon
>>=20
>>=20
>>>=20
>>> -- Hal
>>>=20
>>>> +	 */
>>>> +	ret =3D ib_get_cached_pkey(cm_id_priv->id.device,
>>>> +				 cm_id_priv->av.port->port_num,
>>>> +				 cm_id_priv->av.pkey_index,
>>>> +				 &cm_id_priv->pkey);
>>>> +	if (ret)
>>>> +		goto error1;
>>>> +
>>>> 	cm_id_priv->qp_type =3D param->qp_type;
>>>>=20
>>>> 	ret =3D cm_alloc_msg(cm_id_priv, &cm_id_priv->msg);
>>>> @@ -1956,16 +1974,19 @@ static int cm_req_handler(struct cm_work =
*work)
>>>> 				 cm_id_priv);
>>>> 	if (ret) {
>>>> 		int err;
>>>> +		int rej_reason =3D (ret =3D=3D -ENOENT ?
>>>> +				  IB_CM_REJ_INVALID_PKEY :
>>>> +				  IB_CM_REJ_INVALID_GID);
>>>>=20
>>>> 		err =3D ib_get_cached_gid(work->port->cm_dev->ib_device,
>>>> 					work->port->port_num, 0,
>>>> 					&work->path[0].sgid,
>>>> 					NULL);
>>>> 		if (err)
>>>> -			ib_send_cm_rej(cm_id, IB_CM_REJ_INVALID_GID,
>>>> +			ib_send_cm_rej(cm_id, rej_reason,
>>>> 				       NULL, 0, NULL, 0);
>>>> 		else
>>>> -			ib_send_cm_rej(cm_id, IB_CM_REJ_INVALID_GID,
>>>> +			ib_send_cm_rej(cm_id, rej_reason,
>>>> 				       &work->path[0].sgid,
>>>> 				       sizeof(work->path[0].sgid),
>>>> 				       NULL, 0);
>>>> @@ -1975,7 +1996,11 @@ static int cm_req_handler(struct cm_work =
*work)
>>>> 		ret =3D cm_init_av_by_path(&work->path[1], =
&cm_id_priv->alt_av,
>>>> 					 cm_id_priv);
>>>> 		if (ret) {
>>>> -			ib_send_cm_rej(cm_id, IB_CM_REJ_INVALID_ALT_GID,
>>>> +			int rej_reason =3D (ret =3D=3D -ENOENT ?
>>>> +					  IB_CM_REJ_INVALID_PKEY :
>>>> +					  IB_CM_REJ_INVALID_ALT_GID);
>>>> +
>>>> +			ib_send_cm_rej(cm_id, rej_reason,
>>>> 				       &work->path[0].sgid,
>>>> 				       sizeof(work->path[0].sgid), NULL, =
0);
>>>> 			goto rejected;
>>>> diff --git a/include/rdma/ib_cm.h b/include/rdma/ib_cm.h
>>>> index 7979cb04f529..56b62303946a 100644
>>>> --- a/include/rdma/ib_cm.h
>>>> +++ b/include/rdma/ib_cm.h
>>>> @@ -3,6 +3,7 @@
>>>> * Copyright (c) 2004 Topspin Corporation.  All rights reserved.
>>>> * Copyright (c) 2004 Voltaire Corporation.  All rights reserved.
>>>> * Copyright (c) 2005 Sun Microsystems, Inc. All rights reserved.
>>>> + * Copyright (c) 2018 Oracle and/or its affiliates. All rights =
reserved.
>>>> *
>>>> * This software is available to you under a choice of one of two
>>>> * licenses.  You may choose to be licensed under the terms of the =
GNU
>>>> @@ -183,7 +184,8 @@ enum ib_cm_rej_reason {
>>>> 	IB_CM_REJ_DUPLICATE_LOCAL_COMM_ID	=3D 30,
>>>> 	IB_CM_REJ_INVALID_CLASS_VERSION		=3D 31,
>>>> 	IB_CM_REJ_INVALID_FLOW_LABEL		=3D 32,
>>>> -	IB_CM_REJ_INVALID_ALT_FLOW_LABEL	=3D 33
>>>> +	IB_CM_REJ_INVALID_ALT_FLOW_LABEL	=3D 33,
>>>> +	IB_CM_REJ_INVALID_PKEY			=3D 34,
>>>> };
>>>>=20
>>>> struct ib_cm_rej_event_param {
>>>>=20
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe =
linux-rdma" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>=20
>>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
