From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] opemsm code cleanup
Date: Wed, 28 Oct 2009 18:15:07 +0200
Message-ID: <20091028161506.GD6843@me>
References: <394674AC37584063BC9059F30CB083C9@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <394674AC37584063BC9059F30CB083C9-Zpru7NauK7drdx17CPfAsdBPR1lH4CV8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Stan C. Smith" <stan.smith-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 10:43 Tue 27 Oct     , Stan C. Smith wrote:
> 
> Cleanup code by removing if statement which does nothing.
> 
> Signed-off-by: stan smith <stan.smith-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Whitespaces are mangled in the patch. Applied by hands. Thanks.

Sasha

> 
> diff --git a/opensm/opensm/osm_vl15intf.c b/opensm/opensm/osm_vl15intf.c
> index 9e43a9c..ee9626f 100644
> --- a/opensm/opensm/osm_vl15intf.c
> +++ b/opensm/opensm/osm_vl15intf.c
> @@ -271,9 +271,6 @@ ib_api_status_t osm_vl15_init(IN osm_vl15_t * p_vl, IN osm_vendor_t * p_vend,
>          */
>         status = cl_thread_init(&p_vl->poller, vl15_poller, p_vl,
>                                 "opensm poller");
> -       if (status != IB_SUCCESS)
> -               goto Exit;
> -
>  Exit:
>         OSM_LOG_EXIT(p_log);
>         return (status);
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
