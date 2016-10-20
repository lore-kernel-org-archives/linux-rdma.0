From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH RFC] rdma_cm: add rdma_reject_msg() helper function
Date: Thu, 20 Oct 2016 16:23:25 -0500
Message-ID: <018e01d22b18$31a40d10$94ec2730$@opengridcomputing.com>
References: <20161020211652.35902E0C53@smtp.ogc.us> <1828884A29C6694DAF28B7E6B8A82373AB0A1CF9@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373AB0A1CF9-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "'Hefty, Sean'" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

> 
> 
> > +static const char * const ib_rej_reason_strs[] = {
> > +	[IB_CM_REJ_NO_QP]			= "no qp",
> > +	[IB_CM_REJ_NO_EEC]			= "no eec",
> > +	[IB_CM_REJ_NO_RESOURCES]		= "no resources",
> > +	[IB_CM_REJ_TIMEOUT]			= "timeout",
> > +	[IB_CM_REJ_UNSUPPORTED]			= "unsupported",
> > +	[IB_CM_REJ_INVALID_COMM_ID]		= "invalid comm id",
> > +	[IB_CM_REJ_INVALID_COMM_INSTANCE]	= "invalid comm instance",
> > +	[IB_CM_REJ_INVALID_SERVICE_ID]		= "invalid service id",
> > +	[IB_CM_REJ_INVALID_TRANSPORT_TYPE]	= "invalid transport type",
> > +	[IB_CM_REJ_STALE_CONN]			= "stale conn",
> > +	[IB_CM_REJ_RDC_NOT_EXIST]		= "rdc not exist",
> > +	[IB_CM_REJ_INVALID_GID]			= "invalid gid",
> > +	[IB_CM_REJ_INVALID_LID]			= "invalid lid",
> > +	[IB_CM_REJ_INVALID_SL]			= "invalid sl",
> > +	[IB_CM_REJ_INVALID_TRAFFIC_CLASS]	= "invalid traffic class",
> > +	[IB_CM_REJ_INVALID_HOP_LIMIT]		= "invalid hop limit",
> > +	[IB_CM_REJ_INVALID_PACKET_RATE]		= "invalid packet
> > rate",
> > +	[IB_CM_REJ_INVALID_ALT_GID]		= "invalid alt gid",
> > +	[IB_CM_REJ_INVALID_ALT_LID]		= "invalid alt lid",
> > +	[IB_CM_REJ_INVALID_ALT_SL]		= "invalid alt sl",
> > +	[IB_CM_REJ_INVALID_ALT_TRAFFIC_CLASS]	= "invalid alt traffic
> > class",
> > +	[IB_CM_REJ_INVALID_ALT_HOP_LIMIT]	= "invalid alt hop limit",
> > +	[IB_CM_REJ_INVALID_ALT_PACKET_RATE]	= "invalid alt packet rate",
> > +	[IB_CM_REJ_PORT_CM_REDIRECT]		= "port cm redirect",
> > +	[IB_CM_REJ_PORT_REDIRECT]		= "port redirect",
> > +	[IB_CM_REJ_INVALID_MTU]			= "invalid mtu",
> > +	[IB_CM_REJ_INSUFFICIENT_RESP_RESOURCES]	= "insufficient resp
> > resources",
> > +	[IB_CM_REJ_CONSUMER_DEFINED]		= "consumer defined",
> > +	[IB_CM_REJ_INVALID_RNR_RETRY]		= "invalid rnr retry",
> > +	[IB_CM_REJ_DUPLICATE_LOCAL_COMM_ID]	= "duplicate local comm
> id",
> > +	[IB_CM_REJ_INVALID_CLASS_VERSION]	= "invalid class version",
> > +	[IB_CM_REJ_INVALID_FLOW_LABEL]		= "invalid flow label",
> > +	[IB_CM_REJ_INVALID_ALT_FLOW_LABEL]	= "invalid alt flow label",
> > +};
> 
> This would be better placed as part of the ib_cm.
> 
> > +
> > +static const char * const iw_rej_reason_strs[] = {
> > +	[ECONNRESET]			= "reset by remote host",
> > +	[ECONNREFUSED]			= "refused by remote application",
> > +	[ETIMEDOUT]			= "setup timeout",
> > +};
> 
> Same with iw_cm.

Hey Sean, I can do that.  I thought perhaps it was better to keep it static in
cma.c, rather than having to extern them.   But I'll make that change.


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
