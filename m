From: Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 05/14] IB/srp: Maintain a single connection per I_T nexus
Date: Thu, 13 Jun 2013 10:50:13 -0700
Message-ID: <51BA0655.6090707@mellanox.com>
References: <51B87501.4070005@acm.org> <51B876BF.4070400@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <51B876BF.4070400-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>, Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hello Bart,

> +/**
> + * srp_conn_unique() - check whether the connection to a target is unique
> + */
> +static bool srp_conn_unique(struct srp_host *host,
> +			    struct srp_target_port *target)
> +{
> +	struct srp_target_port *t;
> +	bool ret = false;
> +
> +	if (target->state == SRP_TARGET_REMOVED)
> +		goto out;
> +
> +	ret = true;
> +
> +	spin_lock(&host->target_lock);
> +	list_for_each_entry(t, &host->target_list, list) {
> +		if (t != target &&
> +		    target->id_ext == t->id_ext &&
>   

Targets may advertise/expose on different pkeys
You can have multiple connections  (or paths/scsi hosts) to same target 
with different pkeys.
We need extra check to detect the uniqueness:
                                             target->path.pkey == 
t->path.pkey &&

-vu
> +		    target->ioc_guid == t->ioc_guid &&
> +		    target->initiator_ext == t->initiator_ext) {
> +			ret = false;
> +			break;
> +		}
> +	}
> +	spin_unlock(&host->target_lock);
> +
> +out:
> +	return ret;
> +}
> +
>  static int srp_connect_target(struct srp_target_port *target)
>  {
>  	int retries = 3;
> @@ -2261,6 +2291,14 @@ static ssize_t srp_create_target(struct device *dev,
>  	if (ret)
>  		goto err;
>  
> +	if (!srp_conn_unique(target->srp_host, target)) {
> +		shost_printk(KERN_INFO, target->scsi_host,
> +			     PFX "Already connected to target port %.*s\n",
> +			     (int)count, buf);
> +		ret = -EEXIST;
> +		goto err;
> +	}
> +
>  	if (!host->srp_dev->fmr_pool && !target->allow_ext_sg &&
>  				target->cmd_sg_cnt < target->sg_tablesize) {
>  		pr_warn("No FMR pool and no external indirect descriptors, limiting sg_tablesize to cmd_sg_cnt\n");
>   

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
