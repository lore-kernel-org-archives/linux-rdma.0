From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: dedicated list for rdma userspace programming
Date: Mon, 24 Apr 2017 21:13:51 +0300
Message-ID: <20170424181351.GM14088@mtr-leonro.local>
References: <CACaajQu1jvvCYJk82_oGOGH7jbjXzbkw_YoggqvW7TZhXj4VBw@mail.gmail.com>
 <20170424104259.GH14088@mtr-leonro.local>
 <CACaajQu9y2HawOjeuwjYSHeFmYfhWreQORB5_61nPiEspoQ2JA@mail.gmail.com>
 <20170424114733.GI14088@mtr-leonro.local>
 <CACaajQs=04be-QDFgqjXj4u=qp4wC6KFU8y5g=kR7vkV0QkbdQ@mail.gmail.com>
 <20170424123413.GJ14088@mtr-leonro.local>
 <CACaajQueUDeiqb0jyPPT-OFL=sgEn=apffC2SpLFZR2pbi04fg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="SqJDPA0lBYgnDFWV"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CACaajQueUDeiqb0jyPPT-OFL=sgEn=apffC2SpLFZR2pbi04fg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vasiliy Tolstov <v.tolstov-+9FY0jupvH6HXe+LvDLADg@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--SqJDPA0lBYgnDFWV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Apr 24, 2017 at 03:45:26PM +0300, Vasiliy Tolstov wrote:
> 2017-04-24 15:34 GMT+03:00 Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>:
> >> >> And how much work needs to be done to get this work upstream? (1
> >> >> month, 6 months, years...) ?
> >> >
> >> > At least one kernel cycle, and after transition read/write will be
> >> > obsolete and will be dropped.
> >> >
> >>
> >> So 4.12-4.13 ?
> >
> > 4.12 is almost closed. We are in rc8 now and merge window will be next
> > week, so it will be 4.13-4.14 (optimistic).
> >
>
> Fine. So older interfaces will be deprecated and removed in next few
> cycles. I think i can now create something that used old api and do
> transition later (i'm use fedora)

Yes, conversion should be possible, Matan and Jason invest a lot of time
and effort to be sure that conversion will be as minimal as possible.

>
> >>
> >> >> If i want to try working with uverbs without C librarary, where i can
> >> >> find some info about format of messages reader and writed to uverbs
> >> >> device?
> >> >
> >> > Did you see Documentation/infiniband/user_verbs.txt?
> >>
> >>
> >> https://www.kernel.org/doc/Documentation/infiniband/user_verbs.txt as
> >> i see this nothing says about format of data writed/readed...
> >>
> >
> > See in include/uapi/rdma/ib_user_verbs.h, User fills struct from that
> > file, and kernel performs copy_from_user to extract the data. That's
> > all.
>
> Thanks! If i need to establish communication between two nodes and
> send/recv data (and get notification that data can be readed) does
> this file  enough to do that?

Yes, if performance is not critical to you.
Otherwise, the best solution will be to take a look on implementation
of data transfer (various post_send functions) in rdma-core library.

> (i'm plan to try create plain go binding, now only for fun, create
> generator for this C struct/enums to plain go types)


>
>
> --
> Vasiliy Tolstov,
> e-mail: v.tolstov-+9FY0jupvH6HXe+LvDLADg@public.gmane.org

--SqJDPA0lBYgnDFWV
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlj+QF8ACgkQ5GN7iDZy
WKdDbBAAndlhjlxcX7natOakfnLUwsvJyQp4tasuKd5ZS6Jk49X9wwBoyKEP8cIw
LkAm3s1G1WmLW9fis4QZ2mptA53SZpocq9/Lp5aSeKzvBGkz4/S5d6YWKtuWnxma
uRS341zmehbR7K2n011eVCkkXXXf8mCZA7sE5+sRzF65zxw0tSQoHKpurhde0YTe
mnX05ve9NxVuRB6U3wToFIgEwuZN13/fMZwgpTceQIf1D2p2Z0J1zNKVemVhgb9x
hH374DV9AuVWQKe9t8L75Ze9i/ZYFnh009hmEtFsKsPbnj9XEghlCam5KES9Bc0M
lNECLkcjGb0680NVRjfhnSrz4klTUOW0w4foiPtUMke/sOMc8pJ/r2pvuQq6vnT1
nCrYHaGnl5GHtUOwuM0DiyfQy7bSWT5nKuULePrNfIDYJBGeBHVh6FF6IpqhVs/2
vuS1AsKzr1wBpto1mZ09cB083gSeGR6bINeUFOs7Ga5RfBDTX3isBk+XhxChbJpO
Frla+QbytYOiC/fGoKLldLqOxE1EfxPXxviJLscezLvcVKMyyzm3v914QpN1dvZZ
2u46m3egxNbJVYB2cjnoCucRZ3Tuakj1D9aNLdwnwAWcRJuJDs9nWJaxht6jrfy/
j9SYCw4ktC8gsDRnXlfQaiVcZ9B7uxqtvR0qZlc4dsSce9JHyY8=
=pRIA
-----END PGP SIGNATURE-----

--SqJDPA0lBYgnDFWV--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
