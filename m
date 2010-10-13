From: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: Work completions generated after a queue pair has made the
 transition to an error state
Date: Wed, 13 Oct 2010 18:32:00 +0200
Message-ID: <20101013163200.GG1617@mtldesk30>
References: <AANLkTimcxsymqmzoki=quCH+a2sq_fPb4YOmf3gqrzqh@mail.gmail.com>
 <1286909435.27343.93.camel@chromite.mv.qlogic.com>
 <AANLkTi=72Y+coH1Ke4U-Xk7Eaqpw5pipWRqXEQr7dOau@mail.gmail.com>
 <20101012202221.GD1617@mtldesk30>
 <4CB5B94E.4080802@voltaire.com>
 <20101013142303.GF1617@mtldesk30>
 <adawrpmyt5w.fsf@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <adawrpmyt5w.fsf-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>, Linux-RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Oct 13, 2010 at 09:05:47AM -0700, Roland Dreier wrote:
>  > "If the status of the operation that generates the Work Completion is
>  > anything other than success, the contents of the Work Completion are
>  > undefined except as noted below. The contents of a Work Completion
>  > are:"
> 
> Yes, that is exactly right.  And the "noted below" fields are the status
> and the WR ID.  Everything else is undefined if the status is not success.
> 
I see... those that have "This is always valid".
Thanks.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
