From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH RFC 0/3] Support standard SRIOV configuration for IB VFs
Date: Tue, 26 May 2015 12:53:54 -0400
Message-ID: <1432659234.28905.152.camel@redhat.com>
References: <1432225447-6536-1-git-send-email-ogerlitz@mellanox.com>
	 <1432226406.28905.22.camel@redhat.com>
	 <CAJ3xEMjzpqnQuA=0HQaN8noVq04d9BkVvEWGY7Lq5ZntVTKm4w@mail.gmail.com>
	 <1432242708.28905.73.camel@redhat.com>
	 <CAJ3xEMh3BaxJzCu9mV9m6ZMwgrDaO2UvTyS1i=DEPq9nuLX3oA@mail.gmail.com>
	 <20150525211433.GA9186@obsidianresearch.com>
	 <CAJ3xEMhG2W6WzxC4Kc2CFmdMwTRUF5ppBgcDZ6SMA=kgJowUpQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-pvMjOrnmn2KMPIjSrnkj"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJ3xEMhG2W6WzxC4Kc2CFmdMwTRUF5ppBgcDZ6SMA=kgJowUpQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-pvMjOrnmn2KMPIjSrnkj
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2015-05-26 at 00:50 +0300, Or Gerlitz wrote:
> On Tue, May 26, 2015 at 12:14 AM, Jason Gunthorpe
> <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
> > On Mon, May 25, 2015 at 11:04:41PM +0300, Or Gerlitz wrote:
> >
> >> OK, so rewinding a bit, the IB VF [1] identity is their 8 bytes port
> >> GUID, and as Jason noted the user/kernel API allows to deliver up to
> >> 32 bytes between user and kernel under the set_vf_mac flow
> >> (do_setvfinfo() in net/core/rtnetlink.c). Trying it out through
> >> **non-modified** ip tool and net/core/rtnetlink.c things just work -
> >> I can set eight bytes value to be the virtual port GUID :
> >
> > Was I not perfectly clear? You have to use the 20 byte LLADDR format he=
re:
> >
> >> # ip link set dev ib0 vf 1 mac aa:bb:cc:dd:ee:ff:11:22
>=20
> Jason,
>=20
> I am aiming to provision the VF IB end-node address =3D=3D port GUID (vGU=
ID)
> in the same manner that VF Eth end-node address is their MAC, not
> more, not less.
>=20
> 20 bytes are the lladdr of IPoIB devices which isn't the VF IB
> end-node address but
> rather made of flags (1B) + QPN (3B) + subnet prefix (8B) + VF GUID --
> way more then
> the virtualization system care or can provision.
>=20
> >>                 Port GUID: 0x2211ffeeddccbbaa
>=20
> > The byte order got screwed up someplace.
>=20
> thx, will fix

Or, while you are working on this, please attempt setting a larger than
12byte vlan->pkey.  The actual ndo_ for setting a vlan uses a u16, so
it's possible that just like the MAC setting, our pkey setting might
work unaltered too.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD


--=-pvMjOrnmn2KMPIjSrnkj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJVZKUiAAoJELgmozMOVy/dNHgP/2lAYQ3pLs1hhrch/A8caQvl
hZX5TEvLMbJkmluwQXiaFqTOBBeHYxE0b6ovYwT5wthm6PL12P0wPcQmf359J0ef
hLZ6O3+IoSQTMULTXOej1kvwaWpvYz/ZibGhlSAthqC8Mr0aQhT17D/RCoSqJysx
BExKr7n57qp/ScZ9cSLYRnJNaIzMqHwF3zT1q+dLkiWpkcPb6o2dlmTOFwjt0KPe
UgZGhMVc6r9ra0ReT/En4qPAoYoLltv2s/q233vY1iLFxCi/mu55LBYgxu3pKPwm
urXxWJNvJuw3aF8j6cp8YF5/k5C+SONQ+FIgkhOAGPdkAJl3t75ycdNpwTRDbQ+4
Zx+FEBcXA3I1trKYSrKCLQ+qvFEkX2ozJXyKbQGj+Owut/IRDFWS3IyexTj/PHKO
+HEf0Huo5Dxn3CD/f4j9YfQPw/VdyaH7ctoC9k66j2FjmFHkv3MhZ0aR/nKNqNdN
PDRh+BEtdONix0Wc5i/nhaZXNlKloOIbpXBHqFIrAo9TvocaEbF4lSuz0MyGgXkA
+1bzKF1jvXPggFNvqvPq6IR6pQvDwOOJTrgRleLd1IygGaGkgbvlGLlcs+x8cP9+
C1WMlPe+A/GQIetZghProMMasLnH9omseboAq2gcLaTpDHX/rNuC9a7epPOjHP1V
td+iKr/dR22rxbphwaPw
=0vnv
-----END PGP SIGNATURE-----

--=-pvMjOrnmn2KMPIjSrnkj--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
