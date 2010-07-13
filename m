From: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 09/36] drivers/infiniband: Remove unnecessary casts of
 private_data
Date: Tue, 13 Jul 2010 11:41:37 -0700
Message-ID: <1279046497.2296.170.camel@chromite.mv.qlogic.com>
References: <cover.1278967120.git.joe@perches.com>
	 <0074ff36bc27b141d3639e2d516cc6cd48364df6.1278967120.git.joe@perches.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <0074ff36bc27b141d3639e2d516cc6cd48364df6.1278967120.git.joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>
Cc: Jiri Kosina <trivial-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Infinipath <Infinipath-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>, Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Acked-by: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>

On Mon, 2010-07-12 at 13:50 -0700, Joe Perches wrote:
> Signed-off-by: Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>
> ---
>  drivers/infiniband/hw/ipath/ipath_file_ops.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/infiniband/hw/ipath/ipath_file_ops.c b/drivers/infiniband/hw/ipath/ipath_file_ops.c
> index 9c5c66d..65eb892 100644
> --- a/drivers/infiniband/hw/ipath/ipath_file_ops.c
> +++ b/drivers/infiniband/hw/ipath/ipath_file_ops.c
> @@ -2055,7 +2055,7 @@ static int ipath_close(struct inode *in, struct file *fp)
>  
>  	mutex_lock(&ipath_mutex);
>  
> -	fd = (struct ipath_filedata *) fp->private_data;
> +	fd = fp->private_data;
>  	fp->private_data = NULL;
>  	pd = fd->pd;
>  	if (!pd) {


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
