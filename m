From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-next 0/3] RSS related capabilities
Date: Sat, 1 Oct 2016 19:34:54 -0400
Message-ID: <2fa66a18-e0d8-e352-3526-022841c60b0a@redhat.com>
References: <1472372925-17660-1-git-send-email-leon@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="0Q9J6sd85C2c9D7Pf5mJN5LaTcixlEqLW"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1472372925-17660-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--0Q9J6sd85C2c9D7Pf5mJN5LaTcixlEqLW
Content-Type: multipart/mixed; boundary="vL7DF3e5fVDfRMAA2rt2aMl7546Wu5IHK";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Message-ID: <2fa66a18-e0d8-e352-3526-022841c60b0a-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-next 0/3] RSS related capabilities
References: <1472372925-17660-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
In-Reply-To: <1472372925-17660-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

--vL7DF3e5fVDfRMAA2rt2aMl7546Wu5IHK
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 8/28/2016 4:28 AM, Leon Romanovsky wrote:
> Hi Doug,
>=20
> This series exposes the RSS related capabilities to user space domain.
> It comes as supplementary part to previous series of RSS that was
> already accepted.
>=20
> The series includes three patches:
> Patch #1: Exposes the related properties from the IB core layer.
> Patch #2: The uverbs layer queries the related properties from the
>               core layer and exposes to user space area.
> Patch #3: Exposes the related capabilities from the mlx5 driver.
>=20
> Available in the "topic/rss_cap" topic branch of this git repo:
> git://git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma.git
>=20
> Or for browsing:
> https://git.kernel.org/cgit/linux/kernel/git/leon/linux-rdma.git/log/?h=
=3Dtopic/rss_cap

Series applied, thanks.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: 0E572FDD


--vL7DF3e5fVDfRMAA2rt2aMl7546Wu5IHK--

--0Q9J6sd85C2c9D7Pf5mJN5LaTcixlEqLW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJX8EgeAAoJELgmozMOVy/dGYIP/2Hh6boGyKZMmqkZnpBQwqpI
zUBlg+InoYGwaCqrJ6kIstz0cUA/A/KoEwKo3pNajTJsJqSRZdh7AX0WO/3MZZkM
e90gfZce7bH2pjrGQoHGAevE9+84VyAJnLGLmD46C47YEPLFwuTIgxSui4kg1c3x
0UYzN0fuvas4oEYvnXCV1hbhvA4mhjZnw0Swi1STrtWSmGKv1ST9LEregMj3YJ88
x9UFQyi1dChZ7DxejxYYJtzLvrY1Au6l3XGPeYhvqycv7biuAwkfCwUhgZ7IEs/o
aQlW5UGO+HNc6aNECRdWO4I/X3EcgBwcWT1yFCZYAAamYtmqGfpE4pmqeAvmP5eJ
BSYWcPdGI7CFS9L8qR4okKsRzCUSNtxGfNih++G5k3MrT0czRT2GPD54JVrACiyl
rGm2eidIqBDQ4VxqONCUUn6bmx9zGxkkXHj57nAa3UZO8FJOYWsmuyzXhTOCuS/1
IPQ6OVVobIk6tCRDBTbDdjcBsC9z4YivQ8mwgFU5gnlLiYvtt+VgwLB7jhZuqth5
lhcMfYMWHFnr2qvU4WB/oD6cgXLzu1tOAQzNSLInDQE3vmSdzZBdU/lQAzo/mVgU
ES1kUXqYUnRi/diAb+9F5Ydk+a/b54IjdA71buDSckDHDJ2TDX0ev173hULDO+da
50lqQTtv62mgn6DuVd/a
=3zHG
-----END PGP SIGNATURE-----

--0Q9J6sd85C2c9D7Pf5mJN5LaTcixlEqLW--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
