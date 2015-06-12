From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 00/41] Add OPA gen1 driver
Date: Fri, 12 Jun 2015 16:04:10 -0400
Message-ID: <557B3B3A.8080406@redhat.com>
References: <20150611230710.16479.62955.stgit@phlsvslse11.ph.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="DlNw14abODx2AeM3e9AWfBePF1oKwk5PU"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150611230710.16479.62955.stgit-K+u1se/DcYrLESAwzcoQNrvm/XP+8Wra@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--DlNw14abODx2AeM3e9AWfBePF1oKwk5PU
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 06/11/2015 07:08 PM, Mike Marciniszyn wrote:
> This patch series adds the OPA gen1 driver.
>=20
> The patch depends on the this MAD patch series:
>=20
> https://patchwork.kernel.org/patch/6584551/

This patchset has now been picked up.  Just to make things work
smoothly, especially since I know you are reworking your submission to
get around the file size issue that caused three files not to make it to
patchworks, please base your next submission on my github tree's
to-be-rebase/for-4.2 branch.  That now has the above patchset, as well
as the same RDMA patches as the official k.o/for-4.2 branch, but it is
based off 4.1-rc7 instead of 4.1-rc4.



--DlNw14abODx2AeM3e9AWfBePF1oKwk5PU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJVezs7AAoJELgmozMOVy/dKG8QALAKHHglhHqo8S88PB/iJVda
O5u4AhVqhaO43SEkIdwQrnvMYw/tosAWxkVXUn240PHbCd71+VghqCk/1PgnUctR
ecVACIgACJ+bS0nR8fJW55ZPH6aUmKLVEFlg5zr6+eQXtTq+x2gjahsVocCEFssW
S5LnQh3ubf6XpiYZhDEKPXwc32cWYYxYVsNpEa4osCrmRic+TXjiqeQxwmvm9hTf
ivdpQqxAt93LOX7tyQsW9Eqln0WMwTPJzloo+feoQfaxsxDf60eGVLIEeOo9OZpp
PGBfpavehUZcnG5v6GNwHX1SACBOjgqtsSaMC4Zzj1WI+OOVGqhtYoMDzZxfWsVN
Wl4Z9b7PYgz61oWEpXlhHm1Hi+QAsFjwTFE++88s3Z7ZRSPE32RP44a7oebwzNcH
imMpxZUv8hd1VBUAGgBgiUxuDg1DggwWxFmk3YmlY5YG/sSSW59q9wyDhUI+tLH2
XQloK2t0e35Zu2QJVcHuGPmSBdjb3s/6zNLQYd4s4fgeZH15MejzxB/q2Fnzt64k
nUzgohj19IAnRqhBjZvc4wL9CNm0KLLgUXuGpmPOBHNaZ+V6c3b0u2F1zIHPV8Qm
asa1qL67G//3sVadXCQt7SvAnZwflKHGFimccCOPSJdWVs8G6qawFDFgKWayZzwP
iWIyABWmXVOEQmz9k9E2
=FZ8S
-----END PGP SIGNATURE-----

--DlNw14abODx2AeM3e9AWfBePF1oKwk5PU--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
