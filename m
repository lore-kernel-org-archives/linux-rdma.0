From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH 1/1] Ibacm: default pkey for partitioned fabrics
Date: Wed, 9 Dec 2015 07:51:46 -0500
Message-ID: <566823E2.5090504@dev.mellanox.co.il>
References: <1449595982-20781-1-git-send-email-kaike.wan@intel.com>
 <20151208212133.GC14378@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151208212133.GC14378-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 12/8/2015 4:21 PM, Jason Gunthorpe wrote:
> On Tue, Dec 08, 2015 at 12:33:02PM -0500, kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org wrote:
>> From: Kaike Wan <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>>
>> In an insecure IB fabric, the default pkey in a port is 0xffff, where each
>> node is allowed to talk to any other node in the fabric, including the SA
>> node. However, in a secure fabric, to limit member access, not all nodes
>> can have the full-member default pkey 0xffff. A typical configuration is
>> to let SA node have pkey 0xffff while all other nodes have pkey 0x7fff; in
>> addition, each node can be assigned some other full-member pkeys, such as
>> 0x8001 and 0x8002, so that it can be assigned to different partitions.
>> In this case, each node can access SA, and yet limits its other access to
>> only those nodes in its assigned partitions. In such a secure fabric,
>> however, ibacm will not work by interpreting "default" in its default
>> address file as 0xffff.
> 
> ipoib always uses the 0 pkey index to create the default ipoib
> interface. (see eg, update_parent_pkey)

This is beyond IBA spec and is currently a linux convention for IPoIB.
IMO it should be changed to search for this pkey rather than assume it's
in index 0. There's no requirement that it be in index 0 other than at
bootup with non volatile storage (C10-123).

> When operating securely the SA should place the pkey for default ipoib
> operation in pkey index 0, and place 0x7FFF in another index. I run
> alot of networks exactly like this and it works very well.

Yes, it can run that way but more secure is without the full default
pkey. When full default pkey is in every port, the rest of the
partitioning doesn't really matter...

-- Hal
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
