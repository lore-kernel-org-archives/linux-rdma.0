From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH v2] opensm/osm_mcast_mgr.c: fix
 osm_mcast_mgr_compute_max_hops for managed switch
Date: Thu, 24 Dec 2009 16:26:19 +0200
Message-ID: <20091224142619.GN26940@me>
References: <4B322CBC.1070805@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4B322CBC.1070805-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 16:44 Wed 23 Dec     , Yevgeny Kliteynik wrote:
> If a certain mcast group has only one member, and this
> member is a switch, OSM fails to select this switch
> when trying to create spanning tree for this mcast group:
> 
> ERR 0A08: Unable to locate a suitable switch for group 0xC000
> ERR 0A17: Unable to create spanning tree (IB_ERROR) for mlid 0xc000
> 
> Signed-off-by: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>

Applied. Thanks.

Sasha
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
