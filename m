From: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: DREQ timeout for rdma-cm consumers
Date: Tue, 26 Jan 2010 18:16:43 +0200 (IST)
Message-ID: <Pine.LNX.4.64.1001261749260.13804@zuben.voltaire.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Sean,

I'm trying to understand what is the time out (e.g for DREQ) used by
the ib cm when called by the rdmacm through rdma_connect.

1st, going empirically it looks like 100 seconds pass between a call
to rdma_disconnect and getting RDMA_CM_EVENT_DISCONNECTED after taking
the relevant IB port at the caller side down, does this makes sense?

2nd, looking on the code, I see that cma_connect_ib uses CMA_CM_RESPONSE_TIMEOUT
(20) for req.remote_cm_response_timeout and CMA_MAX_CM_RETRIES (15) for
req.max_cm_retries. Looking into the cm code, I see that ib_send_cm_req sets
cm_id_priv->timeout_ms as a function of the path packet_life_time &&
the remote_cm_response_timeout ... with the latter value being 20 and the
former being 18 (this is a guess) does 100 seconds of a timeout makes
sense to you?

Or.

Just in case it helps, following the call to rdma_disconnect, in
about few ms all pending WRare flushed to the CQ, so I assume its
not the cma_modify_qp_err calls which blocks the cma from calling
ib_send_cm_dreq. Looking on the code, I see that if ib_send_cm_dreq
returns non zero, ib_send_cm_drep is called, and that ib_send_cm_dreq
would would enter_timewait and return non zero if ib_post_send_mad returns
non zero. When a port is down, I assume ib_post_send_mad fails, correct?
All in all, sounds like this way or another the cm will move to the time
wait state...




--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
