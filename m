From: Dag Moxnes <dag.moxnes-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH infiniband-diags v3] ibportstate: Fixed switch peer port
 probing when using DR routing
Date: Mon, 24 Oct 2016 16:37:24 +0200
Message-ID: <580E1CA4.5040101@oracle.com>
References: <22b5963c36776d0b03eb0f6706323b4ba4bafac9.1477315879.git-series.knut.omang@oracle.com>
 <02e18a78-ba54-d7a2-c3fe-3e4d392f5593@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <02e18a78-ba54-d7a2-c3fe-3e4d392f5593-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Knut Omang <knut.omang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Line Holen <line.holen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



On 10/24/2016 03:50 PM, Hal Rosenstock wrote:
> On 10/24/2016 9:34 AM, Knut Omang wrote:
>> From: Dag Moxnes <dag.moxnes-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
>>
>> ibportstate queries to a remote peer port on a switch using direct
>> routing would result in timeouts. The reason for this is that the
>> DR path was not correctly constructed.
>>
>> Signed-off-by: Dag Moxnes <dag.moxnes-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
>> Reviewed-by: Line Holen <line.holen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
>> Signed-off-by: Knut Omang <knut.omang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
>> ---
>>   src/ibportstate.c | 26 +++++++++++++++++---------
>>   1 file changed, 17 insertions(+), 9 deletions(-)
>>
>> diff --git a/src/ibportstate.c b/src/ibportstate.c
>> index cfb8be7..82cbcc2 100644
>> --- a/src/ibportstate.c
>> +++ b/src/ibportstate.c
>> @@ -1,6 +1,7 @@
>>   /*
>>    * Copyright (c) 2004-2009 Voltaire Inc.  All rights reserved.
>>    * Copyright (c) 2010,2011 Mellanox Technologies LTD.  All rights reserved.
>> + * Copyright (c) 2011,2016 Oracle and/or its affiliates. All rights reserved.
>>    *
>>    * This software is available to you under a choice of one of two
>>    * licenses.  You may choose to be licensed under the terms of the GNU
>> @@ -655,15 +656,22 @@ int main(int argc, char **argv)
>>   
>>   			/* Setup portid for peer port */
>>   			memcpy(&peerportid, &portid, sizeof(peerportid));
>> -			peerportid.drpath.cnt = 1;
>> -			peerportid.drpath.p[1] = (uint8_t) portnum;
>> -
>> -			/* Set DrSLID to local lid */
>> -			if (resolve_self(ibd_ca, ibd_ca_port, &selfportid,
>> -						&selfport, 0) < 0)
>> -				IBEXIT("could not resolve self");
>> -			peerportid.drpath.drslid = (uint16_t) selfportid.lid;
>> -			peerportid.drpath.drdlid = 0xffff;
>> +			if (portid.lid == 0) {
>> +				peerportid.drpath.cnt++;
>> +				if (peerportid.drpath.cnt == IB_SUBNET_PATH_HOPS_MAX) {
>> +					IBEXIT("Too many hops");
>> +				}
>> +			} else {
>> +				peerportid.drpath.cnt = 1;
>> +
>> +				/* Set DrSLID to local lid */
>> +				if (resolve_self(ibd_ca, ibd_ca_port, &selfportid,
>> +						         &selfport, 0) < 0)
>> +					IBEXIT("could not resolve self");
>> +				peerportid.drpath.drslid = selfportid.lid;
> Why was casting of selfportid.lid to (uint16_t) dropped ?
That was not intentional. Thanks for pointing it out.

Regards,
-Dag
>
>> +				peerportid.drpath.drdlid = 0xffff;
>> +			}
>> +			peerportid.drpath.p[peerportid.drpath.cnt] = (uint8_t) portnum;
>>   
>>   			/* Get peer port NodeInfo to obtain peer port number */
>>   			is_peer_switch = get_node_info(&peerportid, data);
>>
>> base-commit: 17e03b4738913365a3f947719c4897fcb92df32c
>>

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
