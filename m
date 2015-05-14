From: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 5/5] IB/core: Convert management helpers to core capability bits
Date: Thu, 14 May 2015 12:26:55 -0400
Message-ID: <20150514162654.GA10941@phlsvsds.ph.intel.com>
References: <1431561779-13714-1-git-send-email-ira.weiny@intel.com> <1431561779-13714-6-git-send-email-ira.weiny@intel.com> <5554AE23.3020909@dev.mellanox.co.il> <2807E5FD2F6FDA4886F6618EAC48510E1107E715@CRSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <2807E5FD2F6FDA4886F6618EAC48510E1107E715-8k97q/ur5Z2krb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, May 14, 2015 at 04:10:24PM +0000, Weiny, Ira wrote:
> > >  static inline bool rdma_protocol_ib(struct ib_device *device, u8
> > > port_num)  {
> > > -	return device->query_protocol(device, port_num) ==
> > RDMA_PROTOCOL_IB;
> > > +	return device->port_immutable[port_num].core_cap_flags &
> > > +RDMA_CORE_CAP_PROT_IB;
> > >  }
> > >
> > >  static inline bool rdma_protocol_iboe(struct ib_device *device, u8
> > > port_num)
> > 
> > Should this helper be renamed rdma_protocol_roce (and change any
> > consumers of this helper to use that name) ? If so, should it be done in this
> > patch or follow on patch ?
> > 
> 
> I'll create a follow on patch.
> 

Since we are going down this path perhaps someone can change all the other iboe
references.  These counts were after changing the rdma_protocol_* names.

12:24:45 > grep -r iboe drivers/infiniband/ | grep -v Binary | wc -l
123

12:24:51 > grep -r iboe include/rdma | grep -v Binary | wc -l
4

Ira

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
