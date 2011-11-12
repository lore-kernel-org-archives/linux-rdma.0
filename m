From: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>
Subject: Re: [opensm] [PATCH] Fix potential memleak
Date: Fri, 11 Nov 2011 16:36:15 -0800
Message-ID: <1321058175.5518.2.camel@auk59.llnl.gov>
References: <1320972671.22519.364.camel@auk59.llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1320972671.22519.364.camel-akkeaxHeDKRliZ7u+bvwcg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hey Alex,

Argh!  You can forget about this patch.  It is a memleak, but I see why
an earlier author did it this way.  I'll solve the memleak in a
different way in a different patch series.

Al

On Thu, 2011-11-10 at 16:51 -0800, Albert Chu wrote:
> Strings may have been already strduped from config file parsing.
> 
> Signed-off-by: Albert L. Chu <chu11-i2BcT+NCU+M@public.gmane.org>
> ---
>  opensm/main.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/opensm/main.c b/opensm/main.c
> index f7a6d83..10cbef5 100644
> --- a/opensm/main.c
> +++ b/opensm/main.c
> @@ -553,6 +553,8 @@ int osm_manager_loop(osm_subn_opt_t * p_opt, osm_opensm_t * p_osm)
>  }
>  
>  #define SET_STR_OPT(opt, val) do { \
> +	if (opt) \
> +		free(opt); \
>  	opt = val ? strdup(val) : NULL ; \
>  } while (0)
>  
-- 
Albert Chu
chu11-i2BcT+NCU+M@public.gmane.org
Computer Scientist
High Performance Systems Division
Lawrence Livermore National Laboratory


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
