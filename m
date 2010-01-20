From: "Slava Strebkov" <slavas-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: RE: [PATCH v2] opensm: Multicast root switch calculation
Date: Wed, 20 Jan 2010 13:32:38 +0200
Message-ID: <39C75744D164D948A170E9792AF8E7CA01F6FA8A@exil.voltaire.com>
References: <4B17C712.9010109@Voltaire.COM> <20100120102703.GB25576@me>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-class: urn:content-classes:message
In-Reply-To: <20100120102703.GB25576@me>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Eli Dorfman <elid-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Sasha,
"average hops" was chosen instead of "max hops" because in root weight
calculation the number of ports is also important, not only the distance
(hops).

Slava

-----Original Message-----
From: Sasha Khapyorsky [mailto:sashakvolt-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org] On Behalf Of Sasha
Khapyorsky
Sent: Wednesday, January 20, 2010 12:27 PM
To: Slava Strebkov
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Eli Dorfman; Or Gerlitz; Yevgeny
Kliteynik
Subject: Re: [PATCH v2] opensm: Multicast root switch calculation

Hi Slava,

On 16:11 Thu 03 Dec     , Slava Strebkov wrote:
> Proposed new algorithm for calculation of root switch for multicast
> spanning tree. Only edge switches(those connected to hosts) and
> switches - multicast members themselves are involved in root
calculation.
> This gives improvement, especially on large fabrics, since number of
> switches usually much less then the number of ports, shared same mcast
> group.
> 
> Signed-off-by: Slava Strebkov <slavas-smomgflXvOZWk0Htik3J/w@public.gmane.org>
> ---

[snip]

> @@ -231,32 +342,27 @@ static float
osm_mcast_mgr_compute_max_hops(osm_sm_t * sm, cl_qlist_t * l,
>     of the multicast group.
>
**********************************************************************/
>  static osm_switch_t *mcast_mgr_find_optimal_switch(osm_sm_t * sm,
> -						   cl_qlist_t *list)
> +						   cl_qlist_t * list)
>  {
>  	cl_qmap_t *p_sw_tbl;
>  	osm_switch_t *p_sw, *p_best_sw = NULL;
>  	float hops = 0;
>  	float best_hops = 10000;	/* any big # will do */
> -#ifdef OSM_VENDOR_INTF_ANAFA
> -	boolean_t use_avg_hops = TRUE;	/* anafa2 - bug hca on switch
*//* use max hops for root */
> -#else
> -	boolean_t use_avg_hops = FALSE;	/* use max hops for root */
> -#endif
> -
> +	cl_qmap_t mcast_member_sw_tbl;
>  	OSM_LOG_ENTER(sm->p_log);
>  
>  	p_sw_tbl = &sm->p_subn->sw_guid_tbl;
>  
> +	mcast_mgr_build_switch_map(sm, list, &mcast_member_sw_tbl);
>  	for (p_sw = (osm_switch_t *) cl_qmap_head(p_sw_tbl);
>  	     p_sw != (osm_switch_t *) cl_qmap_end(p_sw_tbl);
>  	     p_sw = (osm_switch_t *) cl_qmap_next(&p_sw->map_item)) {
>  		if (!osm_switch_supports_mcast(p_sw))
>  			continue;
>  
> -		if (use_avg_hops)
> -			hops = osm_mcast_mgr_compute_avg_hops(sm, list,
p_sw);
> -		else
> -			hops = osm_mcast_mgr_compute_max_hops(sm, list,
p_sw);
> +		hops =
> +		    osm_mcast_mgr_compute_avg_hops_weight(sm, p_sw,
> +
&mcast_member_sw_tbl);

Any reason why was root switch computation method changed? By default it
was "max hops" based and as far as I can see you changed this to
"average hops".

Sasha

>  
>  		OSM_LOG(sm->p_log, OSM_LOG_DEBUG,
>  			"Switch 0x%016" PRIx64 ", hops = %f\n",
> @@ -277,6 +383,7 @@ static osm_switch_t
*mcast_mgr_find_optimal_switch(osm_sm_t * sm,
>  		OSM_LOG(sm->p_log, OSM_LOG_VERBOSE,
>  			"No multicast capable switches detected\n");
>  
> +	mcast_mgr_destroy_switch_map(sm, &mcast_member_sw_tbl);
>  	OSM_LOG_EXIT(sm->p_log);
>  	return p_best_sw;
>  }
> -- 
> 1.6.3.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma"
in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
