From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/core: Make ib_dealloc_pd return void
Date: Fri, 14 Aug 2015 23:13:06 -0400
Message-ID: <5CF90FF7-6A0B-4C13-9EEC-DB2FDAC7148E@redhat.com>
References: <20150805203431.GB30271@obsidianresearch.com> <55CE9043.1030804@redhat.com> <20150815022747.GA30693@obsidianresearch.com>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2102\))
Content-Type: multipart/signed; boundary="Apple-Mail=_4456991B-AE39-42E5-942E-44783957D752"; protocol="application/pgp-signature"; micalg=pgp-sha512
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150815022747.GA30693-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Chien Yen <chien.yen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--Apple-Mail=_4456991B-AE39-42E5-942E-44783957D752
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=utf-8


> On Aug 14, 2015, at 10:27 PM, Jason Gunthorpe =
<jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
>=20
> On Fri, Aug 14, 2015 at 09:05:07PM -0400, Doug Ledford wrote:
>=20
>> I'm not sure I like this patch.  I have my concerns that this will
>> make debugging and catching problems more difficult.
> [..]
>> The change you put in here will make note of the driver that fails to
>> return a clean return, but the error happens elsewhere.
>=20
> Eh? I don't understand your comments.
>=20
> Nothing is lost, in your specific example instead of seeing the little
> one line printk from IPoIB, you'd get instead a full blown WARN_ON
> with a stack trace from here:
>=20
> +	   WARN_ON(atomic_read(&pd->usecnt));
>=20
> The stack trace still fingers IPoIB as the culprit, and a WARN_ON
> strongly motivates bug reports.

You=E2=80=99re right.  I wasn=E2=80=99t thinking about the stack trace, =
just that the searchable error messages in different ULPs goes away.  =
Absent that concern, the patch looks fine.

> If the above WARN_ON triggers it unconditionally represents a bug in
> the caller. There is no correct way to use the old error return.
>=20
>> It serves as a final check on the ULP, and to me that has value.
>=20
> Yes, which is why this patch extends that same basic check to all ~50
> call sites and every single ULP instead of only having it in only two
> places.
>=20
> Jason
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" =
in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

=E2=80=94
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
	GPG Key ID: 0E572FDD






--Apple-Mail=_4456991B-AE39-42E5-942E-44783957D752
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - https://gpgtools.org

iQIcBAEBCgAGBQJVzq5DAAoJELgmozMOVy/dsEUQAMVJL/7c36+4bWYgeUhkayXr
VnUBiRL/B/+EScCgdw76oE/9rgU5Um7iS2nRiYyBvj/PMYx95nlXBqMXxdxjd78g
Eb6Tfj8xCIUV88/MlFCZiFFXZwT22ryPj391mpJ7NAUtpNmMTe483RrIZvQyWb1t
8uN09tfLo3oZiZCt2xZqTJxIaLOjV28iapBhyvyMQ4MOMaNCtoxDfPRBpF1kD0au
VUZfWHoIDhFbBsGUO3MSHNKEiMeeaD9RrHjGx9ZEaNAZltS+yXWIhuFW2ksJ17TD
H8ZkPU/pwfszqXLKoImGjO0CBha/3FUwud8VcHxYtS9Fcmjq77VaCUnfkf7S4pDK
K+UVdJyuMshOJ/N4gv5eik409D77f3Kp1EyakG/DFUspmNfejF+bM2Zv2uSQXyfo
SDD32Ysa9kCz1goZRfzWs/UNTE+tW8YydRqM66oT7Ae/qwvUrI/5gFKlMjOg4DGJ
TlsnCkFLmXhah8Q5AgWhD8nw4TnaBa+BUfTXI3P8Celml8P79YLasNauBfYyhDvT
itprP10fxBIlsn2uusYngmBq88sRZk6kKv7FPqpyP7dqMEOr8WRgBZoYX2g7Mfvk
vr5vyQdGLb6Zc6H8+2nQXtA3qKFMXgltvjwSt3ikNi0jDgiNqf79ynERZ4KPJszE
bk0qrKK/obnb14j40sUl
=RIGv
-----END PGP SIGNATURE-----

--Apple-Mail=_4456991B-AE39-42E5-942E-44783957D752--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
