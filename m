From: Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: Re: [PATCH 05/14] IB/srp: Maintain a single connection per I_T nexus
Date: Thu, 13 Jun 2013 15:57:23 +0200
Message-ID: <51B9CFC3.8080008@profitbricks.com>
References: <51B87501.4070005@acm.org> <51B876BF.4070400@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <51B876BF.4070400-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>, Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Bart,

thanks for picking up the idea not to use this 'add_target' file for
manual reconnects. I have only small remarks but basically you've got my
Acked-by and Tested-by.

Please find the remarks in-line.

Cheers,
Sebastian

On 12.06.2013 15:25, Bart Van Assche wrote:
> An SRP target is required to maintain a single connection between
> initiator and target. This means that if the 'add_target' attribute
> is used to create a second connection to a target that the first
> connection will be logged out and that the SCSI error handler will
> kick in. The SCSI error handler will cause the SRP initiator to
> reconnect, which will cause I/O over the second connection to fail.
> Avoid such ping-pong behavior by disabling relogins. Note: if
> reconnecting manually is necessary, that is possible by deleting
> and recreating an rport via sysfs.
> 
> Signed-off-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
> Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
> Cc: Vu Pham <vu-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Cc: Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
> ---
>  drivers/infiniband/ulp/srp/ib_srp.c |   38 +++++++++++++++++++++++++++++++++++
>  1 file changed, 38 insertions(+)
> 
> diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
> index be12780..1a73b24 100644
> --- a/drivers/infiniband/ulp/srp/ib_srp.c
> +++ b/drivers/infiniband/ulp/srp/ib_srp.c
> @@ -556,6 +556,36 @@ static void srp_rport_delete(struct srp_rport *rport)
>  	srp_queue_remove_work(target);
>  }
>  
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

You've only changed the style of this function. Functionality is still
the same. Fine for me.

But why do you put it that high in the source code?
Do you (still) need it for something else?

I would put it directly in front of srp_create_target() or even in front
of that option parsing stuff for correct bottom-up.

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

Yes, this looks good! Nice idea to print the connection string!
Would be even cooler without trailing '\n' from within 'buf' but that's
okay.

I was a little bit afraid of overflows here so I did security testing.
But srp_parse_options() already rejected my evil connection strings. :-)

I've tried things like this:
id_ext=0002c903004ed0b2,\
ioc_guid=0002c903004ed0b2,\
dgid=fe800000000000000002c903004ed0b4,\
pkey=ffff,service_id=0002c903004ed0b2,\
xxxxxxxxxxxxxxxxxxxxxxxxx... until 4096 chars

id_ext=0002c903004ed0b2,\
ioc_guid=0002c903004ed0b2,\
dgid=fe800000000000000002c903004ed0b4,\
pkey=ffff,service_id=0002c903004ed0b2,\
id_ext=0002c903004ed0b2,\
ioc_guid=0002c903004ed0b2,\
dgid=fe800000000000000002c903004ed0b4,\
pkey=ffff,service_id=0002c903004ed0b2,\
... until 4096 chars

This string looked kind of funny. Also in the kernel message it was a
little bit longer than usual but the parsing detected that I have too
many parameters. So everything is fine in terms of security.

>  	if (!host->srp_dev->fmr_pool && !target->allow_ext_sg &&
>  				target->cmd_sg_cnt < target->sg_tablesize) {
>  		pr_warn("No FMR pool and no external indirect descriptors, limiting sg_tablesize to cmd_sg_cnt\n");
> 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
