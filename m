From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [RFC ABI 0/8] Netlink-based IOCTLs RDMA ABI
Date: Tue, 24 May 2016 19:37:13 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373AB05004F@ORSMSX109.amr.corp.intel.com>
References: <1464100526-31730-1-git-send-email-leonro@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1464100526-31730-1-git-send-email-leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> struct ib_uverbs_ioctl_hdr {
> 	__u32 length;

FWIW, I limited length to 16-bits, to prevent passing massive amounts of data between user space and the kernel as a single transfer.

> 	__u16 flags;

16-bit flags seems limiting.

> 	__u16 object_type;
> 	__u16 reserved;
> 	/* First 8 actions are common to all objects */
> 	__u16 action;
> 	__u32 user_handler;
> 	/*
> 	 * These fields represent core response only,
> 	 * provider's response is given as a netlink attribute.
> 	 */
> 	struct ib_uverbs_uptr resp;

This is associating the kernel ABI with a specific implementation of user space components.

Ioctl implementations I looked at treated the ioctl buffer as input-output (except for read only or write only ioctl's).  Maybe there's examples of redirecting the response to separate buffer(s)?

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
