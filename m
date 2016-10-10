From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH infiniband-diags v2] ibportstate: Fixed switch peer port
 probing when using DR routing
Date: Mon, 10 Oct 2016 18:04:40 -0400
Message-ID: <48f835a2-1919-6ea4-8173-3eb2740b4a3b@dev.mellanox.co.il>
References: <8d3851995d389220a979543740862bd8884cacac.1476089300.git-series.knut.omang@oracle.com>
 <079f879e-9b81-4faa-ab3b-1ea68a5e2799@dev.mellanox.co.il>
 <57FBFA2A.80003@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <57FBFA2A.80003-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dag Moxnes <dag.moxnes-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Knut Omang <knut.omang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Line Holen <line.holen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 10/10/2016 4:29 PM, Dag Moxnes wrote:
> 
> 
> Den 10.10.2016 16.57, skrev Hal Rosenstock:
>> On 10/10/2016 4:50 AM, Knut Omang wrote:
>>> From: Dag Moxnes <dag.moxnes-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
>>>
>>> ibportstate queries to a remote peer port on a switch using direct
>>> routing would result in timeouts. The reason for this is that the
>>> DR path was not correctly constructed.
>> Should the following be added here to make it clearer:
>> in case where local LID for switch port 0 is not yet configured.
>> ?
> I don't think so. The issue will happen every time the user is calling
> ibportstate
> with direct routing (-D argument) irrespective of wether the local LID
> for switch
> port 0 is configured or not.

Oh right; portid.lid is not changed from 0 by ib_resolve_portid_str when
DR is used.

-- Hal

> -Dag
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
