From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH rdma-rc 0/2] IPoIB and mlx5 fixes
Date: Thu, 21 Dec 2017 17:44:19 -0700
Message-ID: <20171222004419.GC20855@ziepe.ca>
References: <20171221153827.16793-1-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171221153827.16793-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Alex Vesker <valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Aviv Heller <avivh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Dec 21, 2017 at 05:38:25PM +0200, Leon Romanovsky wrote:
> There are two fixes in this series,
> 
> Fix from Alex who solved lockdep real complain about ABBA locks sequence.
> 
> Patch from Majd a little bit larger than I would like, but most of the
> diffstat is simple code moves from one file to another.
> 
> The patches are available in the git repository at:
>   git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma.git tags/rdma-rc-2017-12-21

Applied both to for-rc, thanks

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
