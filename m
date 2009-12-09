From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [ewg] [PATCH] IPoIB: synchronize timer deletion with completion handler
Date: Wed, 09 Dec 2009 14:39:49 -0800
Message-ID: <adapr6npya2.fsf@roland-alpha.cisco.com>
References: <20091207172210.GA8441@mtls03>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20091207172210.GA8441@mtls03> (Eli Cohen's message of "Mon, 7
	Dec 2009 19:22:10 +0200")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Cc: Linux RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, ewg <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


 > When calling del_timer_sync on priv->poll_timer, it is necessary to prevent
 > farther arming of the timer which can be done by a completion handler. Though
 > it is harmless since the timer will eventually stop being rearmed, it is better
 > practice to avoid calling the timer function after it is deleted. This patch
 > handles this by using a new flag that is checked before arming the timer.

have you seen this in practice?  If it can happen then it's not
harmless, since the module could be unloaded with the timer pending.
However I don't see how it could happen, since we only seem to delete
the timer after we know that no more completions are coming (except for
the case where we decide that the hardware is wedged but it really only
takes a *long* time to respond at exactly the wrong time, and we somehow
get a completion between the del_timer_sync and the modify QP to reset
state -- which is so unlikely it seems not worth adding this extra
complexity for -- maybe we could add the del_timer_sync to after we
delete the CQ or something if you're really worried)
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
