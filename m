From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH trivial] IB/srp: Allow newline separator for connection
 string
Date: Mon, 20 Oct 2014 17:08:17 +0200
Message-ID: <54452561.1050508@acm.org>
References: <1413731942-3317-1-git-send-email-sagig@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1413731942-3317-1-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 10/19/14 17:19, Sagi Grimberg wrote:
> In case last argument of the connection string is
> processed as a string (destination gid for example).
>
> Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>   drivers/infiniband/ulp/srp/ib_srp.c |    2 +-
>   1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
> index 62d2a18..5f590cf 100644
> --- a/drivers/infiniband/ulp/srp/ib_srp.c
> +++ b/drivers/infiniband/ulp/srp/ib_srp.c
> @@ -2760,7 +2760,7 @@ static int srp_parse_options(const char *buf, struct srp_target_port *target)
>   		return -ENOMEM;
>
>   	sep_opt = options;
> -	while ((p = strsep(&sep_opt, ",")) != NULL) {
> +	while ((p = strsep(&sep_opt, ",\n")) != NULL) {
>   		if (!*p)
>   			continue;

Hello Sagi,

It has already happened that users were confused by a write into the 
"add_target" sysfs attribute that failed because of a newline not being 
accepted as a separator. This patch will avoid such confusion so I think 
it's an improvement. Hence,

Acked-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>

Roland, can you queue this patch for kernel 3.19 ?

Thanks,

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
