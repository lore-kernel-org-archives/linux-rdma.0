From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH] osm_sm_state_mgr.c: Fix handling of polling retry number
Date: Tue, 03 Dec 2013 09:30:08 -0500
Message-ID: <529DEAF0.60109@dev.mellanox.co.il>
References: <3b0cb098-1e00-417d-8a5b-0aa766926867@default> <5295E2AF.2050909@dev.mellanox.co.il> <529604BB.4010001@oracle.com> <529DD9F5.2050902@dev.mellanox.co.il> <529DE851.3010802@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <529DE851.3010802-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Line Holen <line.holen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Linux-Rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 12/3/2013 9:18 AM, Line Holen wrote:
> On 12/03/13 14:17, Hal Rosenstock wrote:
>> Yes, it looks to me like the locking here needs fixing. I'll send a
>> patch for this shortly...
> OK, good. Do you want me to send a v2 rebased on top of this patch that
> incorporate
> your initial comment ?

Yes, please.

-- Hal

> 
> Line
> 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
