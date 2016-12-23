From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-core] verbs: Do not copy uninitialized data in
 ibv_cmd_modify_qp
Date: Fri, 23 Dec 2016 07:11:45 -0500
Message-ID: <3b92a286-8bd3-0121-cddd-14342c977c81@redhat.com>
References: <20161222221334.GA15907@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="utmO7WRP7g08JbSdVTqVVjfvO3goF17XI"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161222221334.GA15907-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--utmO7WRP7g08JbSdVTqVVjfvO3goF17XI
Content-Type: multipart/mixed; boundary="3ugj9GrQMLuINts8KMfggjgo4NioDrqvR";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>,
 Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Message-ID: <3b92a286-8bd3-0121-cddd-14342c977c81-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-core] verbs: Do not copy uninitialized data in
 ibv_cmd_modify_qp
References: <20161222221334.GA15907-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
In-Reply-To: <20161222221334.GA15907-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>

--3ugj9GrQMLuINts8KMfggjgo4NioDrqvR
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 12/22/2016 5:13 PM, Jason Gunthorpe wrote:
> Valgrind reports:
>=20
> =3D=3D1196=3D=3D Syscall param write(buf) points to uninitialised byte(=
s)
> =3D=3D1196=3D=3D    at 0x506250D: ??? (syscall-template.S:84)
> =3D=3D1196=3D=3D    by 0x527756F: ibv_cmd_modify_qp (cmd.c:1291)
> =3D=3D1196=3D=3D    by 0x8008D74: mlx4_modify_qp (verbs.c:820)
> =3D=3D1196=3D=3D    by 0x527E4F4: ibv_modify_qp@@IBVERBS_1.1 (verbs.c:5=
61)
> =3D=3D1196=3D=3D    by 0x4E3FAB3: ucma_modify_qp_err.isra.6 (cma.c:1115=
)
> =3D=3D1196=3D=3D    by 0x4E41D56: rdma_get_cm_event.part.15 (cma.c:2180=
)
> =3D=3D1196=3D=3D    by 0x402CF0: cm_thread (rping.c:576)
> =3D=3D1196=3D=3D    by 0x5059709: start_thread (pthread_create.c:333)
> =3D=3D1196=3D=3D    by 0x558A82C: clone (clone.S:109)
> =3D=3D1196=3D=3D  Address 0x9847980 is on thread 2's stack
> =3D=3D1196=3D=3D  in frame #2, created by mlx4_modify_qp (verbs.c:775)
>=20
> This is because of code like this:
>=20
>         struct ibv_qp_attr qp_attr;
>         qp_attr.qp_state =3D IBV_QPS_ERR;
>         return rdma_seterrno(ibv_modify_qp(id->qp, &qp_attr, IBV_QP_STA=
TE));
>=20
> Always pass 0 into the kernel for for attributes that are not requested=

> to be modified.
>=20
> Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>

Thanks, applied.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FD=
D


--3ugj9GrQMLuINts8KMfggjgo4NioDrqvR--

--utmO7WRP7g08JbSdVTqVVjfvO3goF17XI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJYXRSBAAoJELgmozMOVy/d59cP/03YhDuARIHwSlzCdK7ywk9T
y3Zex5fQz1f65jJePWLq2mWV7LBvuZY0C+2wpIfPbigIrwZKNKDSsr5dzQwDC/f3
9sNYsd2IPXp+Y7wnsZcNFAqLewhEJrCMzhs0JIsv2S7H+NuifEceobglklpIu0Xs
lnniZ3Xn8cdM3mpoQP275yGMOBzk3UwYdVJR0qE+odcxVs8lKZjfbsgf5XjoWF0s
nLxsuUuBT6lMRf99+Hla/amwkZjRIR7j37lIs8T+WddI011rduamL5moX9GYXqwe
ivOKBh2ywaxYcRqgLhoWwMRK0MV1j3ZBfHjz/mC/n55Ca0JWKMcTaIjUprYi2fEf
wg+lJVGomKa5UFhl+ZJCZBAXTfK6uMZBEJhrZxWVIflDWYWrrz/I6i92wUVxaPr2
mR+TbMWQ4aofKtAzeLmMBVj96bH7VCvD+77qn+O93hjjbjsw2CiyIVy44G6FysSf
ooDcgL2WYMMsRH2t0prCb0UGjGS9vicb1YQp7dm2D/z/IcRIhnw03s4wOfdPNu50
Zi5KFAF4XoNply0ipp+ALY3HOruI8xHl4pVo6Hwh22RLjjojlkNN1v9Q8PD9a9+1
J5sO2Dfc6vSvhtNCSBnhLInwlWSlq0Gcr0avHeSxiuMUcegeF5O6A1rkUXPH0qqh
i5TCBytGUQ5ce2cyPYWc
=r2qa
-----END PGP SIGNATURE-----

--utmO7WRP7g08JbSdVTqVVjfvO3goF17XI--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
