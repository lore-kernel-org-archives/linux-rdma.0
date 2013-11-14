From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH] IB/CMA: Initialize hop_limit to a known default macro
 instead of 1 as is done currently.
Date: Thu, 14 Nov 2013 19:39:33 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237388D046BC@ORSMSX109.amr.corp.intel.com>
References: <07f80ed7-7ea4-4c30-afe5-3f9fc7dd37fb@CMEXHTCAS2.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <07f80ed7-7ea4-4c30-afe5-3f9fc7dd37fb-3RiH6ntJJkOPfaB/Gd0HpljyZtpTMMwT@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Somnath Kotur <somnath.kotur-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, "roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> -	route->path_rec->hop_limit = 1;
> +	route->path_rec->hop_limit = IPV6_DEFAULT_HOPLIMIT;

This is not an IPv6 route though.  AFAIK, RoCE/IBoE is not routable, so the hop limit should be set to 1.  Using a different value affects timeout values set by the IB CM.

Can you describe more of the reasoning behind this change?

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
