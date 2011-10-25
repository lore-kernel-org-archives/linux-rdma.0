From: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Subject: Re: mlx4 missing completions (was Re: [PATCH-v2] ib_srpt: Initial SRP
 Target merge for v3.2-rc1)
Date: Tue, 25 Oct 2011 15:04:37 -0700
Message-ID: <CAL1RGDX=B4=3wJuBN6st429xarYqdnGAnmZ=r-7zX=8pQ_RjTA@mail.gmail.com>
References: <CAL1RGDV7jhRexKowk9JLcVJhb832RX672Da8UQSPK82OHEsw7A@mail.gmail.com>
 <CAO+b5-oc9KQ5Uw+7RbY1Z6fqbK+x4Bnw8wCrLAaediaqHMPAhA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAO+b5-oc9KQ5Uw+7RbY1Z6fqbK+x4Bnw8wCrLAaediaqHMPAhA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: "Nicholas A. Bellinger\"" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Vu Pham <vu-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Oct 25, 2011 at 11:09 AM, Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org> wrote:
> It's a little more complex than that. The original version of ib_srpt
> stops polling for completions as soon as the last WQE event has been
> received and after that the queue has been drained. So I don't know
> whether these flush errors were not delivered or whether these were
> delivered too late.

Sorry, but now I confused about what the bug is.  You have a QP
associated with an SRQ, and you transition the QP to error.  At some
point you get a "last WQE received" event for that QP (which means
all receive requests for that QP have completed), and you drain the
CQ after that, which means you are guaranteed to have processed
all the receive requests for that QP.  (At least this is how the verbs
are supposed to work).

So what goes wrong with ConnectX?

I don't think there is any way to guarantee that every request posted
to the SRQ is taken by a QP.  You just have to make sure that you
tear down every QP as above, and then you know when there are
no more QPs associated to the SRQ that any receive requests that
haven't completed are still on the SRQ, and you can free their
resources after you destroy the SRQ.

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
