From: "Jim Schutt" <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
Subject: Re: [PATCH] opensm/osm_dump.c: dump SL2VL tables
Date: Fri, 16 Apr 2010 08:19:11 -0600
Message-ID: <1271427551.4092.170.camel@sale659.sandia.gov>
References: <4BAB879E.30203@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4BAB879E.30203-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Yevgeny,

If this patch is included on top of my torus-2QoS
patchset, you might want the addition below.

This is because my patchset causes SL2VL maps to
always be set when a routing engine registers its
intent to do so by providing an update_sl2vl() function,
without requiring opensm to be invoked with -Q.

So we want to dump SL2VL tables also in that case.

On Thu, 2010-03-25 at 09:56 -0600, Yevgeny Kliteynik wrote:
> Hi Sasha,
> 
> Dumping SL2VL tables in ROUTING verbosity level when QoS is on.
> This is needed for SL2VL tables analysis in general, and for
> routing engines that are using IB VLs in particular, such as
> torus-2QoS.
> 
> Signed-off-by: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
> ---
>  opensm/opensm/osm_dump.c |   61 +++++++++++++++++++++++++++++++++++++++++++++-
>  1 files changed, 60 insertions(+), 1 deletions(-)

[snip]

> @@ -630,6 +684,11 @@ void osm_dump_all(osm_opensm_t * osm)
>  		osm_dump_qmap_to_file(osm, "opensm.mcfdbs",
>  				      &osm->subn.sw_guid_tbl,
>  				      dump_mcast_routes, osm);
> +		/* SL2VL tables */
> +		if (osm->subn.opt.qos)

-		if (osm->subn.opt.qos)
+		if (osm->subn.opt.qos ||
+		    (osm->routing_engine_used &&
+		     osm->routing_engine_used->update_sl2vl))

> +			osm_dump_qmap_to_file(osm, "opensm-sl2vl.dump",
> +					      &osm->subn.port_guid_tbl,
> +					      dump_sl2vl_tbl, osm);
>  	}
>  	osm_dump_qmap_to_file(osm, "opensm-subnet.lst",
>  			      &osm->subn.node_guid_tbl, dump_topology_node,

Sorry for the delay in noticing this.

-- Jim



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
