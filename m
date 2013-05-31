From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH] osm_console_io.c Memory leak when closing console
Date: Fri, 31 May 2013 05:48:21 -0400
Message-ID: <51A871E5.5010507@dev.mellanox.co.il>
References: <66f50a5a-e3dc-452c-ae73-9b07e2c12b3e@default>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <66f50a5a-e3dc-452c-ae73-9b07e2c12b3e@default>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Line Holen <line.holen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 5/30/2013 10:38 AM, Line Holen wrote:
> Use fclose() rather than close() to avoid memory leaks.
> Also lowered the loglevel of a couple of log messages.
> 
> Signed-off-by: Line Holen <Line.Holen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

Thanks. Applied.

-- Hal
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
