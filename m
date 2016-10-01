From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v1] rdma_rxe: Ensure rdma_rxe init occurs at correct time
Date: Sat, 1 Oct 2016 19:03:40 -0400
Message-ID: <ca8674c6-eb71-a076-36ee-dfd84a7b45cd@redhat.com>
References: <1474644731-27818-1-git-send-email-sbates@raithlin.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="WWvW7HT7WqmT5q5bCbKiKrD0c53bpg5vF"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1474644731-27818-1-git-send-email-sbates-pv7U853sEMVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Stephen Bates <sbates-pv7U853sEMVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--WWvW7HT7WqmT5q5bCbKiKrD0c53bpg5vF
Content-Type: multipart/mixed; boundary="TQgNVr03xteubWJpJRNogv1N7ig833Hce";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Stephen Bates <sbates-pv7U853sEMVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
 monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Message-ID: <ca8674c6-eb71-a076-36ee-dfd84a7b45cd-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v1] rdma_rxe: Ensure rdma_rxe init occurs at correct time
References: <1474644731-27818-1-git-send-email-sbates-pv7U853sEMVWk0Htik3J/w@public.gmane.org>
In-Reply-To: <1474644731-27818-1-git-send-email-sbates-pv7U853sEMVWk0Htik3J/w@public.gmane.org>

--TQgNVr03xteubWJpJRNogv1N7ig833Hce
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 9/23/2016 11:32 AM, Stephen Bates wrote:
> This patch is based off v4.8-rc6 with the recent rxe bugfix patchset
> applied [1].
>=20
> There is a problem when CONFIG_RDMA_RXE=3Dy and CONFIG_IPV6=3Dy. This
> results in the rdma_rxe initialization occurring before the IPv6
> services are ready. This patch delays the initialization of rdma_rxe
> until after the IPv6 services are ready. This fix is based on one
> proposed by Logan Gunthorpe on a much older code base [2].
>=20
> [1] http://marc.info/?l=3Dlinux-rdma&m=3D147307739626544&w=3D2
>=20
> [2] https://github.com/sbates130272/qemu-minimal/blob/rdma/patches/\
>   0001-Changes-needed-to-use-rxe-compiled-into-the-kernel.patch

Thanks, applied.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: 0E572FDD


--TQgNVr03xteubWJpJRNogv1N7ig833Hce--

--WWvW7HT7WqmT5q5bCbKiKrD0c53bpg5vF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJX8EDMAAoJELgmozMOVy/dVvoP/03YUa726So1xFAZ3u9y++Eg
Slvk6H7PaGW8zI+sYOcOdoi4LtJel9EAcrJlM1iB0SkA9kcYdfvijs9RiPWRBCBc
4aTY8UGANeO+emDyX4k6C/x+Jj7EjTCxAOqZKIFfjtDQO3QWcD1GjgH040HcOzGD
Qgbog6t01jE2cFXfyacNNZSsMjCJiCAFvSo3fSvQz7BgH+EdB7qNqIx9O3tYhePl
6p+MzOZFvbU3WrsfDbPEh/EeGeJZEvMVBDPMt2jJaymBvTQR4Y7/e8ERqxURluvT
i4FFV7njUyuVQy9IAndAGHIICR3aYbXaMV7Uj10GM+H2QYT2VdGaL3gLXvvmzI22
5DFWoQEyauIFUQz3UIGk0r0ppB/8DE17gA3YvzGWQBb6frXvCV1v/U4xXV90Jgn/
5cnT5czt2Zz171Rs65glwPoT/C3wFSTeJGl1BE+e2UXPbgyv8FBGwP51/s2jpGPE
DstBxc38UUwe2lwdeBZS4PyjYOA5hwOcV3XbyD/n7TI91r43FmuTqIgZEctOQBB/
0AOqkg7UEdWmC70elwyLY62AENjIpDbWTz3T74P5Fd/zJiDeCvn7a4wyybD/kYOY
pinhZYhv7aL0HggUMvEJ6UpvaFmJaS+73+ZayeNZfVhZx853x9fAandW+FUzjoYh
bOhweL4N9oKV+0LUbpui
=Y4TE
-----END PGP SIGNATURE-----

--WWvW7HT7WqmT5q5bCbKiKrD0c53bpg5vF--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
