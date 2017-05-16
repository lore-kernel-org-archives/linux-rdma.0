From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH rdma-next 2/4] IB/CM: Create appropriate path records
 when handling CM request
Date: Tue, 16 May 2017 16:43:46 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373AB11E07E@ORSMSX109.amr.corp.intel.com>
References: <1494458598-6911-1-git-send-email-dasaratharaman.chandramouli@intel.com>
 <1494458598-6911-3-git-send-email-dasaratharaman.chandramouli@intel.com>
 <20170513113936.GM3616@mtr-leonro.local>
 <1828884A29C6694DAF28B7E6B8A82373AB11DB23@ORSMSX109.amr.corp.intel.com>
 <20170516060852.GO3616@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170516060852.GO3616-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "Chandramouli, Dasaratharaman" <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> > > > +			if (ib_is_opa_gid(&req_msg->primary_local_gid)
> &&
> > > > +			    rdma_cap_opa_ah(work->port->cm_dev-
> >ib_device,
> > > > +					    work->port->port_num))
> > >
> > > Why isn't ib_is_opa_gid enough?
> >
> > It may be in reality, but that implies that IB and OPA are sharing
> GID space definitions.
> 
> I understood from Ira's presentation [1] that it is the case.

These are distinct addressing spaces.  OPA may be copying the IB spec GID definitions (similar to GIDs looking like IPv6 addresses), but there technically doesn't have to be any agreement between the IB spec and OPA.  I believe OPA has taken care not to use values that will or are likely to conflict with IB spec, so I think it comes down to what level of assumptions are we willing to accept in the code.  I'd like to see explicit checks, like what was done in the MAD area.

> And doesn't it need to be "||" and not "&&"?

&& should be correct.

> > It looks like rdma_cap_opa_ah() is basically being used as a check
> to see if the code is handling the OPA CM protocol or IB CM protocol.
> (Even though the two protocols are nearly identical).
> 
> Where can I read the difference between these protocols?

I don't know if the OPA CM (or MAD) protocol is published anywhere.  I haven't read the details myself.

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
