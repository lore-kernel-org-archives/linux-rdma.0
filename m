From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: rdma-core_15-1_amd64.changes ACCEPTED into unstable
Date: Fri, 17 Nov 2017 16:31:12 -0700
Message-ID: <20171117233112.GT4276@ziepe.ca>
References: <E1eENiD-000EaM-BG@fasolo.debian.org>
 <20171114023711.GA22633@ziepe.ca>
 <20171114072056.GP18825@mtr-leonro.local>
 <1510656661.4026.23.camel@profitbricks.com>
 <20171114184719.GC4263@ziepe.ca>
 <1510685923.4026.41.camel@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1510685923.4026.41.camel-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Linux RDMA Mailing List <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Nov 14, 2017 at 07:58:43PM +0100, Benjamin Drung wrote:

> There is no elegant way to handle that. The most elegant way I can come
> up with is:

This seems to work, but it is too bad we couldn't drive it out of
cmake's decisions somehow..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
