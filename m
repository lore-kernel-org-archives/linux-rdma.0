From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH] IB/core: Don't return EINVAL from sysfs rate attribute
 for invalid speeds
Date: Mon, 02 Apr 2012 16:28:09 -0400
Message-ID: <4F7A0BD9.1090502@dev.mellanox.co.il>
References: <CAL1RGDVH28u1tY3K8Mw29wfzXVeYR-mNDDvfpABsoSTmZA56Ww@mail.gmail.com> <1333395332-17982-1-git-send-email-roland@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1333395332-17982-1-git-send-email-roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 4/2/2012 3:35 PM, Roland Dreier wrote:
> From: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
> 
> Commit e9319b0cb00d ("IB/core: Fix SDR rates in sysfs") changed our
> sysfs rate attribute to return EINVAL to userspace if the underlying
> device driver returns an invalid rate.  Apparently some drivers do this
> when the link is down and some userspace pukes if it gets an error when
> reading this attribute, so avoid a regression by not return an error to
> match the old code.
> 
> Signed-off-by: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
> ---
> I think I'd rather just add this, to get back closer to the original
> behavior even for non-fixed drivers (but I'll still merge the mlx4
> patch, since that makes sense too).
> 
>  drivers/infiniband/core/sysfs.c |    9 +++++----
>  1 files changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/infiniband/core/sysfs.c b/drivers/infiniband/core/sysfs.c
> index 83b720e..246fdc1 100644
> --- a/drivers/infiniband/core/sysfs.c
> +++ b/drivers/infiniband/core/sysfs.c
> @@ -179,7 +179,7 @@ static ssize_t rate_show(struct ib_port *p, struct port_attribute *unused,
>  {
>  	struct ib_port_attr attr;
>  	char *speed = "";
> -	int rate = -1;		/* in deci-Gb/sec */
> +	int rate;		/* in deci-Gb/sec */
>  	ssize_t ret;
>  
>  	ret = ib_query_port(p->ibdev, p->port_num, &attr);
> @@ -187,9 +187,6 @@ static ssize_t rate_show(struct ib_port *p, struct port_attribute *unused,
>  		return ret;
>  
>  	switch (attr.active_speed) {
> -	case IB_SPEED_SDR:
> -		rate = 25;
> -		break;
>  	case IB_SPEED_DDR:
>  		speed = " DDR";
>  		rate = 50;
> @@ -210,6 +207,10 @@ static ssize_t rate_show(struct ib_port *p, struct port_attribute *unused,
>  		speed = " EDR";
>  		rate = 250;
>  		break;
> +	case IB_SPEED_SDR:
> +	default:		/* default to SDR for invalid rates */
> +		rate = 25;
> +		break;
>  	}
>  
>  	rate *= ib_width_enum_to_int(attr.active_width);

Should there be a similar change to ib_width_enum_to_int implementation
in ib_verbs.h and then rate < 0 returning -EINVAL here can be removed ?

-- Hal
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
