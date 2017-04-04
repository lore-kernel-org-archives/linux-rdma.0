From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V2 for-next 0/7] Change IDR usage and locking in uverbs
Date: Tue, 4 Apr 2017 00:04:47 -0400
Message-ID: <f3f83711-172a-2094-d2b0-7dbbec9c66aa@redhat.com>
References: <1489939145-125246-1-git-send-email-matanb@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="bAVt3WBnp5fD5t6TQqrgPteQHtfWvdnuL"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1489939145-125246-1-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--bAVt3WBnp5fD5t6TQqrgPteQHtfWvdnuL
Content-Type: multipart/mixed; boundary="bp7NaMdmloBuGketEim7feaRkk5C18Fhe";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>,
 Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>,
 Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>,
 Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>,
 Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>,
 Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Message-ID: <f3f83711-172a-2094-d2b0-7dbbec9c66aa-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V2 for-next 0/7] Change IDR usage and locking in uverbs
References: <1489939145-125246-1-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
In-Reply-To: <1489939145-125246-1-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

--bp7NaMdmloBuGketEim7feaRkk5C18Fhe
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 3/19/2017 11:58 AM, Matan Barak wrote:
> Hi Doug,

Hi Matan,

You mentioned at the OFA Workshop that there would be a v3 of this
patchset, yes?


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FD=
D


--bp7NaMdmloBuGketEim7feaRkk5C18Fhe--

--bAVt3WBnp5fD5t6TQqrgPteQHtfWvdnuL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJY4xtrAAoJELgmozMOVy/dFwoP/jooacPDcPXer4VDyobl1iFI
ZtDoTLCwL0gc6vk6kuK0rMJfX115E1JRwI6lEELqvljr0lWwH1YrTIBK402RSqeD
saCDee3pqnRRfUmTfZfuP2aCmVPykeI4Fb3NpVq1eIepRrqYRm8iIlbLhkCyhkah
jNuz2NIZ8sLvqy9oZ0J0Z9M4UuRE8Do2f5Trgm5SAWBDiy6dG/XUbPKHqj7IqVJk
73wsGiak3sHO65wOdJQbauwWJ1Aia5H0qyaY82C3g2VFT9x4emYX6t6LWWlGIh9t
d9e+hA7bs/9PIe/SiapRzN35alDGiv65eDNu4chqnfg39OWyIZS6m8rhs/76HVuk
VnM3i2QwbXjque7Z7Cka0wUMS2THjkKfT/zsu8j4R9THsmxJcrkKGdiOU1GNlO6W
9WtIBL3CC/ZKngO/1+cPWjmD7qCtpKn8SsiECakQpRzcHwHSqTynketcG0LAqTCH
ZwnkOVkbuJ6ZiIbpXH5Ycz4RbCVRLJs3n0XbkxZaigl1QLoTR+ygdko5d3PRH06d
VfwbRVpUNWZ96N5TUF+/f9RiWRuAI3Uzr0uCZ0RNUUlI3BLMBoI4/VLC5mLb/0YS
csZ1LnyH0iFeUvdk5onndzyH/FicMfLdidj5JnaOE4lcL579QYbj3QdXZsulE25j
cclKm8whcEPc3l3K50Aj
=O9aV
-----END PGP SIGNATURE-----

--bAVt3WBnp5fD5t6TQqrgPteQHtfWvdnuL--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
