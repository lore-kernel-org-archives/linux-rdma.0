From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: fixing blocking rdma_connect call on failure
Date: Mon, 11 Oct 2010 20:25:42 -0700
Message-ID: <adapqvg1495.fsf@cisco.com>
References: <OFD1E009D6.AB14F4A6-ONC12577AC.00485D02-C12577AC.0050EF83@ch.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <OFD1E009D6.AB14F4A6-ONC12577AC.00485D02-C12577AC.0050EF83-Xeyd2O9EBijQT0dZR+AlfA@public.gmane.org>
	(Animesh K. Trivedi1's message of "Tue, 28 Sep 2010 16:44:02 +0200")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Animesh K Trivedi1 <ATR-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>
Cc: Bernard Metzler <BMT-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Thanks, applied (with Steve Wise's ack-ed by).

This patch was actually whitespace mangled (tabs turned to spaces) and
so I had to apply it by hand.  In the future please try to send patches
with a mailer that does not mangle them, so that they can be handled
automatically.

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
