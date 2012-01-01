From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 1/2] libibverbs: Allow 3rd party extensions to verb routines
Date: Sun, 1 Jan 2012 07:13:32 +0200
Message-ID: <4EFFEB7C.6090202@mellanox.com>
References: <1828884A29C6694DAF28B7E6B8A8237302123C@ORSMSX101.amr.corp.intel.com> <201108011508.06521.jackm@dev.mellanox.co.il> <20110802053824.GA23512@obsidianresearch.com> <201108021053.05311.jackm@dev.mellanox.co.il> <1828884A29C6694DAF28B7E6B8A82373136F935C@ORSMSX101.amr.corp.intel.com> <4EFC8A85.4020803@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4EFC8A85.4020803-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


>
>> or call an existing function with some new enum value
>
> 5. what happens if we just want to enhance an -- existing -- function 
> - suppose we want to enhance ibv_post_send / ibv_poll_cq to support 
> features like LSO, checksum offload, masked atomic operations, fast 
> memory remote invalidate, etc so we add IBV_WR_NEW_FEATURE / 
> IB_WC_NEW_FEATURE enum values, this step is simple, again if we go the 
> way of the applicayion ensuring through dependencies that they are 
> loaded against libibverbs that supports IB_{WR,WC}_NEW_FEATURE.

Another element to take into account / use here, is the device 
capabilities, in the kernel RDMA stack this is the way to go for 
supporting extended features - those who are not common to all devices, 
e.g the way ipoib queries the device and concludes if checksum/lso 
offloads can be exposed to the network stack, or the rpc/rdma layer 
decides what memory management model to use for rdma conditioned if 
memory extensions etc are supported. But the kernel is one piece, so if 
a cap is defined and there's a driver down there advertizing it, all is 
in place software wise, where in user space, there are some more layers 
to address, as this thread attempts to do.

Or.


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
