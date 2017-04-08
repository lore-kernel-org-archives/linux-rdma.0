From: Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH 2/3] IB/srp: Enclose 14 expressions for the sizeof
 operator by parentheses
Date: Sat, 08 Apr 2017 07:50:25 -0700
Message-ID: <1491663025.3250.39.camel@perches.com>
References: <50db1f1d-b689-1a9d-f6dd-a0f55169c75a@users.sourceforge.net>
         <a7bdda64-7cd8-1107-9669-6ab0f70e16ad@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <a7bdda64-7cd8-1107-9669-6ab0f70e16ad-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: SF Markus Elfring <elfring-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Sat, 2017-04-08 at 14:12 +0200, SF Markus Elfring wrote:
[]
> diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
[]
> @@ -3308,7 +3308,7 @@ static ssize_t srp_create_target(struct device *dev,
>  	target_host->max_channel = 0;
>  	target_host->max_id      = 1;
>  	target_host->max_lun     = -1LL;
> -	target_host->max_cmd_len = sizeof ((struct srp_cmd *) (void *) 0L)->cdb;
> +	target_host->max_cmd_len = sizeof(((struct srp_cmd *)(void *)0L)->cdb);

Maybe better as:

	target_host->max_cmd_len = FIELD_SIZEOF(struct srp_cmd, cdb);

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
