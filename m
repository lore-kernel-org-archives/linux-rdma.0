From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: Re: [PATCH] libibumad: add string functions for various defines
Date: Tue, 19 Feb 2013 08:26:27 -0800
Message-ID: <20130219082627.922070ddcdc1d1141c7bc63e@llnl.gov>
References: <20130218153638.2b452d138f0918b945bcdb71@llnl.gov>
	<1828884A29C6694DAF28B7E6B8A823736F342E49@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A823736F342E49-P5GAC/sN6hmkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, 19 Feb 2013 15:05:34 +0000
"Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:

> > +#define UMAD_GENERIC_ATTRIBUTE_STR \
> > +		case UMAD_ATTR_CLASS_PORT_INFO: \
> > +			return "Class Port Info"; \
> > +		case UMAD_ATTR_NOTICE: \
> > +			return "Notice"; \
> > +		case UMAD_ATTR_INFORM_INFO: \
> > +			return "Inform Info"
> 
> this is .. odd   :P

I got tired of typing.  If you think it will be a maintenance issue I can change.

Ira

> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
Ira Weiny
Member of Technical Staff
Lawrence Livermore National Lab
925-423-8008
weiny2-i2BcT+NCU+M@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
