From: "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
Subject: Re: [PATCH] ib_srpt: Fix Last WQE handling
Date: Mon, 07 Nov 2011 12:46:06 -0800
Message-ID: <1320698766.30780.35.camel@haakon2.linux-iscsi.org>
References: <201111061831.17756.bvanassche@acm.org>
	 <CAL1RGDW+um6nT=K+0x4ibR41TeQZVcVvXH1ZS=32tx=Fp5ZtXg@mail.gmail.com>
	 <CAO+b5-pLv9PeO1E2kG7utsP4_rh49NfmPji2SVxBJQ2+OTZg4w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAO+b5-pLv9PeO1E2kG7utsP4_rh49NfmPji2SVxBJQ2+OTZg4w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, 2011-11-07 at 20:00 +0100, Bart Van Assche wrote:
> On Mon, Nov 7, 2011 at 7:10 PM, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org=
> wrote:
> > On Sun, Nov 6, 2011 at 9:31 AM, Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org=
> wrote:
> >> Make sure that the last WQE event is handled properly if it arrive=
s
> >> before the QP has been transitioned into the error state.
> >
> > Do you mean if the event arrives before the modify QP operation
> > returns?  If so I agree this is a possible order of events...
> >
> > Otherwise I'm not sure I follow: the last WQE event can't be
> > generated until the QP is in the error state (which of course
> > can happen before ib_modify_qp() returns)
>=20
> The patch should be fine, but the description is not entirely correct=
:
> it should have been "... if it arrives before ib_modify_qp() has been
> invoked to transition the QP in the error state". Invoking
> ib_modify_qp() is not the only way via which a QP can reach the error
> state - transport errors can cause this too.
>=20

Hi Bart,

This patch fails to compile with the following:

drivers/infiniband/ulp/srpt/ib_srpt.c: In function =E2=80=98srpt_perfor=
m_rdmas=E2=80=99:
drivers/infiniband/ulp/srpt/ib_srpt.c:2936: error: =E2=80=98CH_RELEASIN=
G=E2=80=99 undeclared (first use in this function)
drivers/infiniband/ulp/srpt/ib_srpt.c:2936: error: (Each undeclared ide=
ntifier is reported only once
drivers/infiniband/ulp/srpt/ib_srpt.c:2936: error: for each function it=
 appears in.)

I'm assuming this needs to be changed to CH_DRAINING instead, yes..?

Thanks,

--nab


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
