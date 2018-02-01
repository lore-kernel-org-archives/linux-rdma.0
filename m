From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH] Documentation/ABI: update infiniband sysfs interfaces
Date: Thu, 1 Feb 2018 15:08:11 -0700
Message-ID: <20180201220811.GA17053@ziepe.ca>
References: <20180201133233.GA21266@mordor.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20180201133233.GA21266-BxiFm0zuoZpSq9BJjBFyUp/QNRX+jHPU@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Aishwarya Pant <aishpant-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Julia Lawall <julia.lawall-L2FTfq7BK8M@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Feb 01, 2018 at 07:02:33PM +0530, Aishwarya Pant wrote:
> Add documentation for core and hardware specific infiniband interfaces.
> The descriptions have been collected from git commit logs, reading
> through code and data sheets. Some drivers have incomplete doc and are
> annotated with the comment '[to be documented]'.
> 
> Signed-off-by: Aishwarya Pant <aishpant-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>  Documentation/ABI/testing/sysfs-class-infiniband | 755 +++++++++++++++++++++++
>  1 file changed, 755 insertions(+)

Wow this looks really great

Should this patch delete some of the old documentation?

> diff --git a/Documentation/ABI/testing/sysfs-class-infiniband b/Documentation/ABI/testing/sysfs-class-infiniband

Lots, maybe even all of of this is considered stable..

> +sysfs interface for Broadcom NetXtreme-E RoCE driver
> +----------------------------------------------------
> +
> +What:		/sys/class/infiniband/bnxt_reX/fw_rev
> +What:		/sys/class/infiniband/bnxt_reX/hw_rev
> +What:		/sys/class/infiniband/bnxt_reX/hca_type

These are actually common to all drivers

 /sys/class/infiniband/XXX/fw_rev, etc

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
