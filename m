From: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Subject: Re: [PATCH 01/20 v4b] ib_srp: Fix a race condition
Date: Tue, 14 Aug 2012 20:03:52 -0400
Message-ID: <1344989032.4652.0.camel@obelisk.thedillows.org>
References: <5023DA39.7020000@acm.org> <5023DAA1.1040507@acm.org>
	 <502A503D.5030604@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <502A503D.5030604-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, Joseph Glanville <joseph.glanville-2MxvZkOi9dvvnOemgxGiVw@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, 2012-08-14 at 13:18 +0000, Bart Van Assche wrote:
> Avoid that the scmnd->scsi_done(scmnd) call in srp_process_rsp()
> can trigger a crash by being invoked with scsi_done == NULL. That
> could happen if a reply is received during or after a command abort.

Acked-by: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>

Thanks!
-- 
Dave Dillow
National Center for Computational Science
Oak Ridge National Laboratory
(865) 241-6602 office

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
