From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH] Fixes wrong assertion failed in osm_switch_get_lft_block()
Date: Fri, 02 Jan 2015 08:25:45 -0500
Message-ID: <54A69C59.3000905@dev.mellanox.co.il>
References: <5495BE60.50301@simula.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5495BE60.50301-S8y2klWGCOFhl2p70BpVqQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vangelis Tasoulas <vangelis-S8y2klWGCOFhl2p70BpVqQ@public.gmane.org>
Cc: Linux RDMA Mailing List <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 12/20/2014 1:22 PM, Vangelis Tasoulas wrote:
> From a399cd7398a86b72541c628588365c252882cd80 Mon Sep 17 00:00:00 2001
> From: Vangelis Tasoulas <vangelis-e629+x1LERvk1uMJSBkQmQ@public.gmane.org>
> Date: Sat, 20 Dec 2014 19:10:33 +0100
> Subject: [PATCH] Fixes wrong assertion failed in osm_switch_get_lft_block()
>  when LIDs from the top LFT block (0xbfc0-0xbfff) are used.

Thanks. Applied.

-- Hal
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
