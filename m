From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: opensm/main.c: foce stdout to be line-buffered
Date: Tue, 23 Mar 2010 12:37:33 +0200
Message-ID: <20100323103733.GD4808@me>
References: <4B8E1D46.4090106@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4B8E1D46.4090106-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Yevgeny,

On 10:26 Wed 03 Mar     , Yevgeny Kliteynik wrote:
> When stdout is assigned to a terminal, it is line-buffered.
> But when opensm's stdout is redirected to a file, stdout
> becomes block-buffered, which means that '\n' won't cause
> the buffer to be flushed.

Such redirection happens in daemon mode. Another case would be
'opensm > somefile '. Where do you see the problem?

Would '-d2' option be related to the issue?

> 
> Forcing stdout to always be line-buffered.
> 
> Signed-off-by: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
> ---
>  opensm/opensm/main.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/opensm/opensm/main.c b/opensm/opensm/main.c
> index f9a33af..5ea65dd 100644
> --- a/opensm/opensm/main.c
> +++ b/opensm/opensm/main.c
> @@ -613,6 +613,9 @@ int main(int argc, char *argv[])
>  		{NULL, 0, NULL, 0}	/* Required at the end of the array */
>  	};
> 
> +	/* force stdout to be line-buffered */
> +	setlinebuf(stdout);

What about stderr? IOW describe your problem in more details (see above).

Sasha

> +
>  	/* Make sure that the opensm and complib were compiled using
>  	   same modes (debug/free) */
>  	if (osm_is_debug() != cl_is_debug()) {
> -- 
> 1.5.1.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
