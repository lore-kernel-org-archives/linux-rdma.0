From: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v4 14/19] IB/core: Add IB_DEVICE_OPA_MAD_SUPPORT device cap flag
Date: Thu, 2 Apr 2015 18:45:36 -0400
Message-ID: <20150402224535.GA5687@phlsvsds.ph.intel.com>
References: <550C2514.5070001@profitbricks.com> <6A3D3202-0128-4F33-B596-D7A76AB66DF8@gmail.com> <20150320235748.GA22703@phlsvsds.ph.intel.com> <20150321000541.GA24717@phlsvsds.ph.intel.com> <CAJuTgQUsZ34F-dKpsmW+5=axDWb93pA43LZ-qKbEjqyu-RUUmg@mail.gmail.com> <1828884A29C6694DAF28B7E6B8A8237399E82E58@ORSMSX109.amr.corp.intel.com> <55115D61.9040201@profitbricks.com> <55128E48.1080406@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <55128E48.1080406-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Michael Wang <yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Mar 25, 2015 at 11:30:32AM +0100, Michael Wang wrote:
> Hi, Sean
> 
> On 03/24/2015 01:49 PM, Michael Wang wrote:
> >On 03/23/2015 05:31 PM, Hefty, Sean wrote:
> >>>[snip]
> >>To restate my suggesting, I was thinking of defining something like 
> >>this:
> >>
> >>enum {
> >>    IB_MGMT_PROTO_SM = (1 << 0),   /* supports IB SMPs */
> >>    IB_MGMT_PROTO_SA = (1 << 1),   /* supports IB SA MADs */
> >>    IB_MGMT_PROTO_GS = (1 << 2),   /* supports IB GSI MADs (e.g. PM, 
> >>...) */
> >>    IB_MGMT_PROTO_CM = (1 << 3),   /* IB CM called out separately */
> >>    IB_MGMT_PROTO_IW_CM = (1 << 4),/* iWarp CM */
> >>    /* OPA can define new values here */
> >>};
> >>
> >>struct ib_port_attr {
> >>    ...
> >>    u32    mgmt_proto;  /* bitmask of supported protocols */
> >>};
> >
> >Thanks for the restate, Sean :) seems like your proposal is also to 
> >ask vendor
> >setup 'mgmt_proto' during ib_query_port(), correct?
> 
> I think we got one problem here, if we rely on ib_query_port() to setup 
> mgmt flags
> each time, the performance may suffered, since some implementation of
> query_port() is really expensive, like hardware communication (mlx4/5) and
> mutex protection (usnic)...

This is why my OPA patch series included a cache of the device attributes.

https://www.mail-archive.com/linux-rdma%40vger.kernel.org/msg22827.html

This was suggested by Or and incorporated rather than having the MAD stack
issue ib_query_device.  The same could be done for port attributes.

That said I would like to see the next version of your patch series.  We have
had a lot of churn on that thread and I think you have a lot of things you were
going to incorporate.  :-D

Thanks!
Ira

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
