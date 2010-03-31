From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH 2/3] IB/srp: use IB_CQ_REPORT_MISSED_EVENTS to avoid
	missed CQ callbacks
Date: Wed, 31 Mar 2010 20:36:12 +0200
Message-ID: <u2ze2e108261003311136l4bcf1627n9ba4d3414167eef3@mail.gmail.com>
References: <20100331175742.24522.17850.stgit@chromite.mv.qlogic.com>
	 <20100331175752.24522.66519.stgit@chromite.mv.qlogic.com>
	 <y2ie2e108261003311111uec1ec00g746ba0ffe3d98799@mail.gmail.com>
	 <adazl1oiccb.fsf@roland-alpha.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <adazl1oiccb.fsf-BjVyx320WGW9gfZ95n9DRSW4+XlvGpQz@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Mar 31, 2010 at 8:18 PM, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org> wrot=
e:
>
> =A0> The SRP initiator works fine without this patch, and this patch =
slows
> =A0> down the SRP initiator.
>
> I do agree that there are no missed callbacks without this patch, but=
 I
> don't see how it would slow things down... it seems to me it would av=
oid
> some CQ event callbacks, especially for HCAs where
> IB_CQ_REPORT_MISSED_EVENTS never returns >0 for missed events.

Processing the flag IB_CQ_REPORT_MISSED_EVENTS causes several IB
drivers to lock and unlock a spinlock. Full-speed SRP I/O can cause
this operation to be invoked more than 100.000 times a second, so the
flag IB_CQ_REPORT_MISSED_EVENTS will have a small but measurable
impact on SRP I/O performance.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
