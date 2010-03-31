From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH 2/3] IB/srp: use IB_CQ_REPORT_MISSED_EVENTS to avoid
	missed CQ callbacks
Date: Wed, 31 Mar 2010 21:16:32 +0200
Message-ID: <u2xe2e108261003311216mf128f95fg1540976ad0cc2b0d@mail.gmail.com>
References: <20100331175742.24522.17850.stgit@chromite.mv.qlogic.com>
	 <20100331175752.24522.66519.stgit@chromite.mv.qlogic.com>
	 <y2ie2e108261003311111uec1ec00g746ba0ffe3d98799@mail.gmail.com>
	 <adazl1oiccb.fsf@roland-alpha.cisco.com>
	 <u2ze2e108261003311136l4bcf1627n9ba4d3414167eef3@mail.gmail.com>
	 <adask7giak4.fsf@roland-alpha.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <adask7giak4.fsf-BjVyx320WGW9gfZ95n9DRSW4+XlvGpQz@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Mar 31, 2010 at 8:57 PM, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org> wrot=
e:
> =A0> Processing the flag IB_CQ_REPORT_MISSED_EVENTS causes several IB
> =A0> drivers to lock and unlock a spinlock. Full-speed SRP I/O can ca=
use
> =A0> this operation to be invoked more than 100.000 times a second, s=
o the
> =A0> flag IB_CQ_REPORT_MISSED_EVENTS will have a small but measurable
> =A0> impact on SRP I/O performance.
>
> It seems the only driver where that happens is ehca. =A0But on the ot=
her
> hand, for mthca/mlx4 it avoids doing something like:
>
> =A0cq event:
> =A0 =A0request notify <-- CQ is not empty, another event queued
> =A0 =A0drain CQ
>
> =A0cq event:
> =A0 =A0request notify
> =A0 =A0drain already empty CQ
>
> ie the overhead saved here looks a lot more.

I agree that Ralph's patch helps to avoid the above scenario and that
this should result in a performance improvement -- at least when
IB_CQ_REPORT_MISSED_EVENTS is implemented in an efficient way.

I have to admit that a few months ago I was puzzled myself by the code
in srp_completion() and that I was wondering why it worked. Around
that time I have been experimenting with a patch similar to the one
Ralph posted, and it resulted in lower performance on mlx4 hardware.
So it would help if someone could measure the performance of the SRP
initiator with and without Ralph's patch applied.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
