From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH v1 2/3] IB/srp: Check ib_query_gid return value
Date: Mon, 24 Feb 2014 16:34:47 +0100
Message-ID: <530B6697.5020502@acm.org>
References: <1393252218-30638-1-git-send-email-sagig@mellanox.com> <1393252218-30638-3-git-send-email-sagig@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1393252218-30638-3-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 02/24/14 15:30, Sagi Grimberg wrote:
> Detected by Coverity.
> 
> Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>  drivers/infiniband/ulp/srp/ib_srp.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
> index 0e20bfb..b615135 100644
> --- a/drivers/infiniband/ulp/srp/ib_srp.c
> +++ b/drivers/infiniband/ulp/srp/ib_srp.c
> @@ -2652,7 +2652,9 @@ static ssize_t srp_create_target(struct device *dev,
>  	if (ret)
>  		goto err_free_mem;
>  
> -	ib_query_gid(ibdev, host->port, 0, &target->path.sgid);
> +	ret = ib_query_gid(ibdev, host->port, 0, &target->path.sgid);
> +	if (ret)
> +		goto err_free_mem;
>  
>  	shost_printk(KERN_DEBUG, target->scsi_host, PFX
>  		     "new target: id_ext %016llx ioc_guid %016llx pkey %04x "
> 

This patch looks fine to me, so

Acked-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
