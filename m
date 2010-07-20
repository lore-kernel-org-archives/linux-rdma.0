From: "Tung, Chien Tin" <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH for-2.6.36] ib: fix some sparse warnings
Date: Tue, 20 Jul 2010 06:53:00 -0700
Message-ID: <2EFBCAEF10980645BBCFB605689E08E9049B2B666C@azsmsx506.amr.corp.intel.com>
References: <Pine.LNX.4.64.1007201458210.3835@zuben.voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <Pine.LNX.4.64.1007201458210.3835-aDiYczhfhVLdX2U7gxhm1tBPR1lH4CV8@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> Subject: [PATCH for-2.6.36] ib: fix some sparse warnings
> 
> fixed the following drivers/infiniband sparse pointed issues
> 

> nes_verbs.c:1944:45: warning: Using plain integer as NULL pointer
> nes_verbs.c:1944:48: warning: Using plain integer as NULL pointer
>   CHECK   drivers/infiniband/hw/nes/nes_cm.c
> nes_cm.c:2645:43: warning: mixing different enum types
> nes_cm.c:2645:43:     int enum iw_cm_event_type  versus
> nes_cm.c:2645:43:     int enum iw_cm_event_status


> 
> Signed-off-by: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>


Thanks Or!

Acked-by: Chien Tung <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
