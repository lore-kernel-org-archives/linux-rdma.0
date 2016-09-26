From: Dag Moxnes <dag.moxnes-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH infiniband-diags] ibportstate: Fixed peer port probing
 when using DR routing
Date: Mon, 26 Sep 2016 10:12:18 +0200
Message-ID: <57E8D862.8060407@oracle.com>
References: <430aa17fd12cdcfd735b4215938dc4279e33572d.1474612678.git-series.knut.omang@oracle.com>
 <01da2b4d-270a-f8c9-3d5f-ec7a4c0b7d22@dev.mellanox.co.il>
 <20160926053442.GE29780@phlsvsds.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160926053442.GE29780-W4f6Xiosr+yv7QzWx2u06xL4W9x8LtSr@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Knut Omang <knut.omang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Line Holen <line.holen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



On 09/26/2016 07:34 AM, ira.weiny wrote:
> On Fri, Sep 23, 2016 at 09:06:45AM -0400, Hal Rosenstock wrote:
>> On 9/23/2016 2:42 AM, Knut Omang wrote:
>>> From: Dag Moxnes <dag.moxnes-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
>> Title might be better as:
>> ibportstate: Fixed switch peer port probing when using DR routing
> Agreed.
Thanks for the suggestion. I will change this.
>
>
>>> When querying a remote port
>> on a switch
I will change this.
>>
>>> using ibportportstate,
>> Typo: ibportstate
I will change this.
>>
>>> queries to the peer port
>>> would result in timeouts. The reason for this is that the DR path (or partial
>>> DR path was not correctly constructed.
>> It looks like there are 2 cases fixed below and it's best to describe
>> them. My take on it is:
>> 1. local LID (for switch port 0) is not yet configured
>> 2. SMI requester port (I think this is what you term remote port above)
>> is on local rather than remote switch
>> Is that accurate ?
It is correct that this patch does cover 2 cases.

The two cases are:
1. The user has run ibportstate with a direct route, e.g.
     "ibportstate -D 0,1,15 6"

    In this case, the current implementation will use a direct route of
    "0,6" when probing the peer node. Instead, the portnumber it should 
be using the
    direct route "0,1,15,6".

2. The other case is actually a workaround for a problem with partial DR 
routing on
     some of our switches. As this is a workaround for a problem 
elsewhere, I release
     that it should not be part of the ibportstate utility. I will 
remove this part of the
     commit.
>>
>>> Signed-off-by: Dag Moxnes <dag.moxnes-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
>>> Reviewed-by: Line Holen <line.holen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
>>> Signed-off-by: Knut Omang <knut.omang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
>>> ---
>>>   src/ibportstate.c | 36 +++++++++++++++++++++++++++---------
>>>   1 file changed, 27 insertions(+), 9 deletions(-)
>>>
>>> diff --git a/src/ibportstate.c b/src/ibportstate.c
>>> index cb47aa9..cd0f680 100644
>>> --- a/src/ibportstate.c
>>> +++ b/src/ibportstate.c
>>> @@ -1,6 +1,8 @@
>>>   /*
>>>    * Copyright (c) 2004-2009 Voltaire Inc.  All rights reserved.
>>>    * Copyright (c) 2010,2011 Mellanox Technologies LTD.  All rights reserved.
>>> + * Copyright (c) 2011, 2015, Oracle and/or its affiliates. All rights reserved.
>>> + *
>>>    *
>>>    * This software is available to you under a choice of one of two
>>>    * licenses.  You may choose to be licensed under the terms of the GNU
>>> @@ -655,15 +657,31 @@ int main(int argc, char **argv)
>>>   
>>>   			/* Setup portid for peer port */
>>>   			memcpy(&peerportid, &portid, sizeof(peerportid));
>>> -			peerportid.drpath.cnt = 1;
>>> -			peerportid.drpath.p[1] = (uint8_t) portnum;
>>> -
>>> -			/* Set DrSLID to local lid */
>>> -			if (resolve_self(ibd_ca, ibd_ca_port, &selfportid,
>>> -						&selfport, 0) < 0)
>>> -				IBEXIT("could not resolve self");
>>> -			peerportid.drpath.drslid = (uint16_t) selfportid.lid;
>>> -			peerportid.drpath.drdlid = 0xffff;
>>> +			if (portid.lid == 0) {
>>> +				peerportid.drpath.cnt = portid.drpath.cnt + 1;
> Nit: peerportid.drpath.cnt++;
Thanks I will change that.
>
> Ira
>
>>> +				if (peerportid.drpath.cnt == IB_SUBNET_PATH_HOPS_MAX) {
>>> +					exit(0);
>> Nit: IBEXIT("Too many hops") rather than exit(0)
Thanks, I will correct that.
>>
>>> +				}
>>> +				peerportid.drpath.p[peerportid.drpath.cnt] = (uint8_t) portnum;
>>> +			} else {
>>> +				/* Set DrSLID to local lid */
>>> +				if (resolve_portid_str(ibd_ca, ibd_ca_port, &portid, argv[0],
>>> +						       ibd_dest_type, ibd_sm_id, srcport) < 0)
>>> +					IBEXIT("could not resolve self");
>>> +
>>> +				peerportid.drpath.cnt = 1;
>>> +				peerportid.drpath.p[1] = (uint8_t) portnum;
>>> +
>>> +
>> Nit: Eliminate extra blank line
Thanks, I will correct that.
>>
>>> +				/* Use partial LID routing if remote switch */
>>> +				if ((portid.lid == selfportid.lid)) {
>>> +					peerportid.drpath.drslid = 0xffff;
>>> +					peerportid.drpath.drdlid = 0xffff;
>>> +				} else {
>>> +					peerportid.drpath.drslid = selfportid.lid;
>>> +					peerportid.drpath.drdlid = 0xffff;
>>> +				}
>> The following can be factored out of the above if/else:
>> 				peerportid.drpath.drdlid = 0xffff;
Thanks, I will do that (I believe this will removed from the commit as 
explained above).
>>
>>> +			}
>>>   
>>>   			/* Get peer port NodeInfo to obtain peer port number */
>>>   			is_peer_switch = get_node_info(&peerportid, data);
>>>
>>> base-commit: 2937cf99350a2e423b705e8b8dd10499796a7b41
>>>
Thanks for the review,
Dag
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
