From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/1] IB/iSER-Target: Release connection resources
 properly when receiving RDMA_CM_EVENT_DEVICE_REMOVAL
Date: Tue, 02 Aug 2016 13:50:25 -0400
Message-ID: <1470160225.18081.24.camel@redhat.com>
References: <20160727191511.18122-1-rajur@chelsio.com>
	 <22568e6b-e764-bdd4-eec9-dc53a258b371@grimberg.me>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-YCgOG3wx25M4rW8IIgeK"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <22568e6b-e764-bdd4-eec9-dc53a258b371-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, Raju Rangoju <rajur-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--=-YCgOG3wx25M4rW8IIgeK
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2016-07-29 at 23:33 +0300, Sagi Grimberg wrote:
> >=20
> > When the low level driver exercises the hot unplug they would call
> > rdma_cm cma_remove_one which would fire DEVICE_REMOVAL event to all
> > cma
> > consumers. Now, if consumer doesn't make sure they destroy all IB
> > objects created on that IB device instance prior to finalizing all
> > processing of DEVICE_REMOVAL callback, rdma_cm will let the lld to
> > de-register with IB core and destroy the IB device instance. And if
> > the
> > consumer calls (say) ib_dereg_mr(), it will crash since that dev
> > object
> > is NULL.
>=20
> Yea... this used to work but sort of broke somewhere...
>=20
> Thanks Raju, the patch looks good,
>=20
> Acked-by: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
>=20
> Doug,
>=20
> Can you add a stable tag to this when picking it up?
>=C2=A0

I can add a stable tag, but it helps to know what versions of stable it
is expected to apply to.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD

--=-YCgOG3wx25M4rW8IIgeK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJXoN1hAAoJELgmozMOVy/dauoP/0NiSZm5gR2+/9gQs1VBXJPA
EAhiGolOdlpVPkXpIR8C9KvX+MVXLOM/AD2BIQV4pCvsFvoMdRQ4uwaauCI65dax
+/oFwD3B673B00IWgQ2uQCokIhOGTep6yW9QAeuib3ctQd7ESplWQMvtO8mJlU4H
fJKEyMdFaE1KBiaPn5B4MDF23ZRTJVWDdgNbxoLB0agFQOpsBX4TijpaImwR7pJ+
tgOorTAS7EW3SE+cvngF2zCgQ9QluAyzoYzjMDwBdp9S5kQ3Spi7IwPgKxvjJF6H
tt68yee6IJt5aGcS7XZXsyAYU8RPIHJb/aPeKZb1o3WAGSC2uAfCfG8hU6h1QMzd
r4C+GB1y35UlHE6NsV3UEZ1rMlj1acPFHDu3wYo4dKkge1p+0WeOaNiQbs4CNtxx
da7Pqt7pqd6qqbbsVmSJdy4n9khfNi9sgvMx/CkSdRCIJbvUqKPiXNSBKV9TmAQJ
pfwalMxv1TTFDkw48HdXroA4t8AQRztYazyyzt1wS77Djanm6JyWlptYpGyWCtm9
j5Qjto9t3sq2Osa1t85IPaoDQCS9AIE5lB5BMy3qLOrdpCJY8xa6YqqGBO9iN16b
EpR8UowqX/vbubCJgHI1JWnq3Nbwdc7o20Pzy/aRryCOZA5Ad8DJlkul/ldcQiNC
p72eJada95EIKxmWPHVc
=5IC6
-----END PGP SIGNATURE-----

--=-YCgOG3wx25M4rW8IIgeK--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
