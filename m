From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [RFC PATCH] RDMA/cma: Remove netlink interface of CMA statistics
Date: Tue, 14 Nov 2017 08:23:50 -0700
Message-ID: <20171114152350.GA4263@ziepe.ca>
References: <20171113144024.26655-1-leon@kernel.org>
 <20171113192432.GL6918@ziepe.ca>
 <20171114080550.GR18825@mtr-leonro.local>
 <CAJ3xEMhfdXz8zQFetjQPfe7HZiCi+N0z6r9XSucuTzQo1--PBg@mail.gmail.com>
 <20171114095605.GU18825@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171114095605.GU18825-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Nov 14, 2017 at 11:56:05AM +0200, Leon Romanovsky wrote:

> > what didn't work exactly?
> 
> Started from compilation, continued to wrong data presented.
> There is no need to carry 7-years old code, which no one cares about it.

If it legiminately doesn't actually work then that is reason enough to
be able to drop a uAPI, IMHO.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
