From: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: "Unicast, no dst" warning from IPoIB
Date: Mon, 22 Mar 2010 18:21:07 +0200
Message-ID: <20100322162107.GB12224@mtldesk030.lab.mtl.com>
References: <Pine.LNX.4.64.1003221142430.5956@zuben.voltaire.com>
	<20100322122040.GA12224@mtldesk030.lab.mtl.com>
	<4BA79714.8030600@Voltaire.COM>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4BA79714.8030600-hKgKHo2Ms0F+cjeuK/JdrQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Moni Shoua <monis-hKgKHo2Ms0F+cjeuK/JdrQ@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Mar 22, 2010 at 06:13:08PM +0200, Moni Shoua wrote:
> 
> Do you mean that it ("no dst for them anymore.") happened due to aging of the neigh?
Yes, the networking stack could do that while we were wating for a
REP.

> My intuition tells me that it should be a very rare scenario, if I guess your intension correctly.
Yes, it's rare. Last time I saw complaints on such messages was 3 years
ago...

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
