From: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Subject: Re: mlx4 missing completions (was Re: [PATCH-v2] ib_srpt: Initial SRP
 Target merge for v3.2-rc1)
Date: Fri, 28 Oct 2011 09:11:19 -0700
Message-ID: <CAL1RGDXcBck-L_dUVOxGGQ4=2nDy266c3NPTn0MvfmEXyfRLAg@mail.gmail.com>
References: <CAL1RGDV7jhRexKowk9JLcVJhb832RX672Da8UQSPK82OHEsw7A@mail.gmail.com>
 <CAO+b5-oc9KQ5Uw+7RbY1Z6fqbK+x4Bnw8wCrLAaediaqHMPAhA@mail.gmail.com>
 <CAL1RGDX=B4=3wJuBN6st429xarYqdnGAnmZ=r-7zX=8pQ_RjTA@mail.gmail.com>
 <CAO+b5-qs4PBrERtErfuYVZxhyshsxiFHOgzmFfbyomYZgYk47Q@mail.gmail.com>
 <CAL1RGDUmbkCkNYQ_YQYZfNaXvRktG0KU1Pdp6f85UMgocbWrNw@mail.gmail.com> <CAO+b5-qF10SsF1L4ba8pZQZbfLgKHuG1GuGqX++ZTj0btZKuZg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAO+b5-qF10SsF1L4ba8pZQZbfLgKHuG1GuGqX++ZTj0btZKuZg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Vu Pham <vu-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Oct 26, 2011 at 11:18 PM, Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org> =
wrote:
> Note, for QPs that are associated with an SRQ, the Consumer should
> take the QP through the Error State before invoking a Destroy QP or a
> Modify QP to the Reset State. The Consumer may invoke the Destroy QP
> without first performing a Modify QP to the Error State and waiting
> for the Affiliated Asynchronous Last WQE Reached Event. However, if
> the Consumer does not wait for the Affiliated Asynchronous Last WQE
> Reached Event, then WQE and Data Segment leakage may occur. Therefore=
,
> it is good programming practice to tear down a QP that is associated
> with an SRQ by using the following process:
> =95 Put the QP in the Error State;
> =95 wait for the Affiliated Asynchronous Last WQE Reached Event;
> =95 either:
> =95 drain the CQ by invoking the Poll CQ verb and either wait for CQ =
to
> be empty or the number of Poll CQ operations has exceeded CQ capacity
> size; or
> =95 post another WR that completes on the same CQ and wait for this W=
R
> to return as a WC;
> =95 and then invoke a Destroy QP or Reset QP.

I think this only makes sense if you take this as being the way to wait
for all receive requests, and that some other unspecified method is use=
d
to wait for send requests.  After all, the send queue might be attached
to some other CQ so clearly something more is required to handle the
send queue.

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
