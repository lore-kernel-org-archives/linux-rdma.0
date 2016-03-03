From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-next 10/10] IB/core: Use GRH when the path hop-limit >
 0
Date: Thu, 3 Mar 2016 10:55:13 -0500
Message-ID: <56D85E61.90506@redhat.com>
References: <1456851143-138332-1-git-send-email-eli@mellanox.com>
 <1456851143-138332-11-git-send-email-eli@mellanox.com>
 <20160301173846.GB25176@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="A8Fpr6tvxmANRR4iJcpBHO97o8UKN3hLd"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160301173846.GB25176-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--A8Fpr6tvxmANRR4iJcpBHO97o8UKN3hLd
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 03/01/2016 12:38 PM, Jason Gunthorpe wrote:
> On Tue, Mar 01, 2016 at 06:52:23PM +0200, Eli Cohen wrote:
>> From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>>
>> According to IBTA spec v1.3 section 12.7.19, QPs should use GRH when
>> the path returned by the SA has hop-limit > 0. Currently, we do that
>> only for the > 1 case, fix that.
>>
>> Fixes: 6d969a471ba1 ('IB/sa: Add ib_init_ah_from_path()')
>> Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>=20
> Reviewed-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
>=20
> Jason
>=20

I've pulled patch 10/10 out of this series and applied it to my 4.5-rc
branch as it's a valid fix for code already in the kernel and need not
be part of this other patch series.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--A8Fpr6tvxmANRR4iJcpBHO97o8UKN3hLd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJW2F5hAAoJELgmozMOVy/dKekQAKIaAF0EVDserXfMLPg5D/ur
E8QwcHWxrOtL0Ttp40nIaj1Ov45XD+HLKhRspTI7/orlyh7FLFSHPqFQZ5iv0ow4
fpG6GPFG4bPs/w4KI87vC0zLYJ6qv2dTgCxSq7Ly9V66oGYRFv7noLr/xYBdRDQL
b6yt1MVJL5MuIEFDA69fB6KM22iGRXFJD9L/pjl5er5TL8pq4jJD42ii37PylDzA
y+kmdiv7mAsI4NR5PaT5S3crBwREJkDEtActUPsndSDRcs/FTmBNACu3W4ZJSb2M
KMR1scF0kePcQg1WqZwmJoSbv63wzFpkOJ0e2E5hapGezDFGRqF/rCZJiyUEoPj6
eUGKRlWIE4ny2XJkR5Rdpvfc9tLTpPYMPle3fiSGHKLxkkYVcG8EsYDOEKrJSZfq
x1ozaBBZkhflliMRjb/x9yCM2ZJ1rkmd+xJRucGAGBJ1r6rHn0jpNHuzUJ9nQO32
y5BIw/XVQumT/gXI6cQGDd8iNgzg24Oc1vWPalx5AySQaEGZIkKA097/SNExoWO2
Rau7VwGGlAAfKdyqdZ2FUTY6dsVTUuEj9Ptrfg2N/OEHtcQH4nU5curzs/Tt1QQc
2OeclyMHD5LTC/twNo9yN2QBCBcuolAANWWtSY2c/evMwGQyG3y2Rs9Oq5EMpDFC
Z4p4QaO8c3AhwYrm9Tmg
=XPG6
-----END PGP SIGNATURE-----

--A8Fpr6tvxmANRR4iJcpBHO97o8UKN3hLd--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
