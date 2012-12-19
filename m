From: David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>
Subject: Re: [PATCH v2 2/2] IB/srp: Avoid endless SCSI error handling loop
Date: Tue, 18 Dec 2012 23:09:24 -0500
Message-ID: <1355890164.23969.0.camel@obelisk.thedillows.org>
References: <50CB46A4.4050300@acm.org> <50CB47E7.2060308@acm.org>
	 <1355500552.18309.11.camel@frustration.ornl.gov> <50CB4FEB.3080104@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <50CB4FEB.3080104-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Vu Pham <vu-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Alex Turin <alextu-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, 2012-12-14 at 17:12 +0100, Bart Van Assche wrote:
> Thanks for the quick reply. You might have missed Vu's message though. 
> Vu Pham reported that v1 of this patch did not fix the endless error 
> handling loop (see e.g. 
> http://www.mail-archive.com/linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org/msg13713.html).
> 
> As far as I know invoking srp_send_tsk_mgmt() if the QP is in error is 
> harmless and won't even cause a delay.
> 
> The proposal to add a connection state test in srp_send_tsk_mgmt() makes 
> sense to me. That would help to reduce the time spent in the SCSI error 
> handler after an orderly target shutdown (when it sent a DREQ).

Did you update the patch? I think I'm on-board with the idea.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
