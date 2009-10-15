From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] opensm/opensm/osm_subnet.c: adjust buffer to ensure a
 '\n' is printed
Date: Thu, 15 Oct 2009 21:15:50 +0200
Message-ID: <20091015191550.GD20210@me>
References: <20091014172120.3cb11b5a.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20091014172120.3cb11b5a.weiny2-i2BcT+NCU+M@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 17:21 Wed 14 Oct     , Ira Weiny wrote:
> 
> From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
> Date: Wed, 14 Oct 2009 17:05:53 -0700
> Subject: [PATCH] opensm/opensm/osm_subnet.c: adjust buffer to ensure a '\n' is printed
> 
> 	When printing cached options strings which fill the print buffer.
> 	Adjust the length so the final snprintf(..., "\n"); can succeed.
> 
> Signed-off-by: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>

Applied. Thanks.

> ---
>  opensm/opensm/osm_subnet.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/opensm/opensm/osm_subnet.c b/opensm/opensm/osm_subnet.c
> index 647950e..ab9c327 100644
> --- a/opensm/opensm/osm_subnet.c
> +++ b/opensm/opensm/osm_subnet.c
> @@ -105,8 +105,8 @@ static void log_config_value(char *name, const char *fmt, ...)
>  	if (n > sizeof(buf))
>  		n = sizeof(buf);
>  	n += vsnprintf(buf + n, sizeof(buf) - n, fmt, args);
> -	if (n > sizeof(buf))
> -		n = sizeof(buf);
> +	if (n >= sizeof(buf)-1)

I'm changing this to 'n > sizeof(buf) - 2' to match below line.

> +		n = sizeof(buf)-2;

Sasha

>  	snprintf(buf + n, sizeof(buf) - n, "\n");
>  	va_end(args);
>  	printf("%s", buf);
> -- 
> 1.5.4.5
> 
> 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
