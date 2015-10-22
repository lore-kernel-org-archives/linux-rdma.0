From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3 for-next 1/7] IB/core: Extend ib_uverbs_create_qp
Date: Wed, 21 Oct 2015 23:23:36 -0400
Message-ID: <562856B8.80700@redhat.com>
References: <1445436042-27616-1-git-send-email-eranbe@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="qhgBX8JSPHAw0tBcDdtL8jAPiwkQQPIhf"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1445436042-27616-1-git-send-email-eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--qhgBX8JSPHAw0tBcDdtL8jAPiwkQQPIhf
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 10/21/2015 10:00 AM, Eran Ben Elisha wrote:
> ib_uverbs_ex_create_qp follows the extension verbs
> mechanism. New features (for example, QP creation flags
> field which is added in a downstream patch) could used
> via user-space libraries without breaking the ABI.
>=20
> Signed-off-by: Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
> Hi Doug,
> This is a fix for the first patch of "Add support for multicast loopbac=
k
> prevention to mlx4"
> Changes from v2:
> 	remove comp_mask check in create_qp based on Haggai's comment

I updated the v2 series with this patch and then pulled in the entire
series.  Thanks.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--qhgBX8JSPHAw0tBcDdtL8jAPiwkQQPIhf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJWKFa4AAoJELgmozMOVy/dfoMQALc/uAVjBT4ddR+qg4c4mIO8
XXe85vYD3kT1J7J6WYedSTcbvWN8Ivj7FE2HqJD0wYapvZIBuGcD9zfsYn63uLqU
ELCpH+QjTJpQw7ZdIEnhD3RtYHuBjEIirCQ8V07YN6jSdMZg/+jJnfG4VIcQfTvC
7P/sRPZhHPqwljaaSmEcO8XxZerZpyLzWaZDBkm3rUOeoisM0qBnczV8xXhMY/ry
iYYKQ5Eg+DyiFWvWQ0zPlQluicyAmf8MAyXC7bV/0N02WPLpTBRIHKWVe92yRzqk
DhfN14gu/C37sLi3kO8Dxr8a7GhlRMKFoBFpf92kM9pt/M/X2cSmOa3ABxKUVCK5
7VgN2eegm4QWdnuMSf6CNRSzasAvKJrfR8Jk1YuacSN3oYcAOP8usZNIlrue/8yA
TgIG8so+mLLURw9kl84Rg8AgHN8phwCYCJ8os9b7WUY1eLotlJ/0X8FQpl95eAsr
1NUuvPvVV4vPva/mSpTV2LTkWLE5j8PwMzt2EN5kr0HiyR72tt5/xi+w5Q3JUfho
0CMKuDxNnScybW7vqBHseglCF+f9+vfU4fdthBXLWLP6QqqXjFRNaX127I/6Y2rB
v/KBkL2J/ASHveBjJSJZgH6RBArMS00prG22HPPFpWDc0d3B9DnpNUuQx7O8ruFP
jG/HTOs4I465tHhrUpXg
=FgrI
-----END PGP SIGNATURE-----

--qhgBX8JSPHAw0tBcDdtL8jAPiwkQQPIhf--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
