From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: mlx4 missing completions (was Re: [PATCH-v2] ib_srpt: Initial SRP
 Target merge for v3.2-rc1)
Date: Tue, 25 Oct 2011 20:09:38 +0200
Message-ID: <CAO+b5-oc9KQ5Uw+7RbY1Z6fqbK+x4Bnw8wCrLAaediaqHMPAhA@mail.gmail.com>
References: <CAL1RGDV7jhRexKowk9JLcVJhb832RX672Da8UQSPK82OHEsw7A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAL1RGDV7jhRexKowk9JLcVJhb832RX672Da8UQSPK82OHEsw7A-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: "Nicholas A. Bellinger\"" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Vu Pham <vu-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Oct 25, 2011 at 1:17 PM, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>=
 wrote:
> On Mon, Oct 24, 2011 at 11:07 PM, Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org=
> wrote:
> >> As far as I know every HCA supported by Linux does implement this
> >> correctly. =A0Which class did you have in mind as not doing that?
> >
> > At least QDR ConnectX 2 HCAs with fairly recent firmware. This
> > behavior can be reproduced easily with the SCST version of ib_srpt =
as
> > follows:
> > 1. Log in from an SRP initiator to ib_srpt.
> > 2. Start a direct I/O read test, e.g. with fio.
> > 3. Issue the command "rmmod ib_srpt" on the target during I/O.
>
> OK, this is a pretty serious bug in mlx4_ib if true. =A0Are
> you sure that you really are seeing some pending work
> requests not generating a flush error when the QP transitions
> to the error state?

It's a little more complex than that. The original version of ib_srpt
stops polling for completions as soon as the last WQE event has been
received and after that the queue has been drained. So I don't know
whether these flush errors were not delivered or whether these were
delivered too late.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
