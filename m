From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH 1/1] Ibacm: default pkey for partitioned fabrics
Date: Wed, 9 Dec 2015 08:45:36 -0500
Message-ID: <56683080.1090801@dev.mellanox.co.il>
References: <1449595982-20781-1-git-send-email-kaike.wan@intel.com>
 <56682392.5000302@dev.mellanox.co.il>
 <3F128C9216C9B84BB6ED23EF16290AFB185810A2@CRSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <3F128C9216C9B84BB6ED23EF16290AFB185810A2-8k97q/ur5Z2krb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Wan, Kaike" <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 12/9/2015 8:24 AM, Wan, Kaike wrote:
>> From: Hal Rosenstock [mailto:hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org]
>> Sent: Wednesday, December 09, 2015 7:50 AM
>> To: Wan, Kaike; Hefty, Sean
>> Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> Subject: Re: [PATCH 1/1] Ibacm: default pkey for partitioned fabrics
>>
>> On 12/8/2015 12:33 PM, kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org wrote:
>>> From: Kaike Wan <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>>>
>>> In an insecure IB fabric, the default pkey in a port is 0xffff, where
>>> each node is allowed to talk to any other node in the fabric,
>>> including the SA node. However, in a secure fabric, to limit member
>>> access, not all nodes can have the full-member default pkey 0xffff. A
>>> typical configuration is to let SA node have pkey 0xffff while all
>>> other nodes have pkey 0x7fff; in addition, each node can be assigned
>>> some other full-member pkeys, such as
>>> 0x8001 and 0x8002, so that it can be assigned to different partitions.
>>> In this case, each node can access SA, and yet limits its other access
>>> to only those nodes in its assigned partitions. In such a secure
>>> fabric, however, ibacm will not work by interpreting "default" in its
>>> default address file as 0xffff.
>>>
>>> To solve the problem, this patch introduces the following priority to
>>> interpret default pkey:
>>> 1. Find the first non-management full-member pkey; 2. If it fails,
>>> find pkey 0xffff; 3. If pkey 0xffff is not available, use the first
>>> pkey.
>>> This approach will work in both securely and insecurely partitions
>>> fabrics.
>>
>> Shouldn't the pkey to be used for such interACM communication be
>> configured ?
> Yes. The purpose of this patch is only to make a secure system work out of box (default configuration). When a specific pkey is given in the ibacm_addr.cfg file, there will be no need to interpret the "default" pkey.
> 
>> First full member pkey is non-deterministic. Isn't it the case that
>> it may not include proper set of ACMs to communicate with ?
> 
> This is only for the default configuration, where a reasonable assumption is that members of an intended 
> partition (group of ports) will all have the same full-member pkey.

Yes, but it may not be first (lowest index) pkey in table of different
ports.

> One could argue that a port could have two or more full-member non-management pkeys because
> it is assigned to multiple partitions. 

Yes, that's a perfectly valid configuration.

> In this case, the port will only join only one multicast group, not all the multicast groups. The reply is 
> that the default ibacm_addr.cfg have only one endpoint with pkey "default" anyway.

In this case, the non default partitions are not useful for ACM and all
ACMs need to share "default" partition.

> To make it really work, one needs to edit ibacm_addr.cfg.

It may work without config depending on a number of factors but can
cause issues to be debugged.

Only sure way is config :-(

-- Hal

> Kaike
> 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
