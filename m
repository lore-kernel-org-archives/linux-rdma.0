From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] opensm/libvendor: Fix compile warnings on 64 bit
 machines when building --with-osmv=sim
Date: Fri, 3 Jun 2011 13:48:53 +0300
Message-ID: <20110603104852.GF1098@calypso.voltaire.com>
References: <4DE7DE6A.9040100@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4DE7DE6A.9040100-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 15:03 Thu 02 Jun     , Hal Rosenstock wrote:
> 
> osm_vendor_mlx.c: In function '__osmv_get_send_txn':
> osm_vendor_mlx.c:708: warning: format '%llX' expects type 'long long unsigned int', but argument 4 has type 'uint64_t'
> osm_vendor_mlx.c:723: warning: format '%llX' expects type 'long long unsigned int', but argument 4 has type 'uint64_t'
> osm_vendor_mlx.c:733: warning: format '%llX' expects type 'long long unsigned int', but argument 4 has type 'uint64_t'
> osm_vendor_mlx.c:746: warning: format '%llX' expects type 'long long unsigned int', but argument 4 has type 'uint64_t'
> 
> osm_vendor_mlx_hca_sim.c: In function '__parse_ca_info_file':
> osm_vendor_mlx_hca_sim.c:268: warning: format '%016llx' expects type 'long long unsigned int', but argument 5 has type 'uint64_t'
> 
> osm_vendor_mlx_dispatcher.c: In function '__osmv_dispatch_route':
> osm_vendor_mlx_dispatcher.c:208: warning: format '%llX' expects type 'long long unsigned int', but argument 4 has type 'uint64_t'
> osm_vendor_mlx_dispatcher.c:221: warning: format '%llX' expects type 'long long unsigned int', but argument 4 has type 'uint64_t'
> osm_vendor_mlx_dispatcher.c: In function '__osmv_dispatch_simple_mad':
> osm_vendor_mlx_dispatcher.c:276: warning: format '%llX' expects type 'long long unsigned int', but argument 4 has type 'long unsigned int'
> osm_vendor_mlx_dispatcher.c: In function '__osmv_dispatch_rmpp_mad':
> osm_vendor_mlx_dispatcher.c:331: warning: format '%llX' expects type 'long long unsigned int', but argument 4 has type 'uint64_t'
> osm_vendor_mlx_dispatcher.c: In function '__osmv_dispatch_rmpp_rcv':
> osm_vendor_mlx_dispatcher.c:570: warning: format '%llX' expects type 'long long unsigned int', but argument 4 has type 'uint64_t'
> osm_vendor_mlx_dispatcher.c:624: warning: format '%llX' expects type 'long long unsigned int', but argument 5 has type 'uint64_t'
> osm_vendor_mlx_dispatcher.c:629: warning: format '%llX' expects type 'long long unsigned int', but argument 4 has type 'long unsigned int'
> osm_vendor_mlx_dispatcher.c: In function '__osmv_dispatch_accept_seg':
> osm_vendor_mlx_dispatcher.c:661: warning: format '%llX' expects type 'long long unsigned int', but argument 4 has type 'uint64_t'
> osm_vendor_mlx_dispatcher.c:674: warning: format '%llX' expects type 'long long unsigned int', but argument 4 has type 'uint64_t'
> 
> osm_vendor_mlx_sender.c: In function '__osmv_rmpp_send_segment':
> osm_vendor_mlx_sender.c:345: warning: format '%llX' expects type 'long long unsigned int', but argument 5 has type 'ib_net64_t'
> 
> Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---

Applied, thanks
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
