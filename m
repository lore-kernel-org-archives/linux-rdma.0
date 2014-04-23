From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: IB/cma: Make timeout dependent on the subnet timeout
Date: Wed, 23 Apr 2014 13:44:59 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373992F32A2@ORSMSX109.amr.corp.intel.com>
References: <53566BB5.5030203@acm.org>
 <1828884A29C6694DAF28B7E6B8A82373992F2F15@ORSMSX109.amr.corp.intel.com>
 <5357B25D.2000108@dev.mellanox.co.il> <5357B626.8050209@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5357B626.8050209-HInyCGIudOg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> Regarding SubnetTimeout changes: the code in
> drivers/infiniband/core/cache.c already queues a work request after each
> port state change. Inside that work request e.g. the P_Key cache is
> updated. Would it be acceptable to modify ib_cache_update() such that it
> also queries the port attributes and caches these ? Cached port
> attributes could e.g. be stored in struct ib_port. 

Without looking at details, this at least sounds reasonable.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
