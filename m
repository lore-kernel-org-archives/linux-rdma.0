From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH RFC 2/2] RDMA/nldev: provide detailed CM_ID information
Date: Wed, 31 Jan 2018 14:56:10 -0600
Message-ID: <01ea01d39ad5$ec30f7a0$c492e6e0$@opengridcomputing.com>
References: <cover.1517418595.git.swise@opengridcomputing.com> <531889e6a24f7919dec71734c91298d266aa9721.1517418595.git.swise@opengridcomputing.com> <VI1PR0502MB3008805F1A6056F50A12DEDBD1FB0@VI1PR0502MB3008.eurprd05.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <VI1PR0502MB3008805F1A6056F50A12DEDBD1FB0-o1MPJYiShExKsLr+rGaxW8DSnupUy6xnnBOFsp37pqbUKgpGm//BTAC/G2K4zDHf@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Parav Pandit' <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, 'Jason Gunthorpe' <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

> > 182,6 +199,7 @@ static int fill_res_info(struct sk_buff *msg, struct
ib_device
> > *device)
> >  		[RDMA_RESTRACK_PD] = "pd",
> >  		[RDMA_RESTRACK_CQ] = "cq",
> >  		[RDMA_RESTRACK_QP] = "qp",
> > +		[RDMA_RESTRACK_CM_ID] = "cm_id",
> 
> May be rdmacm_id a better name to avoid confusion with ib_cm/iw_cm ids?

Eventually, I could see the ib_cm and/or iw_cm info also getting dumped as
part of this.  So perhaps the name "cm_id" is ok?  I prefer it also because
its shorter (lazy typer! :) )



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
