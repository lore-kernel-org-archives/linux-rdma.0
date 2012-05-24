From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 2/3] IB/mlx4: Fix max_wqe capacity report for query
 device
Date: Thu, 24 May 2012 15:42:55 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237346A23DD0@ORSMSX101.amr.corp.intel.com>
References: <1337864889-20886-1-git-send-email-ogerlitz@mellanox.com>
 <1337864889-20886-3-git-send-email-ogerlitz@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1337864889-20886-3-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> 1. Limit max number of wqes per QP reported when querying the device,
> so that ib_create_qp will never fail due to any additional headroom WQEs
> allocated.
> 
> 2. Limit qp resources accepted for ib_create_qp() to the limits
> reported in ib_query_device(). In kernel space, make sure that
> the limits returned to the caller following qp creation also
> lie within the reported device limits. For userspace, report
> as before, and do adjustment in libmlx4 (so as not to break ABI).

I believe that I was *just* hitting into this bug.

I don't understand the part about breaking the ABI.  Why wouldn't you just return the correct values from the kernel?  Are the values being returned now usable?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
