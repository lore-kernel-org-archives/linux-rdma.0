From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: Further thoughts on uAPI
Date: Tue, 26 Apr 2016 12:38:00 -0400
Message-ID: <571F9968.3080501@redhat.com>
References: <20160420012526.GA25508@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A82373AB044043@ORSMSX109.amr.corp.intel.com>
 <AM3PR05MB141161876D5CA05B1993D20CB1610@AM3PR05MB1411.eurprd05.prod.outlook.com>
 <571F78F9.8010401@redhat.com> <20160426145813.GB24104@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="ABIeiM8EoqX2ehJaVe4npp19f40mq8HfK"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160426145813.GB24104-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, OFVWG <ofvwg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--ABIeiM8EoqX2ehJaVe4npp19f40mq8HfK
Content-Type: multipart/mixed; boundary="pCfJ82c7LpU5CtHqXt9HMwIX0f1AoFLTu"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>,
 OFVWG <ofvwg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>,
 "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Message-ID: <571F9968.3080501-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: Further thoughts on uAPI
References: <20160420012526.GA25508-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
 <1828884A29C6694DAF28B7E6B8A82373AB044043-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
 <AM3PR05MB141161876D5CA05B1993D20CB1610-LOZWmgKjnYgmsg45OnKo/9qRiQSDpxhJvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
 <571F78F9.8010401-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> <20160426145813.GB24104-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
In-Reply-To: <20160426145813.GB24104-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>

--pCfJ82c7LpU5CtHqXt9HMwIX0f1AoFLTu
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 4/26/2016 10:58 AM, Jason Gunthorpe wrote:
> On Tue, Apr 26, 2016 at 10:19:37AM -0400, Doug Ledford wrote:
>> For certain operations that have lots of optional items (work requests=

>> for one, work completions for another)
>=20
> FWIW, I think we had a general consensus to take a different approach.
>=20
> Basically, the 'common' uAPI does not care about micro-performance.
>=20
> Drivers have to implement hardware-specific driver calls to micro-optim=
ize
> their own high speed paths, and that would be done specifically with a
> single hardware in mind.
>=20
> This is already done by the majority of drivers for wc/wr processing
> (IIRC, only qib calls to the kernel for this)
>=20
> If we do provide a common wr/wc API then it can just be designed
> inefficiently around the netlink attribute architecture, uncaring
> about performance because nothing should use it. I'd prefer not to
> implement it at all...

We're talking about two different things.  I had the actual user space
API on my mind when I wrote what I wrote (aka, libibverbs).  If we are
going to talk about the verbs 2.0 kernel interface, then it makes sense
to me to keep the user space API firmly in mind too.  Although it would
be great if the user space verbs never changed a bit, that isn't
entirely possible.  The timestamp changes that are still waiting are an
example.  Currently, I'm not real happy with how the extension mechanism
in libibverbs has played out.  The intent was good, the reality is
clunky IMO.

> This same basic idea flows over to other parts, eg if a driver has
> special support for a specific work load (say fast creation of IB UD
> AHs) then it can have a high speed driver-specific call to do that
> work completely micro-optimized using data formed *exactly* the way
> the hardware needs.
>=20
>> base struct plus the length of all optional structs, and the order of
>> the optional structs matches their bit order from lowest to highest in=

>> the magic element.  It's not quite as free form as the patches for
>> timestamp support were, but still allows the structs some flexibility =
in
>> what is included and what isn't.
>=20
> Mellanox has a patch series that tries to do exactly this for the wc
> in libibverbs - it is quite ugly, and the the benchmarks showed worse
> performance compared to the current technique.

Right, but it completely rewrote the struct from scratch for each WC.
That's different than what I posted, which was more along the lines of
functional groupings.  It reduces the number of conditionals while still
reducing the overall struct size for anything other than "we have every
option turned on" case.

There are only a few options for how to expose these things to user
space (using the example I gave as a further talking point):

1) Grow struct ibv_wc for every new option.  This totally prevents any
ability to either remove items or reorder items in this struct.  It also
bloats the size of the user visible struct for the common case.

2) Do away with direct variable access and go to indirect variable
access via accessor functions.  This will work, and has the advantage
that accessor functions can work directly with the hardware specific
structs, thereby eliminating a copy from the hardware struct to the user
visible API struct.  It has the disadvantage that every item you wish to
access will require an indirect function call from a table.

3) Do like the Mellanox patches did and completely rewrite the
completion struct for each completion.  Changing ordering and everything
else based on what's there.  As you pointed out, this had performance
issues.

4) What I wrote, which was intended to be a compromise between #1 and #3
to hopefully help with performance issues.

> For the reasons above I would prefer to stick entirely with the
> netlink attribute format or very similar as the main mechanism.

I don't intend to expose anything netlink to libibverbs users ;-)

Like I said, we're talking about different things.



--pCfJ82c7LpU5CtHqXt9HMwIX0f1AoFLTu--

--ABIeiM8EoqX2ehJaVe4npp19f40mq8HfK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXH5loAAoJELgmozMOVy/diBAQAIl+Lz3hiE8ARSxrSfTESluM
vkrnHUiStvbIbVX7arv0zl9PKH3m2N3GtRzRhAEnyt7alDf70yRr3c0RJQi9M56J
WOhZvxAZDdYifn5tcbhG4N+kk+VG4oVjAIo/z8EzO2iyHIq+mYkYr/AmpWtCew1U
7PqKTgBlfr3sOQ1aRYFGqdrdjOsbv2Av1ybjbY4Xx5QYkW25bzjs5/AsaeSSuo/v
haBlEBmaJ8U3vZvmRxo0WoSO0zR5qD8Kpg33usAr6359BOTrcXIETEgTOkyLPQfr
jTTsJjniWdAQadRCWAJiUYxBf/q6dxagJwPhvI8Ps18oDqt3rJNKi81FfeX8q+2K
gkGgHGA8YOjWjC4OSgrZdHd6Iyt5khonlVLgJlLkoFTygF0JlEbfr8Hw9lNJ9H1+
yof4iaGMqIU54Gl2aqibuVLWhfVAbs8QvKQFSKxzhqogRBmnSmC04EzXkdUvvRoi
UZw3w4nG9U2KpYd/4M6V/U3WG2ik9bmtb2A0cHZKeTSoLkfM6x/zgmoG7zIKa5Az
xOzKozJCqMdKVMylMTvEJT4c2bfW1ZQ0R+ho5fhK8goz2HhSJfrzpFDPxRqUytSt
8Yzy0QFvoSMLOOOCbGDI7XUs+Z+nBVWGqW7bBMUB/F2m6NgQojlY3spWDfVz/g7K
343MFUJPyU9CMt3OZPeu
=enam
-----END PGP SIGNATURE-----

--ABIeiM8EoqX2ehJaVe4npp19f40mq8HfK--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
