From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: mlx4 missing completions (was Re: [PATCH-v2] ib_srpt: Initial SRP
 Target merge for v3.2-rc1)
Date: Wed, 26 Oct 2011 20:05:14 +0200
Message-ID: <CAO+b5-qs4PBrERtErfuYVZxhyshsxiFHOgzmFfbyomYZgYk47Q@mail.gmail.com>
References: <CAL1RGDV7jhRexKowk9JLcVJhb832RX672Da8UQSPK82OHEsw7A@mail.gmail.com>
 <CAO+b5-oc9KQ5Uw+7RbY1Z6fqbK+x4Bnw8wCrLAaediaqHMPAhA@mail.gmail.com> <CAL1RGDX=B4=3wJuBN6st429xarYqdnGAnmZ=r-7zX=8pQ_RjTA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAL1RGDX=B4=3wJuBN6st429xarYqdnGAnmZ=r-7zX=8pQ_RjTA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Vu Pham <vu-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Oct 26, 2011 at 12:04 AM, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org=
> wrote:
> Sorry, but now I confused about what the bug is. =A0You have a QP
> associated with an SRQ, and you transition the QP to error. =A0At som=
e
> point you get a "last WQE received" event for that QP (which means
> all receive requests for that QP have completed), and you drain the
> CQ after that, which means you are guaranteed to have processed
> all the receive requests for that QP. =A0(At least this is how the ve=
rbs
> are supposed to work).
>
> I don't think there is any way to guarantee that every request posted
> to the SRQ is taken by a QP. =A0You just have to make sure that you
> tear down every QP as above, and then you know when there are
> no more QPs associated to the SRQ that any receive requests that
> haven't completed are still on the SRQ, and you can free their
> resources after you destroy the SRQ.

I've learned something since I posted the message at the start of this
thread: all error completions are posted on the CQ but draining the CQ
immediately after having received the last WQE event is not
sufficient. The CQ polling loop has to remain active a little longer
in order to receive all receive and send error completions. Issuing
"rmmod ib_srpt" during I/O works now without delay for SVN trunk
r3900.

I've had another look at the LIO version of ib_srpt and the way it
handles completions should ensure that all error completions get
processed (if any such completions are generated of course).

Can I conclude from your reply that the "last WQE" event refers to the
SRQ only and that it does not provide any information about the send
queue associated with the same QP ?

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
