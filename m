From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH rdma-core v2] debian: Add udev dependency to rdma-core
 and srptools
Date: Wed, 3 Jan 2018 14:24:26 -0700
Message-ID: <20180103212426.GM11348@ziepe.ca>
References: <20171228210124.GI25436@ziepe.ca>
 <20180103102211.28307-1-benjamin.drung@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20180103102211.28307-1-benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Jan 03, 2018 at 11:22:11AM +0100, Benjamin Drung wrote:
> When udevadm is not available (e.g. in a minimal chroot environment),
> the rdma-core package installation will print these warnings:
> 
> /var/lib/dpkg/info/rdma-core.postinst: 33:
> /var/lib/dpkg/info/rdma-core.postinst: udevadm: not found
> /var/lib/dpkg/info/rdma-core.postinst: 34:
> /var/lib/dpkg/info/rdma-core.postinst: udevadm: not found
> /var/lib/dpkg/info/rdma-core.postinst: 35:
> /var/lib/dpkg/info/rdma-core.postinst: udevadm: not found
> 
> Add udev dependency to rdma-core and srptools (which provides udevadm),
> because these packages rely on udev to load the kernel modules.
> 
> Signed-off-by: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
>  debian/control            | 2 ++
>  debian/rdma-core.postinst | 6 +++---
>  debian/srptools.postinst  | 2 +-
>  3 files changed, 6 insertions(+), 4 deletions(-)

Makes sense to me

Reviewed-by: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
