From: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: can't get IB link with the for-next branch / IBoE patches
Date: Mon, 25 Oct 2010 18:17:30 +0200
Message-ID: <20101025161730.GA9335@mtldesk30>
References: <20101024075835.GA11359@mtldesk30>
 <adahbgbppgx.fsf@cisco.com>
 <20101024160018.GA32499@mtldesk30>
 <adaocajo90s.fsf@cisco.com>
 <AANLkTimb++kFYFXCWajBGACpA1OpCXyyeyD-98Ed3uTu@mail.gmail.com>
 <4CC54D4E.7050203@Voltaire.com>
 <4CC5604D.2080803@Voltaire.com>
 <adaaam2jswk.fsf@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <adaaam2jswk.fsf-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-hKgKHo2Ms0FWk0Htik3J/w@public.gmane.org>, RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Oct 25, 2010 at 06:36:43AM -0700, Roland Dreier wrote:
> 
> I suspect I broke either the UD header packing or the build_mlx_header
> function when I "cleaned up" the patches.  I see the same problem, I'll
> take a look today.

I think this will fix things up. The + operator has precedence over
the ? operator so we end up with packet_length equal IB_GRH_BYTES / 4
which is wrong.

diff --git a/drivers/infiniband/core/ud_header.c b/drivers/infiniband/core/ud_header.c
index 7e5d224..bb7e192 100644
--- a/drivers/infiniband/core/ud_header.c
+++ b/drivers/infiniband/core/ud_header.c
@@ -241,7 +241,7 @@ void ib_ud_header_init(int     		    payload_bytes,
 		packet_length = (IB_LRH_BYTES	+
 				 IB_BTH_BYTES	+
 				 IB_DETH_BYTES	+
-				 grh_present ? IB_GRH_BYTES : 0 +
+				 (grh_present ? IB_GRH_BYTES : 0) +
 				 payload_bytes	+
 				 4		+ /* ICRC     */
 				 3) / 4;	  /* round up */
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
