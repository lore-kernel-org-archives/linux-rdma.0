From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] infiniband: hw: hfi1: constify mmu_notifier_ops structure
Date: Mon, 12 Dec 2016 15:21:06 -0500
Message-ID: <82309d76-7597-bb08-fd38-6b7771f82129@redhat.com>
References: <1479548868-13563-1-git-send-email-bhumirks@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="QhJfIp08i5owhQo52Ffa8S2vvtbswIEXF"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1479548868-13563-1-git-send-email-bhumirks-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bhumika Goyal <bhumirks-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, julia.lawall-L2FTfq7BK8M@public.gmane.org, mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--QhJfIp08i5owhQo52Ffa8S2vvtbswIEXF
Content-Type: multipart/mixed; boundary="KJ30HCC9axDmqrRiQwhSeRrkCMUC6roIM";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Bhumika Goyal <bhumirks-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, julia.lawall-L2FTfq7BK8M@public.gmane.org,
 mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org,
 sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
 linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Message-ID: <82309d76-7597-bb08-fd38-6b7771f82129-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] infiniband: hw: hfi1: constify mmu_notifier_ops structure
References: <1479548868-13563-1-git-send-email-bhumirks-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
In-Reply-To: <1479548868-13563-1-git-send-email-bhumirks-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

--KJ30HCC9axDmqrRiQwhSeRrkCMUC6roIM
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 11/19/2016 4:47 AM, Bhumika Goyal wrote:
> Declare the structure mmu_notifier_ops as const as it is only stored in=

> the ops field of a mmu_notifier structure. The ops field is of type
> const struct mmu_notifier_ops *, so mmu_notifier_ops structures having
> this property can be declared as const.

Thanks, applied.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: 0E572FDD


--KJ30HCC9axDmqrRiQwhSeRrkCMUC6roIM--

--QhJfIp08i5owhQo52Ffa8S2vvtbswIEXF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJYTwayAAoJELgmozMOVy/dvbwP/R42lcsCzjYLZdzn2cjhuHiz
E9Uxry0NfmjX+9fju8hSWyMgF+RIY+2NKq/8wB7BE5gUquMc3eaaerrHOaq2A5k/
9nO7JE0gjHgT5fGsnF3d+iPQtDUpORu3GqHjnGLuLfhcFBcVIouLvg8v/pi6iRs6
fwjenlMk9xlfmGzhJFbc62OcUGWQ+4zbLZuBZqt8uOjtsTUwiiwiBBnQ1zS5a2Bz
FJKjDHWsXGLihbe2EbIMM6feWzbXYZHOOQq+Xmi/sB36LqUYhx4cDhsuBGck9c8r
2O4FsaTJpGc48ySPupHy99CpE5zzO6tlnD8aECME+QozTlHOWQ7K4tjRDGfdUSeJ
1/4FoIP802WlTaMIqe39jn3E4cYhri86gR/vv6EPa8uyW3gIhXC3dfDczoOCzX3M
Espr3k/3zK3bDJBtGwE/icxiJEgq3jXfCa1Cp1pF3n9K16c8B9ZTE1rYJY9GN+3h
YrJJHoukcieTqiVZOfGtlZxOxE/bvPMOd4mlTb4W6oM0ete598IBEAbK2smcnKL3
oeNyNBxZfHQqt+DvnLVbQrSNiym5vJSF6C4HpfCvTBUNHFEk9MlUeMWo+LiHUpHR
T3/jRG9lLLhZzVyuKKtoIiBjh+GBSeI0Lhm7PrQlzgoDvfW3iZjxrZn1wV9f2urt
BBZHUbgnQkfwa11mzjqJ
=nLfl
-----END PGP SIGNATURE-----

--QhJfIp08i5owhQo52Ffa8S2vvtbswIEXF--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
