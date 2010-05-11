From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] opensm/osm_log.h: osm_log_is_active should return true
 for syslog
Date: Tue, 11 May 2010 19:21:48 +0300
Message-ID: <20100511162148.GD28549@me>
References: <4BE91DF9.4020902@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4BE91DF9.4020902-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 12:06 Tue 11 May     , Yevgeny Kliteynik wrote:
> 
> osm_log() always logs messages that came with OSM_LOG_SYS level,
> so osm_log_is_active() should concur with this.
> As a by-product of this fix, OSM_LOG_SYS messages can now be
> printed with OSM_LOG macro, instead of using osm_log() directly.
> 
> Signed-off-by: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
> ---
>  opensm/include/opensm/osm_log.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/opensm/include/opensm/osm_log.h b/opensm/include/opensm/osm_log.h
> index b2f105a..a494bc3 100644
> --- a/opensm/include/opensm/osm_log.h
> +++ b/opensm/include/opensm/osm_log.h
> @@ -355,7 +355,7 @@ static inline void osm_log_set_level(IN osm_log_t * p_log,
>  static inline boolean_t osm_log_is_active(IN const osm_log_t * p_log,
>  					  IN osm_log_level_t level)
>  {
> -	return ((p_log->level & level) != 0);
> +	return (((OSM_LOG_SYS | p_log->level) & level) != 0);
>  }

What about to set OSM_LOG_SYS bits in p_log->level at stage of
initialization and to remove all subsequent explicit checks? Like this
(against master):

diff --git a/opensm/opensm/osm_log.c b/opensm/opensm/osm_log.c
index 54c2f36..bd4a200 100644
--- a/opensm/opensm/osm_log.c
+++ b/opensm/opensm/osm_log.c
@@ -119,7 +119,7 @@ void osm_log(IN osm_log_t * p_log, IN osm_log_level_t verbosity,
 #endif				/* __WIN__ */
 
 	/* If this is a call to syslog - always print it */
-	if (!(verbosity & (OSM_LOG_SYS | p_log->level)))
+	if (!(verbosity & p_log->level))
 		return;
 
 	va_start(args, p_str);
@@ -306,7 +306,7 @@ ib_api_status_t osm_log_init_v2(IN osm_log_t * p_log, IN boolean_t flush,
 				IN unsigned long max_size,
 				IN boolean_t accum_log_file)
 {
-	p_log->level = log_flags;
+	p_log->level = log_flags | OSM_LOG_SYS;
 	p_log->flush = flush;
 	p_log->count = 0;
 	p_log->max_size = max_size << 20; /* convert size in MB to bytes */


Sasha
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
