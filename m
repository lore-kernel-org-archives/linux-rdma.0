From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH resend] RDMA/iser: don't send an rkey if all data is
 written as immadiate-data
Date: Sat, 22 Jul 2017 13:55:17 -0400
Message-ID: <87fb9ccb-026b-d6c1-d204-096f5abd625c@redhat.com>
References: <1499325696-18310-1-git-send-email-sagi@grimberg.me>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="FKgDgW353Sq3Au4SHQAVEXhE9aGR3HwxA"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1499325696-18310-1-git-send-email-sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--FKgDgW353Sq3Au4SHQAVEXhE9aGR3HwxA
Content-Type: multipart/mixed; boundary="uGQi1Tf06A21P4qi1Kw1LkKGBudnM4x6o";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Message-ID: <87fb9ccb-026b-d6c1-d204-096f5abd625c-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH resend] RDMA/iser: don't send an rkey if all data is
 written as immadiate-data
References: <1499325696-18310-1-git-send-email-sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
In-Reply-To: <1499325696-18310-1-git-send-email-sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>

--uGQi1Tf06A21P4qi1Kw1LkKGBudnM4x6o
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 7/6/2017 3:21 AM, Sagi Grimberg wrote:
> We might get some bogus error completions in case the target will
> remotely invalidate the rkey and the HCA will need to retransmit
> from this buffer.
>=20
> Signed-off-by: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>

This was accepted into 4.13-rc, thanks.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FD=
D


--uGQi1Tf06A21P4qi1Kw1LkKGBudnM4x6o--

--FKgDgW353Sq3Au4SHQAVEXhE9aGR3HwxA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJZc5GFAAoJELgmozMOVy/d5fMP/A55THcORFjC4/KxrHwDtIcF
oW6m3nB5msoUv1Fb3V3/xC2kh2pUvt4jF09Nj5STTe+3+rNhmWtFwoA+ayRw5+04
OHb+d99uW0ELiVIcwuGIGxf9vYlAGafNpUvJPl2NBWtQWl06V8XdhlhPjWLtv/Ee
rlR2982qV7CMfyeslMpqABWrnISRYqwFoL2YLV6GshaTZzHUByWRFUKce3c4r6EK
XT3MdxnBV0+BCA67Quxi80wOVn7gUhjNVpBCZ/B3UDcacDbQ4+zcXzFcsUExQVop
AmMx+2F9Xhop+VEj32gUt7xdsgkfj1awk8LDE6vOjUm+89T9jNucVACBHt+uInRy
9GSu7QrC6StFxsBWTW92kgKec5QLEGTuRfJEM6Oj0hhAogbB0PfdeCqx/9DuiQdG
IhQPG1gqwfDrN6q3n1NwQHhI+LxL124M82CpfpBawxt2WoT8TtDwgAadHukCBRsa
DgJzEolljMhPp1bPymT9TJvFDXRsylj1GMwP+uIFghypJejFAfU5Zfr7W86HH2q9
MoYPcNqiOHOicDwM1AnqKorCVuTIzyNrQMvAirwd6riL6DnF1iFs6ntQ+xfX01dM
4bF92/i309fwjwI6koS322oHya64Nnt8zYbSCxyyVBF9fVXoD2FN7ag4D0hpgdVA
582/i0GTgN9M33XYxQ5h
=DmWR
-----END PGP SIGNATURE-----

--FKgDgW353Sq3Au4SHQAVEXhE9aGR3HwxA--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
