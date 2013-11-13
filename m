From: Jim Schutt <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
Subject: Re: [EXTERNAL] [PATCH opensm] Remove unused lid matrix calculation
 in Torus_2Qos routing
Date: Wed, 13 Nov 2013 08:08:15 -0700
Message-ID: <528395DF.2000602@sandia.gov>
References: <52820E8C.40509@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <52820E8C.40509-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Vladimir Koushnir <vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 11/12/2013 04:18 AM, Hal Rosenstock wrote:

Acked-by: Jim Schutt <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>

> 
> From: Vladimir Koushnir <vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> 
> Signed-off-by: Vladimir Koushnir <vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
> diff --git a/include/opensm/osm_ucast_mgr.h b/include/opensm/osm_ucast_mgr.h
> index c534b7e..b9c1ca1 100644
> --- a/include/opensm/osm_ucast_mgr.h
> +++ b/include/opensm/osm_ucast_mgr.h
> @@ -296,5 +296,7 @@ int osm_ucast_mgr_process(IN osm_ucast_mgr_t * p_mgr);
>  * SEE ALSO
>  *	Unicast Manager, Node Info Response Controller
>  *********/
> +
> +int ucast_dummy_build_lid_matrices(void *context);
>  END_C_DECLS
>  #endif				/* _OSM_UCAST_MGR_H_ */
> diff --git a/opensm/osm_torus.c b/opensm/osm_torus.c
> index 8139f1a..71753cf 100644
> --- a/opensm/osm_torus.c
> +++ b/opensm/osm_torus.c
> @@ -9550,6 +9550,7 @@ int osm_ucast_torus2QoS_setup(struct osm_routing_engine *r,
>  
>  	r->context = ctx;
>  	r->ucast_build_fwd_tables = torus_build_lfts;
> +	r->build_lid_matrices = ucast_dummy_build_lid_matrices;
>  	r->update_sl2vl = torus_update_osm_sl2vl;
>  	r->update_vlarb = torus_update_osm_vlarb;
>  	r->path_sl = torus_path_sl;
> diff --git a/opensm/osm_ucast_mgr.c b/opensm/osm_ucast_mgr.c
> index 6384362..9ef7947 100644
> --- a/opensm/osm_ucast_mgr.c
> +++ b/opensm/osm_ucast_mgr.c
> @@ -1182,3 +1182,8 @@ int osm_ucast_dor_setup(struct osm_routing_engine *r, osm_opensm_t * osm)
>  	r->ucast_build_fwd_tables = ucast_dor_build_lfts;
>  	return 0;
>  }
> +
> +int ucast_dummy_build_lid_matrices(void *context)
> +{
> +	return 0;
> +}
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
