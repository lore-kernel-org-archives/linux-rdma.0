From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [RFC ABI 0/8] Netlink-based IOCTLs RDMA ABI
Date: Tue, 24 May 2016 22:44:27 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373AB050303@ORSMSX109.amr.corp.intel.com>
References: <1464100526-31730-1-git-send-email-leonro@mellanox.com>
 <1828884A29C6694DAF28B7E6B8A82373AB05004F@ORSMSX109.amr.corp.intel.com>
 <20160524210132.GB7950@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A82373AB0501E2@ORSMSX109.amr.corp.intel.com>
 <20160524214951.GC7950@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A82373AB05023F@ORSMSX109.amr.corp.intel.com>
 <20160524223052.GI7950@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160524223052.GI7950-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> If we are using SGL for the response then why not use SGL for
> everything? We've already lost the advantage of the packet-like
> encoding netlink uses.
> 
> eg:
> 
> struct urdma_ioctl {
> 	u64	flags;
> 	u16	domain;
> 	u8	object_count;
> 	u8	in_arg_count;
> 	u8	out_arg_count;
> 	u8      reserved[3];
> 	// union urdma_object objects[object_count];
> 	// struct arg_sgl in_args[in_arg_count];
> 	// struct arg_sgl out_args[out_arg_count];
> };
> 
> union urdma_object {
>       struct urdma_obj_id obj_id;
>       u64 data;
> };
> 
> struct urdma_arg_sgl {
>       void *ptr;
>       u32 id;
>       u32 length;
> };

Yes, this looks like it would work and be generic for any purpose.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
