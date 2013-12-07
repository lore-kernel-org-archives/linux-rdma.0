From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH v2] osm_sm_state_mgr.c: Fix handling of polling retry
 number
Date: Sat, 07 Dec 2013 08:16:00 -0500
Message-ID: <52A31F90.9090602@dev.mellanox.co.il>
References: <dffb6af4-bcf7-45ed-a7ec-ce5972e3959e@default>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <dffb6af4-bcf7-45ed-a7ec-ce5972e3959e@default>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Line Holen <line.holen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Hal <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Linux-Rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 12/5/2013 9:10 AM, Line Holen wrote:
> The retry counter is now only updated if a packet is actually sent.
> (But as before the initial request is also counted.)
> 
> Prior to this change the actual maximum number of packets sent were
> polling retry number minus one.
> 
> Signed-off-by: Line Holen <line.holen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

Thanks. Applied.

-- Hal
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
