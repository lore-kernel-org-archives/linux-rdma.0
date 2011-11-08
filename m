From: "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
Subject: Re: [PATCH] ib_srpt: Fix Last WQE handling
Date: Tue, 08 Nov 2011 02:00:08 -0800
Message-ID: <1320746408.30780.174.camel@haakon2.linux-iscsi.org>
References: <201111061831.17756.bvanassche@acm.org>
	 <CAL1RGDW+um6nT=K+0x4ibR41TeQZVcVvXH1ZS=32tx=Fp5ZtXg@mail.gmail.com>
	 <CAO+b5-pLv9PeO1E2kG7utsP4_rh49NfmPji2SVxBJQ2+OTZg4w@mail.gmail.com>
	 <1320698766.30780.35.camel@haakon2.linux-iscsi.org>
	 <CAO+b5-oJx3knOG+6ra3j-TtOuc9y0ueaCofLbwoB5=gcECJ=fA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAO+b5-oJx3knOG+6ra3j-TtOuc9y0ueaCofLbwoB5=gcECJ=fA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, 2011-11-08 at 08:21 +0100, Bart Van Assche wrote:
> On Mon, Nov 7, 2011 at 9:46 PM, Nicholas A. Bellinger
> <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org> wrote:
> > On Mon, 2011-11-07 at 20:00 +0100, Bart Van Assche wrote:
> >> On Mon, Nov 7, 2011 at 7:10 PM, Roland Dreier <roland@purestorage.=
com> wrote:
> >> > On Sun, Nov 6, 2011 at 9:31 AM, Bart Van Assche <bvanassche@acm.=
org> wrote:
> >> >> Make sure that the last WQE event is handled properly if it arr=
ives
> >> >> before the QP has been transitioned into the error state.
> >
> > This patch fails to compile with the following:
> >
> > drivers/infiniband/ulp/srpt/ib_srpt.c: In function =E2=80=98srpt_pe=
rform_rdmas=E2=80=99:
> > drivers/infiniband/ulp/srpt/ib_srpt.c:2936: error: =E2=80=98CH_RELE=
ASING=E2=80=99 undeclared (first use in this function)
> > drivers/infiniband/ulp/srpt/ib_srpt.c:2936: error: (Each undeclared=
 identifier is reported only once
> > drivers/infiniband/ulp/srpt/ib_srpt.c:2936: error: for each functio=
n it appears in.)
> >
> > I'm assuming this needs to be changed to CH_DRAINING instead, yes..=
?
>=20
> Yes. The tests I ran were with that change included - I'm not sure ho=
w
> it's possible that that change was not included in the patch I posted=
=2E
>=20

Thanks for verifying this one.  Pushed into lio-core and will squash
into a single patch for target-pending.

Thanks Bart!

--nab


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
