From: "ira.weiny" <ira.weiny@intel.com>
Subject: Re: [PATCH][V2] IB/sysfs: remove unused va_list args
Date: Mon, 25 Jan 2016 13:41:50 -0500
Message-ID: <20160125184150.GB18364@phlsvsds.ph.intel.com>
References: <1453747086-31000-1-git-send-email-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1453747086-31000-1-git-send-email-colin.king@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Colin King <colin.king@canonical.com>
Cc: Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Christoph Lameter <cl@linux.com>, Matan Barak <matanb@mellanox.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Or Gerlitz <ogerlitz@mellanox.com>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@ubuntu.com
List-Id: linux-rdma@vger.kernel.org

On Mon, Jan 25, 2016 at 06:38:06PM +0000, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> _show_port_gid_attr performs a va_end on some unused va_list args.
> Clean this up by removing the args completely.
> 
> Fixes: 470be516a226e8 ("IB/core: Add gid attributes to sysfs")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Reviewed-by: Ira Weiny <ira.weiny@intel.com>

> ---
>  drivers/infiniband/core/sysfs.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/drivers/infiniband/core/sysfs.c b/drivers/infiniband/core/sysfs.c
> index 3de9351..ec46386 100644
> --- a/drivers/infiniband/core/sysfs.c
> +++ b/drivers/infiniband/core/sysfs.c
> @@ -336,7 +336,6 @@ static ssize_t _show_port_gid_attr(struct ib_port *p,
>  	union ib_gid gid;
>  	struct ib_gid_attr gid_attr = {};
>  	ssize_t ret;
> -	va_list args;
>  
>  	ret = ib_query_gid(p->ibdev, p->port_num, tab_attr->index, &gid,
>  			   &gid_attr);
> @@ -348,7 +347,6 @@ static ssize_t _show_port_gid_attr(struct ib_port *p,
>  err:
>  	if (gid_attr.ndev)
>  		dev_put(gid_attr.ndev);
> -	va_end(args);
>  	return ret;
>  }
>  
> -- 
> 1.9.1
> 
