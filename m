From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [for-next 1/5] RDMA/bnxt_re: Enable RoCE on virtual functions
Date: Mon, 08 Jan 2018 17:12:29 -0500
Message-ID: <1515449549.3403.112.camel@redhat.com>
References: <1515152434-13105-1-git-send-email-devesh.sharma@broadcom.com>
         <1515152434-13105-2-git-send-email-devesh.sharma@broadcom.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-+2s2IN00ucOaeTVFhOfs"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1515152434-13105-2-git-send-email-devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-+2s2IN00ucOaeTVFhOfs
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2018-01-05 at 06:40 -0500, Devesh Sharma wrote:
> From: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
>=20
> Currently, fifty percent of the total available resources
> are reserved for PF and remaining are equally divided among
> active VFs.
>=20
> +/*
> + * Percentage of resources of each type reserved for PF.
> + * Remaining resources are divided equally among VFs.
> + * [0, 100]
> + */
> +#define BNXT_RE_PCT_RSVD_FOR_PF         50

This is a separate comment from the patch review itself.  But, are you
sure this is a good idea?  And especially are you sure that it should be
a compile time constant and not a runtime parameter?

I ask because it seems to me that usage of this stuff falls into one of
two categories:

1) All bare metal usage
2) SRIOV usage (in which case the bare metal OS does relatively little,
the SRIOV using clients do most of the work)

I guess I'm finding it hard to imagine a scenario where, when you do
have SRIOV VFs, that you don't want the majority of all resources being
used there.

I might suggest that you simply don't split resources at all.  Maybe do
something like filesystems do.  Let anyone at all take a resource until
you hit 95% utilization then only root can write to the filesystem.  In
this case it would be let both PFs and VFs use resources at will up
until you hit the 95% utilization threshold and then restrict resource
use to the PF.  That would make much more sense to me.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
--=-+2s2IN00ucOaeTVFhOfs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAlpT7M0ACgkQuCajMw5X
L907jw/9F6ZyRVZl+g12KewQbl4u7gm3BnX1Bo8vdGkkbDgK6MhJOtm08X7AscsT
lA4vjVFYW0PNZCkwikh4fOa2q7DnsBi/FL89QeNI8LsKdEAszY4XfkknP/8nh7f9
ebx+ZPT7mLVVeSLy81NBZ5WH9SxPPgi9kSPLGcFfe4oUsdFSlShC9TzEUSUzCX+g
qa/HRyH6nt6QVAv4N72N/VE8OyMoT0kPn25a5T5qLtbHi8tYtp18OJZ+jHfBJUCl
Ahzf8F0tDrqct2EnS44xxi2T/Rj4qjSDj/B41S2wMUiJ81r24G5j4iG1VBa9ZOPe
Hvtk5SVuaKQ+zFKgjx7aRBGXbMW4/5wk5/zdZgJg69254r/9Z+O4Q1jW4pWBYlva
o94rhpEroEOm1luKUutuGtiRJJ+g4/hEgEDR4lMue2T/n4UKb1PwHWCOXB45+Q4H
ma7JEpiWO6Lj05nQrsQwuPXIygrRscJjUOyMWLA2G88QNiw/zX+J+GkpU7mMOdLV
fwlHG0IEmx5ImmwicuWDohONSRqeabgEUhws1F6R5LyMI41FT5ToNAZ3tEHMO10B
/Juw947hRCqqgbfRfeCTeugqv/dXHKersihrgegpBJbyYwVeg9sGcpbZUkbO+bMY
lk2kDNFKmGODgZd5H2yGt3J1j9GAlUarrXji+FiKBJatTriKfS0=
=3ne8
-----END PGP SIGNATURE-----

--=-+2s2IN00ucOaeTVFhOfs--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
