From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 00/15] IB/rxe patches for kernel v4.11
Date: Tue, 10 Jan 2017 13:06:07 -0500
Message-ID: <1484071567.2149.21.camel@redhat.com>
References: <1483353316.3592.14.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-135kV1ycSCIgn1gW+Dbz"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1483353316.3592.14.camel-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: "andrew.boyer-8PEkshWhKlo@public.gmane.org" <andrew.boyer-8PEkshWhKlo@public.gmane.org>, "monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-135kV1ycSCIgn1gW+Dbz
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2017-01-02 at 10:35 +0000, Bart Van Assche wrote:
> Hello Doug,
>=20
> The patches in this series are what I came up with by reviewing and
> testing
> the rdma_rxe driver. Please consider these patches for kernel v4.11.
>=C2=A0

Hi Bart,

This patch set, as a whole, did not make it to patchworks properly.
=C2=A0The patches themselves are in DOS file format and require a run of
dos2unix to fix them up, and patchworks didn't even grab 4 of the
patches out of the series. =C2=A0Can you please gather your Reviewed-by:
tags, then resubmit the series with Unix formatting? =C2=A0That should help
ensure they all get captured by patchworks.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
=C2=A0 =C2=A0 GPG KeyID: B826A3330E572FDD
=C2=A0 =C2=A0
Key fingerprint =3D AE6B 1BDA 122B 23B4 265B =C2=A01274 B826 A333 0E57 2FDD

--=-135kV1ycSCIgn1gW+Dbz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJYdSKPAAoJELgmozMOVy/dKiUQAK1lGLbGrcsKeNjoRRBKhUfM
T+pDQranTcHY8P2V6sLXX14MIYil5lDoRQnkXpyLViMygIJ1IiNBtz94Xw00sdhw
qwH44SE9k7PV8LZqlXE9/Yp+P02USOxzrjn5TOx6zTMBW/dxUEg1R44OrDN95tTl
dtSHx8shpppjCPtERdWilDn1Xha6emZZ40GJACMqd+hZMtmwXYH/byp17AR1iyyI
zn4o7eEnoU2xIA9NCsneECkhEZvH7aQyrHxl5qcm6JTYsZBG6QCSA4fDvV2SF7cj
wEoRQQqMCkYTv5qo2Yla6GypE6T9rX4pljEaAdYgkJ7Px9h88iadYvpPQcnWygv+
5pBlQQDsp3xMHLi2eYNzN3rdSbod/3ynFRj1DCr8dUkxUdJGWq7utp4ZHK76vqiF
tuO9Vv67YxKPtXEOHgYwdb4b/2i31iuYEA8fMuTydIQ8HQMX6SNLljy9A6aO9d83
VHDvgm0sgOnMB9N9KMpQGQB8t44KALwCIMtBTzMDbS/x76VHg5KNmPyieScPTnj5
L6jLrqya/TyrQnkEiZRGY/Fdj1GquDH7ntoI5K/rEPlPcVg3j2+kLe1Sq7+w91Yz
sgSloe8rUVeXh9a7aoJmk9DQh4afUw0TmCsw6BHmKlLuxZ4BUFi/kGnvqCwR0Ehd
1jm9/JtduRTIazXB6vEU
=aJjX
-----END PGP SIGNATURE-----

--=-135kV1ycSCIgn1gW+Dbz--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
