From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH] IB/CMA: Fix to handle global/non-linklocal IPv6 address
 in cma_check_linklocal()
Date: Thu, 14 Nov 2013 22:28:14 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237388D059A2@ORSMSX109.amr.corp.intel.com>
References: <c469605a-bda9-4248-82f0-0da03bf3ce3d@CMEXHTCAS2.ad.emulex.com>
 <03234339-6425-4D1A-A4E6-775887EF6463@hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <03234339-6425-4D1A-A4E6-775887EF6463-VXdhtT5mjnY@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Prindeville, Philip" <philip.prindeville-VXdhtT5mjnY@public.gmane.org>, Somnath Kotur <somnath.kotur-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Cc: "roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> Do you need to check it twice?
> 
> Is the second test now redundant?

I agree, the second if statement can be simplified to only check the scope id.

> > +
> > +	if (!(ipv6_addr_type(&sin6->sin6_addr) & IPV6_ADDR_LINKLOCAL))
> > +		return 0;
> > 	if ((ipv6_addr_type(&sin6->sin6_addr) & IPV6_ADDR_LINKLOCAL) &&
> > 	    !sin6->sin6_scope_id)
> > 			return -EINVAL;
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
