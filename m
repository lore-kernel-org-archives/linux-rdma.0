From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH RESEND v1 rdma-next 2/6] RDMA/nldev: provide detailed CM_ID information
Date: Tue, 13 Feb 2018 14:59:04 -0600
Message-ID: <023101d3a50d$7b4b0bb0$71e12310$@opengridcomputing.com>
References: <cover.1518552800.git.swise@opengridcomputing.com> <1510713d3e0f14b101bea7dc9e02084e46e580ec.1518552800.git.swise@opengridcomputing.com> <VI1PR0502MB300833C7A62DB411AB8E7982D1F60@VI1PR0502MB3008.eurprd05.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <VI1PR0502MB300833C7A62DB411AB8E7982D1F60-o1MPJYiShExKsLr+rGaxW8DSnupUy6xnnBOFsp37pqbUKgpGm//BTAC/G2K4zDHf@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Parav Pandit' <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Jason Gunthorpe' <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

...

> > +			/*
> > +			 * 1. Kernel QPs should be visible in init namsapce
only
> > +			 * 2. Preent only QPs visible in the current
namespace
> Present only


Yup.  Thanks.

...

> > diff --git a/include/rdma/rdma_cm.h b/include/rdma/rdma_cm.h index
> > 6538a5c..3e90501 100644
> > --- a/include/rdma/rdma_cm.h
> > +++ b/include/rdma/rdma_cm.h
> > @@ -155,8 +155,19 @@ struct rdma_cm_id {
> >  	enum rdma_port_space	 ps;
> >  	enum ib_qp_type		 qp_type;
> >  	u8			 port_num;
> > +	const char *caller;
> > +
> > +	/*
> > +	 * Internal to RDMA/core, don't use in the drivers
> > +	 */
> > +	struct rdma_restrack_entry     res;
> I didn't review the whole code; can this be kept in rdma_cm_priv_id
instead?

Yes.  I guess that probably makes sense.  The other objects (ib_qp, ib_cq,
etc) don't have a public/private separation though.

Steve.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
