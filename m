From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 0/3] Fix request completion holes
Date: Thu, 16 Nov 2017 10:58:13 -0500
Message-ID: <1510847893.8751.0.camel@redhat.com>
References: <20171108100616.26605-1-sagi@grimberg.me>
         <1510611044.3735.49.camel@redhat.com>
         <e89f72c6-12ce-c149-c81e-f3adb43a8e9e@grimberg.me>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-cLeZksz4cbWAYH/umXyj"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <e89f72c6-12ce-c149-c81e-f3adb43a8e9e-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Max Gurtuvoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-cLeZksz4cbWAYH/umXyj
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2017-11-16 at 17:39 +0200, Sagi Grimberg wrote:
> > Sagi, are you ready for me to take this series in?  It seemed like ther=
e
> > was a question as to whether you might want to try atomics instead of
> > spin locks, or do you want to stick with spinlocks?
>=20
> I still need a review for this, and I think we'll get it in through the
> nvme tree (via the block tree). Thanks.

Sorry, I didn't pay that close of attention to the files patched in each
one.  I just saw rdma in each subject line and assumed it was an rdma
destined patch series.  Looking closer I see it was really just Cc:ed to
linux-rdma for review.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
--=-cLeZksz4cbWAYH/umXyj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAloNtZUACgkQuCajMw5X
L93ftQ/+J/EBHN4Z2SXar6gdf5DIYJcvsSzhhsLKidTe6fR8fimscUPwhulirCPA
K0d9dHejQ5df7xZaBb8o0MHFLqux3FTGbxWY+9P0B1Q4rreWP99C7uTmMSljankh
HAppw0bhDqmP/upSU83gp4rY3dkI3TnLgT7y1/ZYL8+g2b+kODGk2c54wAHThsjs
ednEVjXrNmz+vS/vFsdzrDK/N22VWQJgDHDbg2ivTs7RrsbrozctRuNz3ZBEpdOt
YBB+geBT5KJsAy8pNpb5OICWRO8NyH8rvE+GdCF4kGiR11JP+nn/UVgGhhGWOGpU
kXzBwAogw6Gwo6hL7K5QopGOMclC5YINVNQ22WCXpDjSgCCYWi7Kzc0xDt/UfVvM
sI6FQOMMLmlZbKWecR6+JEF43MOgAySYjsAlqDSIPJVvNxVB/VMqV6FP/EF3yLGY
Bp211y+Chv2fPwIlUc95bPrvDyJWGnExAWQDgySpHHYjDelGHe8gbHt372EazYRt
6Ozi5ShH3dkqKu5aqPSrTO0Z9O05eBfsXwDZ1cKHPZCXi8zVNr6R+RDwGe5rF5UE
KyamIf1B9G9r7gepPzp4iwdzTK++xFyoPa869HU6mKHxwD25ClgBn8tr9QkCwhz/
CQUQZ5HqK2KPDAuFsdHjswWwe7IH1Iu5KkrQ9MsypW86b0oaXi4=
=ZwBS
-----END PGP SIGNATURE-----

--=-cLeZksz4cbWAYH/umXyj--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
