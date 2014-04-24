From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: IB/cma: Make timeout dependent on the subnet timeout
Date: Thu, 24 Apr 2014 10:39:09 +0300
Message-ID: <5358BF9D.4030409@mellanox.com>
References: <53566BB5.5030203@acm.org> <1828884A29C6694DAF28B7E6B8A82373992F2F15@ORSMSX109.amr.corp.intel.com> <5357B25D.2000108@dev.mellanox.co.il> <5357B626.8050209@acm.org> <1828884A29C6694DAF28B7E6B8A82373992F32A2@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373992F32A2-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 23/04/2014 16:44, Hefty, Sean wrote:
>> Regarding SubnetTimeout changes: the code in
>> drivers/infiniband/core/cache.c already queues a work request after each
>> port state change. Inside that work request e.g. the P_Key cache is
>> updated. Would it be acceptable to modify ib_cache_update() such that it
>> also queries the port attributes and caches these ? Cached port
>> attributes could e.g. be stored in struct ib_port.
> Without looking at details, this at least sounds reasonable.
>

Sean, can't we have CMA to follow the same practice used in the CM where 
we derive the RC QP timeout based on the packet life time retrieved in 
path queries? e.g base the cm response time out on this value  too?

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
