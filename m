From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCHv2 RFC] IB: Add rdma_cap_ib_switch helper and use where
 appropriate
Date: Thu, 18 Jun 2015 23:52:39 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373A8FF70A9@ORSMSX109.amr.corp.intel.com>
References: <5583536C.3010504@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5583536C.3010504-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> In an effort to reform the RDMA core and ULPs to minimize use of
> node_type in struct ib_device, an additional bit is added to
> struct ib_device for is_switch (IB switch). This is needed
> to be initialized by any IB switch device driver. This is a
> NEW requirement on such device drivers which are all
> "out of tree".
> 
> In addition, an ib_switch helper was added to ib_verbs.h
> based on the is_switch device bit rather than node_type
> (although those should be consistent).
> 
> The RDMA core (MAD, SMI, agent, sa_query, multicast, sysfs)
> as well as (IPoIB and SRP) ULPs are updated where
> appropriate to use this new helper. In some cases,
> the helper is now used under the covers of using
> rdma_[start end]_port rather than the open coding
> previously used.
> 
> Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Assuming that the final version matches this one:

Reviewed-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
