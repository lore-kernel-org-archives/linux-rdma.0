From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/rxe: IB/core: IB/rdmavt: Fix kernel crash for reg MR
Date: Sat, 1 Oct 2016 19:10:53 -0400
Message-ID: <a8e03f71-1fab-72b7-805a-8264a3c2f8c7@redhat.com>
References: <1475094347-18402-1-git-send-email-pandit.parav@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="1w9OGQD7DT1JhcuK39B4QXm99tRSDwWaD"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1475094347-18402-1-git-send-email-pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--1w9OGQD7DT1JhcuK39B4QXm99tRSDwWaD
Content-Type: multipart/mixed; boundary="J4j9joX4T41BJ5G12C62mPQo3q0pQFpfK";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org,
 monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Message-ID: <a8e03f71-1fab-72b7-805a-8264a3c2f8c7-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/rxe: IB/core: IB/rdmavt: Fix kernel crash for reg MR
References: <1475094347-18402-1-git-send-email-pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
In-Reply-To: <1475094347-18402-1-git-send-email-pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

--J4j9joX4T41BJ5G12C62mPQo3q0pQFpfK
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 9/28/2016 4:25 PM, Parav Pandit wrote:
> This patch fixes below kernel crash on memory registration for rxe
> and other transport drivers which has dma_ops extension.
>=20
> IB/core invokes ib_map_sg_attrs() in generic manner with dma attributes=

> which is used by mlx5 and mthca adapters.
> However in doing so it ignored honoring dma_ops extension of software b=
ased
> transports for sg map/unmap operation.
> This results into calling dma_map_sg_attrs of hardware virtual device
> resulting in crash for null reference.
>=20
> Fix: It extends core to support sg_map/unmap_attrs and transport driver=
s
> to implement those dma_ops callback functions.
> Verified usign perftest applications.

The commit message had to be largely rewritten, but the code was applied.=



--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: 0E572FDD


--J4j9joX4T41BJ5G12C62mPQo3q0pQFpfK--

--1w9OGQD7DT1JhcuK39B4QXm99tRSDwWaD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJX8EJ9AAoJELgmozMOVy/dd68P/0AtW7sAdF8zo/xGykEoffdb
MbN2ZAWaNiNjUBvm8sKDvuUA4mXBxOGP6NuFbx5ODdV3uiBsgjy9t4f6gaWf+UXE
xZ0hmorB8hinUWlXVK6NTkPX8viyq4PO3yj1mfG3/HYe8wzR99flHLK8u/8HYOEO
HVyW291wOWuc4LS7mxIVeSfNhsrBFQAKKMzRe02WuzIna1VZs/Fz5eq6fH9uVMPA
gGqqvm3oFniqKcxm77MypvfrrNyonixxzDTo0YmCqqtvnD+VpAG/Q2pkJYP+bvn6
F1ZM8ic+9tygrUWac674uq1tPPpvNUy2qMUWv7sAUTFxotXuCguSeJztoiNOl0av
uPoy3cvSNo2nIG6xBo5U+mAHins3NrN7EKzWJ+8cDgf4J8RF1/fnTx9vJKcOITYA
P8DAKf8OUx80SjbNA1aa0tTaTx1RgUpHjR7I0yFxm1BHAeCKl3h2bME/pLkqpeBa
SMZHUIEPN2Z0FIAO+Q0W+YpOpcE3H5YkcSQZjDmMxUqC/7OL8tuDBXhsxij7sNJe
ugFQ0cWzzXiL1k3kOTuLQVKblyLKOfHv0rhTmyhDCJ+SGInFhbyj6tLoo/wlTQoN
Jbqn5opTiZBmIsXp/KyKz4MRVe2v0sZUnMZV9ml8rjgz/iBSe72gKL/8dV2vPUw3
P7nT6tA/v8CVloNY26qj
=DFg0
-----END PGP SIGNATURE-----

--1w9OGQD7DT1JhcuK39B4QXm99tRSDwWaD--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
