From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH RFC] IB: Add rdma_cap_ib_switch helper and use where
 appropriate
Date: Thu, 18 Jun 2015 20:32:21 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373A8FF6FAD@ORSMSX109.amr.corp.intel.com>
References: <55832793.1080105@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <55832793.1080105-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
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

I agree with Jason, only I would add we need to decide if we want to continue supporting the out of tree devices.  We have for so long that it seems reasonable to do so.  At the same time, I think we'd reject these changes now without a lower level user of them.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
