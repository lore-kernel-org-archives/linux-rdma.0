From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH] [TRIVIAL] opensm: Fix small compile error
Date: Tue, 21 Jan 2014 23:33:09 -0500
Message-ID: <52DF4A05.3060202@dev.mellanox.co.il>
References: <1390348306.6153.356.camel@auk59.llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1390348306.6153.356.camel-akkeaxHeDKRliZ7u+bvwcg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Al,

On 1/21/2014 6:51 PM, Albert Chu wrote:
> Signed-off-by: Albert L. Chu <chu11-i2BcT+NCU+M@public.gmane.org>
> ---
>  osmeventplugin/src/osmeventplugin.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/osmeventplugin/src/osmeventplugin.c b/osmeventplugin/src/osmeventplugin.c
> index 1eaf7ea..0feada8 100644
> --- a/osmeventplugin/src/osmeventplugin.c
> +++ b/osmeventplugin/src/osmeventplugin.c
> @@ -195,7 +195,7 @@ static void report(void *_log, osm_epi_event_id_t event_id, void *event_data)
>  		fprintf(log->log_file, "Heavy sweep completed\n");
>  		break;
>  	case OSM_EVENT_ID_UCAST_ROUTING_DONE:
> -		fprintf(log->log_file, "Unicast routing completed %d\n", event_data);
> +		fprintf(log->log_file, "Unicast routing completed %p\n", event_data);

I see the problem. I have a different fix for this. Patch shortly.

-- Hal

>  		break;
>  	case OSM_EVENT_ID_STATE_CHANGE:
>  		fprintf(log->log_file, "SM state changed\n");

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
