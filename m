From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH v2] opensm: Clean up event subscriptions if a port goes
 away
Date: Tue, 10 Sep 2013 15:35:25 -0400
Message-ID: <522F747D.8050906@dev.mellanox.co.il>
References: <dbf27ce6-a17f-4913-acf2-accd2bdb1103@default>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <dbf27ce6-a17f-4913-acf2-accd2bdb1103@default>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Line Holen <line.holen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Linux-Rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 9/10/2013 6:50 AM, Line Holen wrote:
> Event subscriptions needs to be cleaned up if a port goes away.
> If the port comes online again later it may no longer want to
> receive the events on the same QPN. If the "old" QPN is used for
> something else the SM forwarding events may cause QKey violations.
> 
> This behavior is made configurable and it needs to be explicitly
> enabled (default is off).
> 
> Signed-off-by: Line Holen <Line.Holen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

Thanks. Applied.

-- Hal
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
