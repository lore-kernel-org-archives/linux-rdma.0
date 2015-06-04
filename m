From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH] Removed *p_ftree from function *sw_create().
Date: Thu, 04 Jun 2015 10:02:15 -0400
Message-ID: <55705A67.2090707@dev.mellanox.co.il>
References: <1433419971-29067-1-git-send-email-vangelis@simula.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1433419971-29067-1-git-send-email-vangelis-S8y2klWGCOFhl2p70BpVqQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vangelis <vangelis-S8y2klWGCOFhl2p70BpVqQ@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 6/4/2015 8:12 AM, Vangelis wrote:
> ftree_fabric_t *p_ftree is not used anywhere in OpenSM's function sw_create().
> ---
>  opensm/osm_ucast_ftree.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)

Thanks. Applied.

-- Hal
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
