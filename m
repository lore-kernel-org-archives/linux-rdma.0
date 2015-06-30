From: "Wan, Kaike" <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH v7 1/4] IB/netlink: Add defines for local service
 requests through netlink
Date: Tue, 30 Jun 2015 17:21:19 +0000
Message-ID: <3F128C9216C9B84BB6ED23EF16290AFB0CAC22C7@CRSMSX101.amr.corp.intel.com>
References: <1435671955-9744-1-git-send-email-kaike.wan@intel.com>
 <1435671955-9744-2-git-send-email-kaike.wan@intel.com>
 <1828884A29C6694DAF28B7E6B8A82373A8FFB093@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373A8FFB093-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: "Fleck, John" <john.fleck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> From: Hefty, Sean
> Sent: Tuesday, June 30, 2015 1:17 PM
> To: Wan, Kaike; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Cc: Wan, Kaike; Fleck, John; Weiny, Ira
> Subject: RE: [PATCH v7 1/4] IB/netlink: Add defines for local service requests
> through netlink
> 
> >  include/uapi/rdma/rdma_netlink.h |   87
> > ++++++++++++++++++++++++++++++++++++++
> >  1 files changed, 87 insertions(+), 0 deletions(-)
> >
> > diff --git a/include/uapi/rdma/rdma_netlink.h
> > b/include/uapi/rdma/rdma_netlink.h
> > index 6e4bb42..d2c50e9 100644
> > --- a/include/uapi/rdma/rdma_netlink.h
> > +++ b/include/uapi/rdma/rdma_netlink.h
> > @@ -7,12 +7,14 @@ enum {
> >  	RDMA_NL_RDMA_CM = 1,
> >  	RDMA_NL_NES,
> >  	RDMA_NL_C4IW,
> > +	RDMA_NL_SA,
> >  	RDMA_NL_NUM_CLIENTS
> >  };
> >
> >  enum {
> >  	RDMA_NL_GROUP_CM = 1,
> >  	RDMA_NL_GROUP_IWPM,
> > +	RDMA_NL_GROUP_LS,
> >  	RDMA_NL_NUM_GROUPS
> >  };
> >
> > @@ -128,5 +130,90 @@ enum {
> >  	IWPM_NLA_ERR_MAX
> >  };
> >
> > +/* Local service group opcodes */
> > +enum {
> > +	RDMA_NL_LS_OP_RESOLVE = 0,
> > +	RDMA_NL_LS_OP_SET_TIMEOUT,
> > +	RDMA_NL_LS_NUM_OPS
> > +};
> > +
> > +/* Local service netlink message flags */
> > +#define RDMA_NL_LS_F_OK		0x0100	/* Success response */
> > +#define RDMA_NL_LS_F_ERR	0x0200	/* Failed response */
> 
> Is there a reason for these odd values?

Yes, the lower byte (0x00xx) is used by generic netlink messages and the higher byte can be used for specific request (eg, RESOLVE).

Kaike

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
