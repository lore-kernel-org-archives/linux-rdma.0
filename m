From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH] Segfault in osm_mgrp_delete_port()
Date: Thu, 30 May 2013 09:39:10 -0400
Message-ID: <51A7567E.8040901@dev.mellanox.co.il>
References: <051b06cb-edf4-4b84-9030-1a1108d5fe25@default> <51A745B1.2000406@dev.mellanox.co.il> <51A75224.3020004@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <51A75224.3020004-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Line Holen <line.holen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 5/30/2013 9:20 AM, Line Holen wrote:
> On 05/30/13 14:27, Hal Rosenstock wrote:

>> Should we fix this "globally" in OpenSM to make it easier for tools
>> which complain about unused return values ?
> Regardless of tools complaining about this I find it useful to see that
> you ignore
> function return values deliberately. It's not a big deal to me, but I'm
> in favor of
> such a change. I'm not sure I can volunteer to do it on a global basis
> though -
> at least not right now....

I put this on a TODO list but as low priority.

-- Hal
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
