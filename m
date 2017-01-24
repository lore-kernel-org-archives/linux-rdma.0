From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCHv2 1/1] IB/srp: fix invalid indirect_sg_entries parameter
 value
Date: Tue, 24 Jan 2017 11:32:52 -0500
Message-ID: <1485275572.43764.27.camel@redhat.com>
References: <1483538377-19379-1-git-send-email-maxg@mellanox.com>
         <1483538377-19379-2-git-send-email-maxg@mellanox.com>
         <1483542561.3048.13.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-pftTr6Y2RHK2Twn0eGfq"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1483542561.3048.13.camel-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, "maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: "israelr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <israelr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-pftTr6Y2RHK2Twn0eGfq
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2017-01-04 at 15:09 +0000, Bart Van Assche wrote:
> On Wed, 2017-01-04 at 15:59 +0200, Max Gurtovoy wrote:
> >=20
> > From: Israel Rukshin <israelr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> >=20
> > After setting indirect_sg_entries module_param to huge value (e.g
> > 500,000),
> > srp_alloc_req_data() fails to allocate indirect descriptors for the
> > request
> > ring (kmalloc fails). This commit enforces the maximum value of
> > indirect_sg_entries
> > to be SG_MAX_SEGMENTS as signified in module param description.
> >=20
> > Signed-off-by: Israel Rukshin <israelr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > Signed-off-by: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > ---
> > =C2=A0drivers/infiniband/ulp/srp/ib_srp.c | 6 ++++++
> > =C2=A01 file changed, 6 insertions(+)
> >=20
> > diff --git a/drivers/infiniband/ulp/srp/ib_srp.c
> > b/drivers/infiniband/ulp/srp/ib_srp.c
> > index 0f67cf9..79bf484 100644
> > --- a/drivers/infiniband/ulp/srp/ib_srp.c
> > +++ b/drivers/infiniband/ulp/srp/ib_srp.c
> > @@ -3699,6 +3699,12 @@ static int __init srp_init_module(void)
> > =C2=A0		indirect_sg_entries =3D cmd_sg_entries;
> > =C2=A0	}
> > =C2=A0
> > +	if (indirect_sg_entries > SG_MAX_SEGMENTS) {
> > +		pr_warn("Clamping indirect_sg_entries to %u\n",
> > +			SG_MAX_SEGMENTS);
> > +		indirect_sg_entries =3D SG_MAX_SEGMENTS;
> > +	}
> > +
> > =C2=A0	srp_remove_wq =3D create_workqueue("srp_remove");
> > =C2=A0	if (!srp_remove_wq) {
> > =C2=A0		ret =3D -ENOMEM;
>=20
> Thanks!
>=20
> Reviewed-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>

This patch is a fix patch and should have been tagged as such.
=C2=A0However, the proper tagging is complicated by the fact that the
SG_MAX_SEGMENTS was originally named SCSI_MAX_SG_CHAIN_SEGMENTS. =C2=A0The
fix applies all the way back to the first patch to enable SG segments
in the srp driver, but you will need a different patch for the kernels
prior to the rename. =C2=A0For this patch, I've added the following tags an=
d
applied the patch:

Fixes: 65e8617fba17 (scsi: rename SCSI_MAX_{SG, SG_CHAIN}_SEGMENTS)
Fixes: c07d424d6118 (IB/srp: add support for indirect tables that don't
fit in SRP_CMD)
Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org # 4.7+

Someone should write a patch for the earlier kernels and submit it
directly to stable@ with the patch flagged for application on kernels
from 2.6.39 to 4.6. =C2=A0The upstream hash for the fix to mainline is:

commit 0a475ef4226e305bdcffe12b401ca1eab06c4913
Author: Israel Rukshin <israelr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Date:=C2=A0=C2=A0=C2=A0Wed Jan 4 15:59:37 2017 +0200

=C2=A0=C2=A0=C2=A0=C2=A0IB/srp: fix invalid indirect_sg_entries parameter v=
alue

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
=C2=A0 =C2=A0 GPG KeyID: B826A3330E572FDD
=C2=A0 =C2=A0
Key fingerprint =3D AE6B 1BDA 122B 23B4 265B =C2=A01274 B826 A333 0E57 2FDD

--=-pftTr6Y2RHK2Twn0eGfq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJYh4G0AAoJELgmozMOVy/d+m0P/j8Hze8XnTJscPhkRI62oToh
92Cfd2/MwoxPlDjQEvT07SQS+HZON+2jd0qn5WdHozyX+PdDTsAnLZJS8zqmlszE
z0jbLganMv5PUW1MZhZrVqplrmvqve6niLU9AuVqR/wADqZZZsbr/s9FNOE4W/Ks
ZZmvCxdnGl+u3Kp7umd9pbmgOJexh6NOI3fURttOU+4vkcAHcR0J0xH76u1OxNse
7NiZgdY0XBUST8PxCweK2DuL7vv5cx/UvOJ7cj7ZC4SnUEkHSMDCRV6OwmQr6e2k
YS1/lzZyOHuLW+hweLUuNhZnJV+mGJ2Mk1py/MKFnKwhEn40yAyUy2w9ycBq/tIk
Z+BJJOQx6IrqjyU6ydwbxm993oT8vM3obw+hDVYCVc/5cUboK56u78aeR9Dd2a5s
HRKFAxKSeuqCxkCMjZw0tMQSWzeagnwmfPnBvO2qGZX0vN1y2TFI/R37izh8lCDK
toP2IDU70JyhPC74Zqae44PjdBxPBcmhS6x6Fmnh1MQGXQL1jLFt8mfwHUeOULun
iV6kUqAcAx1V7YtfG3VagrN86WC9fb8UUPDZaK4bMKjAFl5r9CVvxAJ1hZG0nIhW
BiZpEiFZyR3pq+6pZdyTtodDjYGvv2rLr4MW6iwizmsTWQHZ4ANDwNq/9Tkl2wPB
U2zNVX4Xnwa406VA9U2j
=rweS
-----END PGP SIGNATURE-----

--=-pftTr6Y2RHK2Twn0eGfq--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
