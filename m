From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH] osm_sa_multipath_record.c Use aliasGUIDs when building
 responses
Date: Wed, 15 May 2013 06:22:07 -0400
Message-ID: <519361CF.2000207@dev.mellanox.co.il>
References: <3127e9af-32d6-4b07-9468-6c9d950e5c0d@default>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <3127e9af-32d6-4b07-9468-6c9d950e5c0d@default>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Line Holen <line.holen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 5/13/2013 12:30 PM, Line Holen wrote:
> This patch makes multipath responses use the GUIDs supplied in the request
> when filling in response packets. Previously it could replace a aliasGUID
> with the baseGUID (portGUID) of the port.
> This change makes multipath record handling consistent with path record
> handling.
> 
> Signed-off-by: Line Holen <Line.Holen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

Thanks. Applied.

-- Hal
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
