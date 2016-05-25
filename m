From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC] rdma/uverbs: Sketch for an ioctl framework
Date: Wed, 25 May 2016 14:06:38 -0400
Message-ID: <5745E9AE.6020700@redhat.com>
References: <1828884A29C6694DAF28B7E6B8A82373AB04FB7F@ORSMSX109.amr.corp.intel.com>
 <HE1PR05MB141819B27F9AAA360DCB420FB14F0@HE1PR05MB1418.eurprd05.prod.outlook.com>
 <11b6d9c1-0b20-f929-c896-ca084fe18192@redhat.com>
 <20160524214137.GA6760@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="VG52hxfKjUSqxSaVAoo0gVLfc9EOAgl44"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160524214137.GA6760-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Hefty Sean <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--VG52hxfKjUSqxSaVAoo0gVLfc9EOAgl44
Content-Type: multipart/mixed; boundary="c9EOoIJuBlU5SMLAKSvOHdbMaox8Do0v4"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Hefty Sean <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>,
 "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Message-ID: <5745E9AE.6020700-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC] rdma/uverbs: Sketch for an ioctl framework
References: <1828884A29C6694DAF28B7E6B8A82373AB04FB7F-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
 <HE1PR05MB141819B27F9AAA360DCB420FB14F0-eBadYZ65MZ87O8BmmlM1zNqRiQSDpxhJvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
 <11b6d9c1-0b20-f929-c896-ca084fe18192-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
 <20160524214137.GA6760-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
In-Reply-To: <20160524214137.GA6760-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>

--c9EOoIJuBlU5SMLAKSvOHdbMaox8Do0v4
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 5/24/2016 5:41 PM, Jason Gunthorpe wrote:
> On Tue, May 24, 2016 at 01:57:54PM -0400, Doug Ledford wrote:
>=20
>> Sean's proposal does away with the rigid nature of the current verbs 1=
=2E0
>> API and makes it much more flexible on a per-driver basis.  This doesn=
't
>> address the end user API issues, but it at least cleans up the user
>> driver <-> kernel driver API so that one vendor's driver is not forced=

>> to carry around all the baggage needed for every other vendor's driver=
s.
>=20
> I'm not sure what you are reading, but to me both proposals look very
> similar. They are both based on the generic object/action/method sort
> of model I talked about in an earlier thread.

They are similar in initial expression, but not in intent.  Sean's is
not concerned about preserving struct ib_qp (just as an example) as it
stands, while Mellanox's patchset is all about passing around the same
objects via a different interface.  Even though they encode objects in
netlink attributes, they are still expected to be the same basic objects
we use today (and this is how they minimize the driver impact).

> The main differences seem to boil down to the data marshalling and the
> dispatching style for the kernel side..

Data marshalling in Sean's case also entails data content changes with a
modest reorganization of what it entails for an item to be a core item
(Sean can correct me if I'm wrong here).

> Sean hasn't explored how to encode the actual method arguments, while
> Mellanox's has a fairly well developed scheme with the netlink
> encoding and sgl result list thingy.

You are correct that Sean's patch has very little in the way of argument
validation.  However, I'm not entirely sure that Sean intended the core
to do that sort of validation, he may have intended the drivers to do
their own on the passed through data.  The Mellanox patches do so, but
at the expense of netlink which many people on this list find painful to
read.

>> Under that model, each vendor only carries what they need.  It would
>> then be libibverbs responsibility to take that driver specific data
>> and
>=20
> Either patchset could go in this direction. This is a basic question
> we need to decide on.

And this is my central point, that I tried to make in my previous email:

There are multiple trains of thought on where this will end up, and
simply switching from write to ioctl is only part of the overall big
picture.  There should only be one API break in this entire process, so
we need to make sure that any other possible API breakers are included
in the initial change to the ioctl interface.

> I'm starting to think the basic thrust of the Mellanox series (provide
> an easy compatability with our userspace) is a sane approach. The
> other options look like far too much work to use as a starting point.

