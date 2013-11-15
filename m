From: Somnath Kotur <Somnath.Kotur-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org>
Subject: RE: [PATCH] IB/CMA: Initialize hop_limit to a known default macro
 instead of 1 as is done currently.
Date: Fri, 15 Nov 2013 02:18:10 +0000
Message-ID: <7F44EA5110810A40B7DAFB605C41975D2C8AB76A@CMEXMB1.ad.emulex.com>
References: <07f80ed7-7ea4-4c30-afe5-3f9fc7dd37fb@CMEXHTCAS2.ad.emulex.com>,<1828884A29C6694DAF28B7E6B8A8237388D046BC@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A8237388D046BC-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


________________________________________
From: Hefty, Sean [sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org]
Sent: Friday, November 15, 2013 1:09 AM
To: Somnath Kotur; roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Subject: RE: [PATCH] IB/CMA: Initialize hop_limit to a known default macro instead of 1 as is done currently.

> -     route->path_rec->hop_limit = 1;
> +     route->path_rec->hop_limit = IPV6_DEFAULT_HOPLIMIT;

This is not an IPv6 route though.  AFAIK, RoCE/IBoE is not routable, so the hop limit should be set to 1.  Using a different value affects timeout values set by the IB CM.

Can you describe more of the reasoning behind this change?

Sean,
        This change was done precisely to enable us to do that i.e make it routable. This was the only suitable macro i could find that defines a certain default value for the hop limit and is used by the IPv6 layer in the kernel already. I'm open to other suggestions of values, but pegging to 1 means we are not allowing any scope for it to be routable in the future ..Would you agree ? 

Thanks
Som


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
