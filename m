From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] opensm/libvendor/osm_vendor_mlx_sa.c: Sync with
 osm_vendor_ibumad_sa.c
Date: Thu, 7 Apr 2011 20:02:58 +0300
Message-ID: <20110407170258.GE21920@calypso.voltaire.com>
References: <4D9B0ED1.2020805@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4D9B0ED1.2020805-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 08:45 Tue 05 Apr     , Hal Rosenstock wrote:
> 
> Changes for not setting attribute offset unless RMPP
> Added previous changes not merged:
> Added OSMV_QUERY_MULTIPATH_REC support in osmv_query_sa
> Changed bind info to indicate both is_responder and is_report_processor
> are FALSE rather than TRUE
> Use OSM_LOG rather than osm_log
> Cosmetic changes to log messages
> Made some routines static
> 
> Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---

Applied, thanks
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
