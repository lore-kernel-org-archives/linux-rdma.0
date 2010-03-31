From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 1/3] IB/core: use IB_CQ_REPORT_MISSED_EVENTS to avoid missed	CQ callbacks
Date: Wed, 31 Mar 2010 11:07:29 -0700
Message-ID: <29F490E86BF1405C8620B8138312AFD9@amr.corp.intel.com>
References: <20100331175742.24522.17850.stgit@chromite.mv.qlogic.com> <20100331175747.24522.88472.stgit@chromite.mv.qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100331175747.24522.88472.stgit-/vjeY7uYZjrPXfVEPVhPGq6RkeBMCJyt@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Ralph Campbell' <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Can this be structure as:

do {

> 	while (ib_poll_cq(port_priv->cq, 1, &wc) == 1) {
> 		if (wc.status == IB_WC_SUCCESS) {
> 			switch (wc.opcode) {
>@@ -2246,6 +2247,10 @@ static void ib_mad_completion_handler(struct work_struct
>*work)
> 		} else
> 			mad_error_handler(port_priv, &wc);
> 	}
>+	ret = ib_req_notify_cq(port_priv->cq, IB_CQ_NEXT_COMP |
>+					      IB_CQ_REPORT_MISSED_EVENTS);

} while (ret > 0);

to avoid using a goto for loop control?  Although, there's no reason to rearm
the CQ multiple times.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
