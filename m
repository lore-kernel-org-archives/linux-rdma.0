From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: Work completions generated after a queue pair has made the transition to an error state
Date: Wed, 13 Oct 2010 09:18:44 -0700
Message-ID: <adapqveyskb.fsf@cisco.com>
References: <AANLkTimcxsymqmzoki=quCH+a2sq_fPb4YOmf3gqrzqh@mail.gmail.com>
	<1286909435.27343.93.camel@chromite.mv.qlogic.com>
	<AANLkTi=72Y+coH1Ke4U-Xk7Eaqpw5pipWRqXEQr7dOau@mail.gmail.com>
	<20101012202221.GD1617@mtldesk30>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101012202221.GD1617@mtldesk30> (Eli Cohen's message of "Tue,
	12 Oct 2010 22:22:21 +0200")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>, Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Linux-RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

I'm not clear on the problem observed here.  A few notes:

 - If a QP transitions to error state, then *all* work requests, whether
   or not they were signaled, generate a completion with status "flush".

 - If a work request completes with an error status, then the opcode
   field is not defined.

With that understood, can you explain what part of the IB spec is not
being implemented correctly?

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
