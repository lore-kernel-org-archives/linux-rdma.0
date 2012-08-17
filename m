From: Sridhar Samudrala <sri-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 2/2] librdmacm/rstream: Use MSG_WAITALL for blocking
 test
Date: Fri, 17 Aug 2012 12:32:49 -0700
Message-ID: <1345231969.1128.5.camel@oc1677441337.ibm.com>
References: <1828884A29C6694DAF28B7E6B8A8237346A89A67@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A8237346A89A67-P5GAC/sN6hmkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, 2012-08-16 at 22:53 +0000, Hefty, Sean wrote:
> Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Acked-by: Sridhar Samudrala <sri-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>

> ---
>  examples/rstream.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/examples/rstream.c b/examples/rstream.c
> index befb7c6..1d221d0 100644
> --- a/examples/rstream.c
> +++ b/examples/rstream.c
> @@ -607,7 +607,7 @@ static int set_test_opt(char *optarg)
>  			use_async = 1;
>  			break;
>  		case 'b':
> -			flags &= ~MSG_DONTWAIT;
> +			flags = (flags & ~MSG_DONTWAIT) | MSG_WAITALL;
>  			break;
>  		case 'f':
>  			use_fork = 1;
> @@ -628,7 +628,7 @@ static int set_test_opt(char *optarg)
>  		} else if (!strncasecmp("async", optarg, 5)) {
>  			use_async = 1;
>  		} else if (!strncasecmp("block", optarg, 5)) {
> -			flags &= ~MSG_DONTWAIT;
> +			flags = (flags & ~MSG_DONTWAIT) | MSG_WAITALL;
>  		} else if (!strncasecmp("nonblock", optarg, 8)) {
>  			flags |= MSG_DONTWAIT;
>  		} else if (!strncasecmp("verify", optarg, 6)) {
> 
> 



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
