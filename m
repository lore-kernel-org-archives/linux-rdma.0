From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH rdma-next 01/31] IB/core: Fix do not add RoCEv2 default
 GID when IPv6 is disabled
Date: Tue, 14 Nov 2017 21:40:49 -0700
Message-ID: <20171115044049.GK25894@ziepe.ca>
References: <20171114125218.20477-1-leon@kernel.org>
 <20171114125218.20477-2-leon@kernel.org>
 <20171115001817.GH25894@ziepe.ca>
 <VI1PR0502MB300800ABA04E768A68684608D1290@VI1PR0502MB3008.eurprd05.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <VI1PR0502MB300800ABA04E768A68684608D1290-o1MPJYiShExKsLr+rGaxW8DSnupUy6xnnBOFsp37pqbUKgpGm//BTAC/G2K4zDHf@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Nov 15, 2017 at 03:59:26AM +0000, Parav Pandit wrote:

> Currently in rest of the IB stack in cma.c, addr.c we check for
> IS_ENABLED(CONFIG_IPV6).  May be when all of them are changed, this
> can also shift to honoring sysctl.

I think most of the rest of the stack is guarding things that would
cause linking problems when ipv6 is compiled out, those cannot be
changed to sysctl.

Since this clearly should be sysctl based it should start out that
way.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
