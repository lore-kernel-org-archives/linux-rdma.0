From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH for-next 06/16] IB/hfi1: hfi1_open_file() missing
 kobject_put in err path
Date: Fri, 26 Jan 2018 08:51:52 -0700
Message-ID: <20180126155152.GB23869@ziepe.ca>
References: <20180126142640.6868.12402.stgit@scvm10.sc.intel.com>
 <20180126143203.6868.85360.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20180126143203.6868.85360.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michael J Ruhl <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Alex Estrin <alex.estrin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Jan 26, 2018 at 06:32:06AM -0800, Dennis Dalessandro wrote:
> From: Alex Estrin <alex.estrin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> 
> The dd refcount is speculatively incremented prior to allocating
> the fd memory with kzalloc(). If that kzalloc() failed the dd
> refcount leaks.
> 
> Fixes: e11ffbd57520 ("IB/hfi1: Do not free hfi1 cdev parent structure early")
> Reviewed-by: Michael J Ruhl <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Alex Estrin <alex.estrin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>  drivers/infiniband/hw/hfi1/file_ops.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/infiniband/hw/hfi1/file_ops.c b/drivers/infiniband/hw/hfi1/file_ops.c
> index 7750a9c..d7bdf3d 100644
> +++ b/drivers/infiniband/hw/hfi1/file_ops.c
> @@ -210,6 +210,7 @@ static int hfi1_file_open(struct inode *inode, struct file *fp)
>  		fd->dd = dd;
>  		fp->private_data = fd;
>  	} else {
> +		kobject_put(&dd->kobj);
>  		fp->private_data = NULL;
>  
>  		if (atomic_dec_and_test(&dd->user_refcount))

Ugh that reads horribly.

Put the kobject_get when you copy the pointer:

                fd->dd = dd;
                kobject_get(&fd->dd->kobj);

Then it actually makes sense what is happening.

Jsaon

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
