From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Upstream support for multicast IBoE
Date: Wed, 23 Nov 2011 23:17:02 +0200
Message-ID: <CAJZOPZ+mdMYqMZKYNmVas=cAUYiQRw_r=8ty7j5wB2mXJSs5bw@mail.gmail.com>
References: <20111122223812.GB2131@BohrerMBP.rgmadvisors.com>
	<CAL1RGDVF5FuVuToN56pmue1cUvHRw9kjaKC9xLOt51zeDJwMag@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAL1RGDVF5FuVuToN56pmue1cUvHRw9kjaKC9xLOt51zeDJwMag-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: Shawn Bohrer <sbohrer-EgGFQ3RFNTIP7C3xziwOQw@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org> wrote:
> looks like the libmlx4 patches I applied from you are missing multicast AH support?

Yes, when I reworked the patches for submission I went from easier
(RC) to harder (ucast UD + Vlans) and eventually didn't nailed down
the multicast front. I probably planned getting there on a later point
but it remained behind, anyway, if you're okay to have the "ad hoc
MGID -> ethernet address mapping" as you commented on this thread, I
can make the patch to add that.

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
