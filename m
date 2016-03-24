From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PULL REQUEST] Please pull rdma.git
Date: Thu, 24 Mar 2016 11:23:59 -0400
Message-ID: <56F4068F.2070608@redhat.com>
References: <56F1B00F.7010406@redhat.com>
 <CAJ3xEMhG0x_+DAAY+Cv0OAnW=2VmMuHZUv8DOP_YCkNHfSjX9A@mail.gmail.com>
 <56F1F579.3080403@redhat.com>
 <CAJ3xEMhu7pKONneEAMDhJUtiz2nqnibynHMWe8vmgPCy+7DH5A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="Ks2MPX4qtIGoj1UxfjmpQUCKfawtfcnFB"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJ3xEMhu7pKONneEAMDhJUtiz2nqnibynHMWe8vmgPCy+7DH5A-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Ks2MPX4qtIGoj1UxfjmpQUCKfawtfcnFB
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 03/23/2016 06:37 PM, Or Gerlitz wrote:
> On Wed, Mar 23, 2016 at 3:46 AM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wro=
te:
>> On 3/22/2016 6:23 PM, Or Gerlitz wrote:
>>> On Tue, Mar 22, 2016 at 10:50 PM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>=20
>>>> Mitko Haralanov (41):
>>> [...]
>>>>       IB/hfi1: Re-factor MMU notification code
>>>>       IB/hfi1: Allow MMU function execution in IRQ context
>>>>       IB/hfi1: Prevent NULL pointer dereference
>>>>       IB/hfi1: Allow remove MMU callbacks to free nodes
>>>>       IB/hfi1: Remove the use of add/remove RB function pointers
>>>>       IB/hfi1: Notify remove MMU/RB callback of calling context
>>>>       IB/hfi1: Use interval RB trees
>>>>       IB/hfi1: Add MMU tracing
>>>>       IB/hfi1: Remove compare callback
>>>>       IB/hfi1: Add filter callback
>>>>       IB/hfi1: Adjust last address values for intervals
>>>>       IB/hfi1: Implement SDMA-side buffer caching
>>>>       IB/hfi1: Add pin query function
>>>>       IB/hfi1: Specify mm when releasing pages
>>>>       IB/hfi1: Switch to using the pin query function
>>>>       IB/hfi1: Add SDMA cache eviction algorithm
>=20
>>> Doug, this series is under review and a reviewer (me...) have posted
>>> comments claiming that such pin down cache doesn't belong to kernel
>>> but rather to be part of a user-space library [1]
>=20
>>> This comment still hold even though the cache is serving a proprietar=
y
>>> (non verbs) user-space code b/c it claims that code X doesn't belong
>>> to the kernel and we need not load into the kernel what doesn't belon=
g
>>> there.
>=20
>>> Could you please comment why not let the discussion converge and/or
>>> hear your maintainer opinion on the matter before this is pushed up t=
o Linus?
>=20
>>> [1] http://marc.info/?t=3D145746462200001&r=3D1&w=3D2
>=20
>> You made your arguments, which I thought were nebulous in the first
>> place ("does not belong in the kernel" is not a well defined objection=
,
>> it's like saying "I don't like that", you would need a more concise
>> objection to carry stronger weight).
>=20
> Doug, by all means my review was not in a "you should do X, period" or
> "Y doesn't belong to the kernel, bump", take 5m and see:

[ snip ]

I read it all the first time Or.  I don't need to read it again.

>> Their response to your argument
>> was that putting it in the kernel saves multiple context switches per
>> memory region in the cache.  This was a sufficient answer IMO (context=

>> switches are expensive and on 100GBit hardware, multiple context
>> switches that aren't needed is positively huge).
>=20
> So it tool quiet a lot of time and effort to have Denny make these
> statements which are still not backed up by any published performance
> data.

Yes, so?  Do we have to have published performance numbers for every
patch?  Especially ones that intuitively sound correct?  Because I don't
see people putting those requirements on Mellanox, so I'm curious why
you think that level of burden should be placed on Intel?

> Any reason we can't hear you speaking in real time over a reviewing
> thread, and have a fair chance to convince you that things are
> actually the other way around vs. your position, but rather get your
> opinion in the form of blank pulling of patches?

You've already made your arguments.  I listened, I evaluated, I made my
decision, I moved forward.  I had (and still have) too much work to do
this merge cycle to belabor things just because you want to prevent
Intel from architecting their driver they way they want.  I would be
more inclined to listen if this wasn't private to their driver, but it
is, and you are trying to push in on their design with your own
requirements that bear no relation to the core IB code or your company's
drivers, and your requirement is one that Intel has already stated will
have a negative impact on their performance.

Intel has worked their ass off in the name of your review requests so
far.  The entire rdmavt code base was at your request.  And while
Mellanox originally promised to make their soft-rxe driver use the
rdmavt code base too, that appears to have been completely dropped at
this point.  So from my position, Intel lived up to their requirements
in regards to rdmavt, but Mellanox has not and does not appear to intend =
to.

So, no Or, when it comes to you being able to block Intel's work on
their hfi1 driver, you are now on a short leash.  If you make obviously
correct review comments, I'll listen.  If you make dubious review
comments, but third parties back them up, again I'll listen.  But if you
make a dubious comment, and Intel has valid reasoning for how things
are, then the burden of disproving Intel will fall on you.  At least for
a while.

> Should someone be Al
> V and/or Linus T to make comments over this list which will get you to
> speak up and have a conversation/discussion?

I have conversations on this list on a regular basis Or.  I just didn't
argue a point you wanted me to argue.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--Ks2MPX4qtIGoj1UxfjmpQUCKfawtfcnFB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJW9AaPAAoJELgmozMOVy/ds2gQAIg4yh5PAUFGPYn9XK8/xMAs
uhT9mjvEqE3gneyAxZ9gPB8hdmYSWoUXUPM0xotwyyuk30Us0lVjLIme/JNEyKew
bdxnfRfeFS7oX5DBmg4JgOPDRwlDeQmXMd9eHPx++kATI8XekqRRw7lO3DIGB+J+
QwYP48iMIVh/isNGmhHBAaFx7deXbtwRwqfPzdLhDx5TUVyxKWuomP3A5k6hRMfu
Ry4javIeJqt9Gf9eosaGTEqt1WlHtIUUGx6vz9IvYnPAZtKzgP7lI5slDIMtYyKb
KgJ4zxuoGRkZfBChJAMC7Lz1VugQMM1Tqd8QfVf6o1IO4kQl64bsDZRcURo+PQ+E
dMPUDxm88RZbR+g4GR1zxHnc3xRbZcQqUTHf/kRmj5fmLAM95QLBM0tLhlkOMLqz
6zSGzp8a7fwWL6LEhcI67MHN0ysB3gZaipAlY3v4NodMlvxpD4ogy1PkZN46zmxH
0sFVRVebzevXzH+oxRIL758S04McUACJHzhHaGcaTs9mZL9QubCHfGb0QS1oAnnz
EPD3QKIXXpmBRb7ppPFdGBIxRiygg5dv3SL/r2r1hQQjHtNKm6PPHxHrhtzTx2gw
pFV5ZTgHuy57K5EH9JCyQYRT+ZIV1Nvf3AQUzOe2mmi+x1JLV1RdyiPoyuWUb14E
lVhQtNrnmBq5qtP5k5Q/
=/0Gy
-----END PGP SIGNATURE-----

--Ks2MPX4qtIGoj1UxfjmpQUCKfawtfcnFB--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
