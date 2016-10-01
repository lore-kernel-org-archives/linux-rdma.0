From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/rxe: Fix honoring max IRD value for rd/atomic.
Date: Sat, 1 Oct 2016 19:11:36 -0400
Message-ID: <ddafc820-035a-5413-5399-673320d0e009@redhat.com>
References: <1475094404-18494-1-git-send-email-pandit.parav@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="2W6cvtTmiGCvtmjih7Hqd5oxB34Cu1oqc"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1475094404-18494-1-git-send-email-pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--2W6cvtTmiGCvtmjih7Hqd5oxB34Cu1oqc
Content-Type: multipart/mixed; boundary="LfeDUhMrh8qS1K6qjFeessLieBuVkEfOb";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org,
 linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Message-ID: <ddafc820-035a-5413-5399-673320d0e009-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/rxe: Fix honoring max IRD value for rd/atomic.
References: <1475094404-18494-1-git-send-email-pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
In-Reply-To: <1475094404-18494-1-git-send-email-pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

--LfeDUhMrh8qS1K6qjFeessLieBuVkEfOb
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 9/28/2016 4:26 PM, Parav Pandit wrote:
> This patch fixes honoring max incoming read request count instead of
> outgoing read req count
> (a) during modify qp by allocating response queue metadata
> (b) during incoming read request processing
>=20
> Signed-off-by: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Thanks, applied.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: 0E572FDD


--LfeDUhMrh8qS1K6qjFeessLieBuVkEfOb--

--2W6cvtTmiGCvtmjih7Hqd5oxB34Cu1oqc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJX8EKoAAoJELgmozMOVy/duoAP/jx6bmz47ISg+f0NfHv0Lxl4
VuOO+ty6JPYP+TPvKPTh36VSRK142IQA49Zx51FKCHgTi8KWnH/8IunDSXtfkgNt
1VoPiDfdfR6MSD9Kh3sRNXpq87DNY63tM4mLD2mbYPpV8bJj3XMGYrXm1QyMWIL2
cL3rmNPkWQcYy4wJSMV0SsdjxDN4hf1n64/j5sKlfNN+6t2EdVby0gmu6rsLzlLu
cTTnEwW4I0rZBDaIurm8bSpM8HNLvqGLCeO/4aDKzEYNm4O7m+1qI6UuAfnB6ty0
aKx70kmGz36874gy8NUkrPQ7LFsvuOMbwedg0JI2xYHq2INgSFWQBynkVbykzFBr
wM12mlkQ/yQTf8qhIiXqv1gXD/8RSQPA1TX7j7u/xkcZ4mpdbXyiIo7e/JeHZGg1
ZGA2TUPv0qtnV/lWIoMkNKi4SRwH9Ton2Z/1p8aQAl9dqvesXoDUenU4X5QdGU/m
MaiqVHBvyyy4VYe45WZibm5OfZoSf0hcSFp27Qso216ysLdqg+hB1oqMSd1MZuja
T0cQIwUqSf3Z+kuX9y2PXig24BuQaXzjmXs5RtW8owmO+M9CVuRmNSW/yUahtGod
PzPwxxyYE7dJwNuSy1nIvtJ8n7Eb04ALJxlG/CrdvNGY3RMkuopFLrEj3Hhzsc/D
KgZZSvKIzxVU7ONUs7Vn
=lOyX
-----END PGP SIGNATURE-----

--2W6cvtTmiGCvtmjih7Hqd5oxB34Cu1oqc--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
