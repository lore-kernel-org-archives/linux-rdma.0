From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH rdma-next 00/31] RDMA fixes and refactoring for 4.15
Date: Mon, 18 Dec 2017 16:11:20 -0700
Message-ID: <20171218231120.GH19056@ziepe.ca>
References: <20171114125218.20477-1-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171114125218.20477-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Nov 14, 2017 at 02:51:47PM +0200, Leon Romanovsky wrote:
> Hi Doug,
> 
> Please consider to take the following series to your coming pull request.
> 
> The patches are available in the git repository at:
>   git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma.git tags/rdma-next-2017-11-14
> 
> 	Thanks

I applied this series excluding:

   IB/core: Fix do not add RoCEv2 default GID when IPv6 is disabled

As noted in my reply to that patch.

I revised many of the commit messages, lets try to improve these please.

I also revised this patch:
   IB/ipoib: Avoid memory leak if neigh destination was changed

To use ipoib_debug as noted in my separate message.

Everything is in the wip/jgg-zero-day branch, it will move to for-next
my tomorrow. Let me know if there are any serious problems with my
edits.

Thanks,
Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
