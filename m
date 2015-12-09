From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH 1/1] Ibacm: default pkey for partitioned fabrics
Date: Wed, 9 Dec 2015 07:50:26 -0500
Message-ID: <56682392.5000302@dev.mellanox.co.il>
References: <1449595982-20781-1-git-send-email-kaike.wan@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1449595982-20781-1-git-send-email-kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 12/8/2015 12:33 PM, kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org wrote:
> From: Kaike Wan <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> 
> In an insecure IB fabric, the default pkey in a port is 0xffff, where each
> node is allowed to talk to any other node in the fabric, including the SA
> node. However, in a secure fabric, to limit member access, not all nodes
> can have the full-member default pkey 0xffff. A typical configuration is
> to let SA node have pkey 0xffff while all other nodes have pkey 0x7fff; in
> addition, each node can be assigned some other full-member pkeys, such as
> 0x8001 and 0x8002, so that it can be assigned to different partitions.
> In this case, each node can access SA, and yet limits its other access to
> only those nodes in its assigned partitions. In such a secure fabric,
> however, ibacm will not work by interpreting "default" in its default
> address file as 0xffff.
> 
> To solve the problem, this patch introduces the following priority to
> interpret default pkey:
> 1. Find the first non-management full-member pkey;
> 2. If it fails, find pkey 0xffff;
> 3. If pkey 0xffff is not available, use the first pkey.
> This approach will work in both securely and insecurely partitions
> fabrics.

Shouldn't the pkey to be used for such interACM communication be
configured ? First full member pkey is non-deterministic. Isn't it the
case that it may not include proper set of ACMs to communicate with ?

-- Hal
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
