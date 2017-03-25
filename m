From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [patch] RDMA/ocrdma: fix a type issue in ocrdma_put_pd_num()
Date: Fri, 24 Mar 2017 21:11:40 -0400
Message-ID: <1490404300.2404.30.camel@redhat.com>
References: <20170223104016.GA27526@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170223104016.GA27526@mwanda>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Selvin Xavier <selvin.xavier-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
Cc: Devesh Sharma <devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, 2017-02-23 at 13:40 +0300, Dan Carpenter wrote:
> We want to return zero on success or negative error codes.  The type
> should be int and not u8.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> 
> diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
> b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
> index e06ad7250963..b1b075763eaa 100644
> --- a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
> +++ b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
> @@ -371,7 +371,7 @@ static int _ocrdma_pd_mgr_put_bitmap(struct
> ocrdma_dev *dev, u16 pd_id,
>  	return 0;
>  }
>  
> -static u8 ocrdma_put_pd_num(struct ocrdma_dev *dev, u16 pd_id,
> +static int ocrdma_put_pd_num(struct ocrdma_dev *dev, u16 pd_id,
>  				   bool dpp_pool)
>  {
>  	int status;

Thanks, applied for -rc.

-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
   
Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
