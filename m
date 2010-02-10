From: Yevgeny Kliteynik <kliteyn-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Subject: Re: [PATCH 02/11] opensm: Allow the routing engine to influence SL2VL
 calculations.
Date: Wed, 10 Feb 2010 18:15:57 +0200
Message-ID: <4B72DBBD.9020709@mellanox.co.il>
References: <1258744509-11148-1-git-send-email-jaschut@sandia.gov> <1258744509-11148-3-git-send-email-jaschut@sandia.gov>
Reply-To: kliteyn-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1255; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1258744509-11148-3-git-send-email-jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jim Schutt <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org, eitan-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Jim,

[snip...]

On 20/Nov/09 21:15, Jim Schutt wrote:
> diff --git a/opensm/opensm/osm_qos.c b/opensm/opensm/osm_qos.c
> index 08f9a60..f42c334 100644
> --- a/opensm/opensm/osm_qos.c
> +++ b/opensm/opensm/osm_qos.c
> @@ -194,6 +194,7 @@ static ib_api_status_t sl2vl_update(osm_sm_t * sm, osm_port_t * p_port,
>   {
>   	ib_api_status_t status;
>   	uint8_t i, num_ports;
> +	struct osm_routing_engine *re = sm->p_subn->p_osm->routing_engine_used;
>   	osm_physp_t *p_physp;
>
>   	if (osm_node_get_type(osm_physp_get_node_ptr(p)) == IB_NODE_TYPE_SWITCH) {
> @@ -213,8 +214,24 @@ static ib_api_status_t sl2vl_update(osm_sm_t * sm, osm_port_t * p_port,
>   	}
>
>   	for (i = 0; i<  num_ports; i++) {
> +		ib_slvl_table_t routing_sl2vl;
> +		const ib_slvl_table_t *port_sl2vl;
> +		const ib_slvl_table_t *port_sl2vl_old;
> +
> +		if (re->update_sl2vl) {
>    

If routing failed, and no_fallback specified, OSM crashes here.
The simple fix is, of course, just fixing the condition to
"(re && re->update_sl2vl)", but I think that it would be better
not to apply QoS configuration if unicast manager failed - just
restart the sweep.

-- Yevgeny



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
