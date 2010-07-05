From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] opensm: event plig-in API fixed to compile with g++
Date: Mon, 5 Jul 2010 21:11:43 +0300
Message-ID: <20100705181143.GG22860@me>
References: <4C2312F0.8020308@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4C2312F0.8020308-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 11:10 Thu 24 Jun     , Yevgeny Kliteynik wrote:
> Event API should have been able to be used by libraries
> written both in C and C++.

I don't know about such requirement. Personally I would strongly suggest
to not mix things without really good reason - we discussed already about
"extern "C"" removal in a future.

> The problem is, one of the
> fields in struct osm_event_plugin is called "delete".
> Changing it to "destroy" and promoting the API version.

This will break any existing plugin now (I know at least couple). I
don't think that such change is appropriate for "between RCs" period.

Sasha

> Signed-off-by: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
> ---
>  opensm/include/opensm/osm_event_plugin.h    |    2 +-
>  opensm/opensm/osm_event_plugin.c            |    4 ++--
>  opensm/osmeventplugin/libosmeventplugin.ver |    2 +-
>  opensm/osmeventplugin/src/osmeventplugin.c  |    2 +-
>  4 files changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/opensm/include/opensm/osm_event_plugin.h b/opensm/include/opensm/osm_event_plugin.h
> index 0b3464e..aa3fed4 100644
> --- a/opensm/include/opensm/osm_event_plugin.h
> +++ b/opensm/include/opensm/osm_event_plugin.h
> @@ -145,7 +145,7 @@ typedef struct osm_api_ps_event {
>  typedef struct osm_event_plugin {
>  	const char *osm_version;
>  	void *(*create) (struct osm_opensm *osm);
> -	void (*delete) (void *plugin_data);
> +	void (*destroy) (void *plugin_data);
>  	void (*report) (void *plugin_data, osm_epi_event_id_t event_id,
>  			void *event_data);
>  } osm_event_plugin_t;
> diff --git a/opensm/opensm/osm_event_plugin.c b/opensm/opensm/osm_event_plugin.c
> index 2d67065..7f61960 100644
> --- a/opensm/opensm/osm_event_plugin.c
> +++ b/opensm/opensm/osm_event_plugin.c
> @@ -141,8 +141,8 @@ DLOPENFAIL:
>  void osm_epi_destroy(osm_epi_plugin_t * plugin)
>  {
>  	if (plugin) {
> -		if (plugin->impl->delete)
> -			plugin->impl->delete(plugin->plugin_data);
> +		if (plugin->impl->destroy)
> +			plugin->impl->destroy(plugin->plugin_data);
>  		dlclose(plugin->handle);
>  		free(plugin->plugin_name);
>  		free(plugin);
> diff --git a/opensm/osmeventplugin/libosmeventplugin.ver b/opensm/osmeventplugin/libosmeventplugin.ver
> index f755ff6..0c3a85b 100644
> --- a/opensm/osmeventplugin/libosmeventplugin.ver
> +++ b/opensm/osmeventplugin/libosmeventplugin.ver
> @@ -6,4 +6,4 @@
>  # API_REV - advance on any added API
>  # RUNNING_REV - advance any change to the vendor files
>  # AGE - number of backward versions the API still supports
> -LIBVERSION=1:0:0
> +LIBVERSION=2:0:0
> diff --git a/opensm/osmeventplugin/src/osmeventplugin.c b/opensm/osmeventplugin/src/osmeventplugin.c
> index f40f7fe..a82be07 100644
> --- a/opensm/osmeventplugin/src/osmeventplugin.c
> +++ b/opensm/osmeventplugin/src/osmeventplugin.c
> @@ -207,6 +207,6 @@ static void report(void *_log, osm_epi_event_id_t event_id, void *event_data)
>  osm_event_plugin_t osm_event_plugin = {
>        osm_version:OSM_VERSION,
>        create:construct,
> -      delete:destroy,
> +      destroy:destroy,
>        report:report
>  };
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
