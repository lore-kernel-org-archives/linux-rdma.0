From: "Paul Grun" <pgrun-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>
Subject: RE: Work completion error: "transport retry counter exceeded"
Date: Fri, 27 Jul 2012 09:50:40 -0700
Message-ID: <00e901cd6c17$f56161e0$e02425a0$@com>
References: <20120725190719.475605dc169353b775cd3463@llnl.gov> <CAL1RGDWmpHy43b5TarBWpUk1RXOEdNitXWE4+xRCspgfpwUisQ@mail.gmail.com> <CALfB72Ad4+R48Nc-kawsrk1JQo964OkJ6DE46mcR5b9pS2_hEA@mail.gmail.com> <CAL1RGDVwy56YL7OLxVuvap5WZRzzZsosQmKBkhWZB73uy3ysDg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAL1RGDVwy56YL7OLxVuvap5WZRzzZsosQmKBkhWZB73uy3ysDg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Roland Dreier' <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, 'Albert Strasheim' <fullung-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: 'Ira Weiny' <weiny2-i2BcT+NCU+M@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

In general this is correct.  This question came up recently in an entirely
different context (it happened to be RoCE), but the failure was strikingly
similar.  For those interested, here's the view from the IB spec
perspective.

============================================================================
==========================

There are two possible issues here, normal retries and the RNR-NAK protocol.

Normal Retries-
The transport can retry two types of errors (timeouts and sequence number
errors).  There is a 3-bit counter that the transport decrements whenever it
retries a packet due to a timeout or a NAK-sequence error. If the counter
expires, the message transfer (e.g. SEND, RDMA WRITE...) is terminated and
the work request is completed and marked in error which is how the verbs are
notified of the error.  This retry counter is an attribute of the QP and is
set using the Modify QP verb.

Timeouts are due to expiration of a thing called the Transport Timer, which
has a minimum duration of 8.192uS.  The Transport Timer is used to detect
genuinely lost packets and really bad stuff happening in the fabric.  The
transport starts the timer when it initiates its first work request, and
resets it every time a valid acknowledge message is received.  If the timer
expires, it means that the requester hasn't seen an acknowledge of any sort
for a really long time.  The value of this timer is also an attribute of the
QP and is set using the Modify QP verb. Setting the timer value to zero
disables the timer.

If the Transport Timer expires, the requester signals a locally detected
error.

It is very hard to predict these re-try interval.  If the error is due to a
NAK-sequence error (which means that the responder saw an out of sequence
packet), the requester will retry it right away.  Retries due to timeouts
are virtually impossible to predict.

RNR-NAK-
There are two parameters associated with this: the number of times an
RNR-NAK can be retried, and the interval between retries.  The number of
times an RNR-NAK can be retried is negotiated by the two parties during
connection establishment.  As above, this 3-bit counter, called "RNR Retry
Count" is an attribute of the QP and is set using the Modify QP verb.  A
value of 7 (111) means infinite retry.

If the counter expires, meaning that the requester received too many
RNR-NAKs, the requester signals a locally detected error.

Whenever it generates an RNR-NAK, the Responder indicates the minimum
interval that the requester must wait before retrying the request. This
value is returned to the requester as a field in the RNR-NAK, and can range
from .01mS up to 655.36mS.  As the above, this is an attribute of the QP and
is set using the Modify QP verb.

============================================================================
==========================

Note that both an "RNR-NAK retry count exceeded" and a "timeout" error are
reported in the same way, as a locally detected error.

Ira, are you by any chance sending immediate data with your RDMA Write?  

-Paul

> -----Original Message-----
> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-
> owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Roland Dreier
> Sent: Thursday, July 26, 2012 10:45 AM
> To: Albert Strasheim
> Cc: Ira Weiny; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Subject: Re: Work completion error: "transport retry counter exceeded"
> 
> > I wonder if I might be seeing the same thing...
> >
> > How does one choose a good value for this setting?
> >
> > Apparently it maps to 4.096 x 2 ^ attr.timeout microseconds.
> >
> > What's the maximum value one can set here?
> >
> > What can go wrong if one goes for the maximum value?
> 
> In theory you want a timeout of around 2 * max packet life in the fabric
> (ie max RTT) plus max remote HCA ack time (reported in device properties).
> 
> Max value is 31, which maps to a few hours.  If you choose that, then a
> single lost packet will stall your connection for many hours (if you
> choose 7 retries) before reporting an error.
> 
>  - R.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org More majordomo info at
> http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
