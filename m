From: Selvin Xavier <Selvin.Xavier-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org>
Subject: RE: [patch] RDMA/ocrdma: off by one in ocrdma_query_gid()
Date: Tue, 17 Feb 2015 05:32:26 +0000
Message-ID: <f40073c5-7478-445e-b977-55a47396d60b@CMEXHTCAS2.ad.emulex.com>
References: <20150216100136.GA5579@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150216100136.GA5579@mwanda>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Devesh Sharma <Devesh.Sharma-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org>, Mitesh Ahuja <Mitesh.Ahuja-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Acked-by: Selvin Xavier <selvin.xavier-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>

Thanks !

> -----Original Message-----
> From: Dan Carpenter [mailto:dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org]
> Sent: Monday, February 16, 2015 3:32 PM
> To: Roland Dreier
> Cc: Sean Hefty; Hal Rosenstock; Devesh Sharma; Selvin Xavier; Mitesh Ahuja;
> Yishai Hadas; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Subject: [patch] RDMA/ocrdma: off by one in ocrdma_query_gid()
> 
> The ->sgid_tbl[] array has OCRDMA_MAX_SGID number of elements so this
> test is off by one.  ->sgid_tbl is allocated in ocrdma_alloc_resources().
> 
> Signed-off-by: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> 
> diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
> b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
> index fb8d8c4..18ea619 100644
> --- a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
> +++ b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
> @@ -53,7 +53,7 @@ int ocrdma_query_gid(struct ib_device *ibdev, u8 port,
> 
>  	dev = get_ocrdma_dev(ibdev);
>  	memset(sgid, 0, sizeof(*sgid));
> -	if (index > OCRDMA_MAX_SGID)
> +	if (index >= OCRDMA_MAX_SGID)
>  		return -EINVAL;
> 
>  	memcpy(sgid, &dev->sgid_tbl[index], sizeof(*sgid));
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