I could not care less about this argument.  When you have to break an
API, you do what you have to do to do the job right.  Doing things the
right way may turn out to be the easy way, but the argument would be
because it's the right thing to do, not the easy thing to do.

> That doesn't mean we can't decide to move in a direct-only direction -
> the uAPI needs to have enough extension points to allow for that. Such
> work should happen incrementally, and mainly target new uAPIs.

This is arguable.  If we know we want to go basically direct only in the
future, then preserving the existing layer in the ioctl API eventually
becomes a burden.  It would be better to go direct only from the
beginning.  This needs to be settled.

>> and not also the user visible libibverbs API at the same time.  If all=

>> we want to talk about is verbs 1.0 over ioctl, then yes, we can do tha=
t.
>>  But not if we truly want to discuss a verbs 2.0 API.  And I have yet =
to
>> gather from the discussions I hear from people that we are in fact
>> decided on pursuing a verbs 1.0 over ioctl API instead of considering =
a
>> verbs 2.0 API.
>=20
> You are the only person I've heard who wants to restructure the
> libibverbs interface at the same time..

That's not entirely true.  My vision in my head for how we might start
altering the libibverbs interface is already being done (although with a
slightly different implementation than I had in mind) in the timestamp
patches.  What I want to see us do in libibverbs is to make extensions
start following a new pattern instead of the one they have traditionally
followed.

But the reason I bring this up is because we need to be thinking of the
end to end data transfers when we are thinking about the API break and
any changes we might make.  I'm thinking about possible changes in
libibverbs, Sean is thinking about libfabrics/psm2/hfi1.

If we end up just doing a behind the scenes switch from write to ioctl
with no changing of data structures or command flow or anything else,
then we can ignore the end to end picture because it won't change
significantly.  But if we do other things too, then I want other people
to keep things like this in mind, it's fundamental to good design in a
case like this.


--c9EOoIJuBlU5SMLAKSvOHdbMaox8Do0v4--

--VG52hxfKjUSqxSaVAoo0gVLfc9EOAgl44
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXRemuAAoJELgmozMOVy/d/2MP/Ar+hx6m/TVAcOUM4pHFtKVa
9hMaIlv/a/Vutl+H0BdwGHUWVoduGqvw0nortKKX5kCVtdTaaMQkptTBKVsVMGjF
x5+nlvwtJK5keVVrNri5bDqnjt5gDAJcMvnSWGLcyWdZeqkkxCtZWIStFEX/JINj
jSqw+e1Oo7ynWjJMTVMhVTpFD2ZaNG0pepgV4g0TP0Xn1x8mZ0wc20qIj1+S6h7S
ychlDp5Wts1mj4g3Fy3R6V8joP35xRvBqZeF0HBT+664SATV64DkdFifZ3dg5hEf
FtLIhbyBmY4KFYGl6BgPPdRcwlj0kpcNAOftp+l9diUFr9qeQQL3d27uZheaqRlr
/puVvJTGNrqrNqsHuVJuDQh2sS3P1DG/cdS5W+A7KuPnoyTa1+XiV4e+wp9tQqzg
aIEF6+8C8nS2p9uQSniBkqzJwkUlSvr8mbxfJIwE9nI7Sk+YnVT7XmuwPm7y78PL
V9p3VqHmoIjW9D5wSt+Q/ZTnr+d91cibrWUjnP6FmdjzbaHR1tmO7riWLYnHyzBt
yIb7IoJBiS3oyGXByumGY+Y07l/ORmD1ZlcEKdy5kT3/C0NcW7ZBO5MIC3vmn9Yc
YhTB20P/VZ2Erg8rHp14foYh4f7hiBqIOWM9Ib+3XkEVIJ0o8d1au8EBK/rl7Zhl
0U8V8LL0C1MwmmdKuWK/
=BNdC
-----END PGP SIGNATURE-----

--VG52hxfKjUSqxSaVAoo0gVLfc9EOAgl44--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
