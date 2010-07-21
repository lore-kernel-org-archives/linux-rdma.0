From: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V3] ib_qib: Allow writes to the diag_counters to be
 able to clear them
Date: Wed, 21 Jul 2010 14:01:21 -0700
Message-ID: <1279746081.31421.155.camel@chromite.mv.qlogic.com>
References: <20100713185318.faf1c5b8.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100713185318.faf1c5b8.weiny2-i2BcT+NCU+M@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Cc: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Acked-by: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>

On Tue, 2010-07-13 at 18:53 -0700, Ira Weiny wrote:
> From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
> Date: Wed, 7 Jul 2010 17:35:34 -0700
> Subject: [PATCH] ib_qib: Allow writes to the diag_counters to be able to clear them
> 
> Changes in V3:
> 	Add non-number error check
> 	Return "proper" proper length
> 
> Changes in V2:
> 	Add check for negative values
> 	Return proper length
> 
> Signed-off-by: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
> ---
>  drivers/infiniband/hw/qib/qib_sysfs.c |   21 ++++++++++++++++++++-
>  1 files changed, 20 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/infiniband/hw/qib/qib_sysfs.c b/drivers/infiniband/hw/qib/qib_sysfs.c
> index dab4d9f..b214eff 100644
> --- a/drivers/infiniband/hw/qib/qib_sysfs.c
> +++ b/drivers/infiniband/hw/qib/qib_sysfs.c
> @@ -347,7 +347,7 @@ static struct kobj_type qib_sl2vl_ktype = {
>  
>  #define QIB_DIAGC_ATTR(N) \
>  	static struct qib_diagc_attr qib_diagc_attr_##N = { \
> -		.attr = { .name = __stringify(N), .mode = 0444 }, \
> +		.attr = { .name = __stringify(N), .mode = 0664 }, \
>  		.counter = offsetof(struct qib_ibport, n_##N) \
>  	}
>  
> @@ -403,8 +403,27 @@ static ssize_t diagc_attr_show(struct kobject *kobj, struct attribute *attr,
>  	return sprintf(buf, "%u\n", *(u32 *)((char *)qibp + dattr->counter));
>  }
>  
> +static ssize_t diagc_attr_store(struct kobject *kobj, struct attribute *attr,
> +				const char *buf, size_t size)
> +{
> +	struct qib_diagc_attr *dattr =
> +		container_of(attr, struct qib_diagc_attr, attr);
> +	struct qib_pportdata *ppd =
> +		container_of(kobj, struct qib_pportdata, diagc_kobj);
> +	struct qib_ibport *qibp = &ppd->ibport_data;
> +	char *endp;
> +	long val = simple_strtol(buf, &endp, 0);
> +
> +	if (val < 0 || endp == buf)
> +		return -EINVAL;
> +
> +	*(u32 *)((char *)qibp + dattr->counter) = (u32)val;
> +	return size;
> +}
> +
>  static const struct sysfs_ops qib_diagc_ops = {
>  	.show = diagc_attr_show,
> +	.store = diagc_attr_store,
>  };
>  
>  static struct kobj_type qib_diagc_ktype = {


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
