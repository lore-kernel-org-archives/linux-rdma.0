From: Patrick MacArthur <pmacarth-zcUZCMB5SQOVc3sceRu5cw@public.gmane.org>
Subject: Re: [PATCH librdmacm] rstream: fix "-T resolve" detection
Date: Mon, 21 Apr 2014 11:37:18 -0400
Message-ID: <53553B2E.9010404@iol.unh.edu>
References: <1398093444-24384-1-git-send-email-pmacarth@iol.unh.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1398093444-24384-1-git-send-email-pmacarth-zcUZCMB5SQOVc3sceRu5cw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi, Sean,

Add:

Signed-off-by: Patrick MacArthur <pmacarth-zcUZCMB5SQOVc3sceRu5cw@public.gmane.org>

I can resend the patch if you would like.

Thanks,
Patrick

-- 
Patrick MacArthur <pmacarth-zcUZCMB5SQOVc3sceRu5cw@public.gmane.org>
AIM: PmacarthAtIOL

Research and Development, High Performance Networking and Storage
UNH InterOperability Laboratory

On 04/21/2014 11:17 AM, Patrick MacArthur wrote:
> The effect of the check for "-T resolve" was reversed, so that -T with
> any invalid value would result in the "-T resolve" behavior, and
> "-T resolve" would result in an error.
> ---
>  examples/rstream.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/examples/rstream.c b/examples/rstream.c
> index 27326c2ebc7f..05598a89755d 100644
> --- a/examples/rstream.c
> +++ b/examples/rstream.c
> @@ -577,7 +577,7 @@ static int set_test_opt(char *optarg)
>  			flags = (flags & ~MSG_DONTWAIT) | MSG_WAITALL;
>  		} else if (!strncasecmp("nonblock", optarg, 8)) {
>  			flags |= MSG_DONTWAIT;
> -		} else if (strncasecmp("resolve", optarg, 7)) {
> +		} else if (!strncasecmp("resolve", optarg, 7)) {
>  			use_rgai = 1;
>  		} else if (!strncasecmp("verify", optarg, 6)) {
>  			verify = 1;
> 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
