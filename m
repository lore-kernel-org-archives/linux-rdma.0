From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: mlx4 missing completions (was Re: [PATCH-v2] ib_srpt: Initial SRP
 Target merge for v3.2-rc1)
Date: Thu, 27 Oct 2011 08:18:45 +0200
Message-ID: <CAO+b5-qF10SsF1L4ba8pZQZbfLgKHuG1GuGqX++ZTj0btZKuZg@mail.gmail.com>
References: <CAL1RGDV7jhRexKowk9JLcVJhb832RX672Da8UQSPK82OHEsw7A@mail.gmail.com>
 <CAO+b5-oc9KQ5Uw+7RbY1Z6fqbK+x4Bnw8wCrLAaediaqHMPAhA@mail.gmail.com>
 <CAL1RGDX=B4=3wJuBN6st429xarYqdnGAnmZ=r-7zX=8pQ_RjTA@mail.gmail.com>
 <CAO+b5-qs4PBrERtErfuYVZxhyshsxiFHOgzmFfbyomYZgYk47Q@mail.gmail.com> <CAL1RGDUmbkCkNYQ_YQYZfNaXvRktG0KU1Pdp6f85UMgocbWrNw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAL1RGDUmbkCkNYQ_YQYZfNaXvRktG0KU1Pdp6f85UMgocbWrNw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Vu Pham <vu-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Oct 26, 2011 at 10:06 PM, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org=
> wrote:
> On Wed, Oct 26, 2011 at 11:05 AM, Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org=
> wrote:
> > Can I conclude from your reply that the "last WQE" event refers to =
the
> > SRQ only and that it does not provide any information about the sen=
d
> > queue associated with the same QP ?
>
> That is correct as I understand things. =A0The "last WQE" event was a=
dded
> to handle the fact that if you have a QP associated to an SRQ, you ca=
n't
> know how many receives have been taken from the SRQ and are in flight
> on the receive queue. =A0The IB spec is a bit vague on what "last WQE=
"
> actually means but based on the background, I believe it means that t=
he
> last request on the receive queue has been processed, without saying
> anything about the send queue.

Are you sure about this ? There is a paragraph in the InfiniBand
Architecture Manual that can only be correct if "last WQE" refers to
both SRQ and send queue and not to the SRQ only. It is mentioned in
that manual that it is safe to reset the QP immediately after the last
WQE event has been received. A quote:

Note, for QPs that are associated with an SRQ, the Consumer should
take the QP through the Error State before invoking a Destroy QP or a
Modify QP to the Reset State. The Consumer may invoke the Destroy QP
without first performing a Modify QP to the Error State and waiting
for the Affiliated Asynchronous Last WQE Reached Event. However, if
the Consumer does not wait for the Affiliated Asynchronous Last WQE
Reached Event, then WQE and Data Segment leakage may occur. Therefore,
it is good programming practice to tear down a QP that is associated
with an SRQ by using the following process:
=95 Put the QP in the Error State;
=95 wait for the Affiliated Asynchronous Last WQE Reached Event;
=95 either:
=95 drain the CQ by invoking the Poll CQ verb and either wait for CQ to
be empty or the number of Poll CQ operations has exceeded CQ capacity
size; or
=95 post another WR that completes on the same CQ and wait for this WR
to return as a WC;
=95 and then invoke a Destroy QP or Reset QP.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
