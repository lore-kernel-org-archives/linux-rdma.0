From: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 5/5] IB/core: Convert management helpers to core
 capability bits
Date: Thu, 14 May 2015 16:10:24 +0000
Message-ID: <2807E5FD2F6FDA4886F6618EAC48510E1107E715@CRSMSX101.amr.corp.intel.com>
References: <1431561779-13714-1-git-send-email-ira.weiny@intel.com>
 <1431561779-13714-6-git-send-email-ira.weiny@intel.com>
 <5554AE23.3020909@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5554AE23.3020909-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> >  static inline bool rdma_protocol_ib(struct ib_device *device, u8
> > port_num)  {
> > -	return device->query_protocol(device, port_num) ==
> RDMA_PROTOCOL_IB;
> > +	return device->port_immutable[port_num].core_cap_flags &
> > +RDMA_CORE_CAP_PROT_IB;
> >  }
> >
> >  static inline bool rdma_protocol_iboe(struct ib_device *device, u8
> > port_num)
> 
> Should this helper be renamed rdma_protocol_roce (and change any
> consumers of this helper to use that name) ? If so, should it be done in this
> patch or follow on patch ?
> 

I'll create a follow on patch.

Ira

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
