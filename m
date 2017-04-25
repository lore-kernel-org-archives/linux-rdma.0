From: Jonathan Toppins <jtoppins-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [rdma-core/rdma-ndd] Use integer as getopt_long returns integer
Date: Tue, 25 Apr 2017 16:10:34 -0400
Message-ID: <519c537c-793c-70a7-745c-79fb42e10a66@redhat.com>
References: <1493099392-1883-1-git-send-email-honli@redhat.com>
Reply-To: jtoppins-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1493099392-1883-1-git-send-email-honli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Honggang LI <honli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 04/25/2017 01:49 AM, Honggang LI wrote:
> From: Honggang Li <honli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> 
> ARM chars are unsigned by default. getopt_long return 255 instead -1.
> That will cause an endless loop for aarch64 platform.
> 
> Signed-off-by: Honggang Li <honli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  rdma-ndd/rdma-ndd.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/rdma-ndd/rdma-ndd.c b/rdma-ndd/rdma-ndd.c
> index 1579a02..e7be22b 100644
> --- a/rdma-ndd/rdma-ndd.c
> +++ b/rdma-ndd/rdma-ndd.c
> @@ -297,7 +297,7 @@ int main(int argc, char *argv[])
>  			{ }
>  		};
>  
> -		char c = getopt_long(argc, argv, "fh", long_opts, &opt_idx);
> +		int c = getopt_long(argc, argv, "fh", long_opts, &opt_idx);
>  		if (c == -1)
>  			break;
>  
> 

int is the return type of the function signature anyway so this was
wrong from the start.

https://linux.die.net/man/3/getopt_long

Acked-by: Jonathan Toppins <jtoppins-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
