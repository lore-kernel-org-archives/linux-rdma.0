From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH rdma-rc v1 2/2] RDMA/cma: Make sure that PSN is not over
 max allowed
Date: Mon, 27 Nov 2017 11:37:55 -0700
Message-ID: <20171127183755.GB13966@ziepe.ca>
References: <20171126182354.18709-1-leon@kernel.org>
 <20171126182354.18709-3-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171126182354.18709-3-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Mukesh Kacker <mukesh.kacker-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, Nov 26, 2017 at 08:23:54PM +0200, Leon Romanovsky wrote:
> From: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> 
> This patch limits the initial value for PSN to 24 bits as
> spec requires.

Since this is for-rc, what is the user visible bug this corrects?

I think it is because the QP setup can fail if reserved bits in the
CMA message happen to be set?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
