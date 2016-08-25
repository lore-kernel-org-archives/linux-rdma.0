From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/{core,hw}: Add constant for node_desc
Date: Thu, 25 Aug 2016 10:23:22 -0400
Message-ID: <b366ef68-3f46-a245-2495-76107954219e@redhat.com>
References: <1472115186-10718-1-git-send-email-yuval.shaia@oracle.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="U14cJNEJC78Ww5XxTRQmDWwNNODiwIc47"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1472115186-10718-1-git-send-email-yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--U14cJNEJC78Ww5XxTRQmDWwNNODiwIc47
Content-Type: multipart/mixed; boundary="b1nUTBCmRNADQJr50rut59PQntVjqs4XP"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
 sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Message-ID: <b366ef68-3f46-a245-2495-76107954219e-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/{core,hw}: Add constant for node_desc
References: <1472115186-10718-1-git-send-email-yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
In-Reply-To: <1472115186-10718-1-git-send-email-yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

--b1nUTBCmRNADQJr50rut59PQntVjqs4XP
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 8/25/2016 4:53 AM, Yuval Shaia wrote:
> Signed-off-by: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> ---
>  drivers/infiniband/core/sysfs.c              |    2 +-
>  drivers/infiniband/hw/cxgb3/iwch_provider.c  |    2 +-
>  drivers/infiniband/hw/cxgb3/iwch_provider.h  |    1 +
>  drivers/infiniband/hw/cxgb4/iw_cxgb4.h       |    1 +
>  drivers/infiniband/hw/cxgb4/provider.c       |    2 +-
>  drivers/infiniband/hw/hfi1/verbs.c           |    3 ++-
>  drivers/infiniband/hw/mlx4/mad.c             |    3 ++-
>  drivers/infiniband/hw/mlx4/main.c            |    6 +++---
>  drivers/infiniband/hw/mlx5/mad.c             |    2 +-
>  drivers/infiniband/hw/mlx5/main.c            |    6 +++---
>  drivers/infiniband/hw/mthca/mthca_mad.c      |    3 ++-
>  drivers/infiniband/hw/mthca/mthca_provider.c |    5 +++--
>  drivers/infiniband/hw/ocrdma/ocrdma.h        |    1 +
>  drivers/infiniband/hw/ocrdma/ocrdma_main.c   |    2 +-
>  drivers/infiniband/hw/qib/qib_verbs.c        |    3 ++-
>  include/rdma/ib_verbs.h                      |    6 ++++--
>  16 files changed, 29 insertions(+), 19 deletions(-)

Thanks, applied to for-next.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: 0E572FDD


--b1nUTBCmRNADQJr50rut59PQntVjqs4XP--

--U14cJNEJC78Ww5XxTRQmDWwNNODiwIc47
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXvv9aAAoJELgmozMOVy/d/9wQAKkpxYBgFAYOq0i1E9wdzwzf
0ziCO3xSnB271IL0MMu+YRU8f5jmtiS/SBYoC5Q4G/9DmTEF6NM3Em2LZUntFS05
XiL/bAzLIUHonLLbFxkyTMUIQzHnOldcOqJF7M4qOqZFy+4VYw/ro5G4Gx3bQlr5
XvDm/x7vXkThtF0nLTJ0JXWjhtVjbhZtfhfFu1KvdVk62+tzUGLTialbMH050Ni3
NZtDXnwFFZnpAHLHYrDjaoAByC/Q5TWpAEojA+MhfEF2HDq2Ad82N18QPbe9rpDl
g0a2ldgOEHOupKj17aBrSEnUQ2s5b+qhDX9oGtPqyvK9nc7nKSCeKnY+0dvdTe//
ei9IGgvmY/ly6GXeINekfupZe/Vru4h/MpE4uO6gJEzEfAr/xNGjMnCy1jbEePK0
k8be8XPy8M5IuDNx/3jlAdiRg+IfaDdOH+OETaEeQOmQH1NOF6LdiVn+UW5kOnHb
wi5O9IXN2K4eUpu6VWCVOYD4dmpfxyk2R5TQ4vHb2Jz2IDVXxEEOB5vbmhCcOXcU
FiJIWOAtRx8TB5PviwGpKyHhdu1palBskQzaCOuUmwLxS4XsgkyDQeBToWlz0RPP
HKxGB/g81fXgpKOOForVtuGhlxukBKmHzeI8D2Rs5YlTpoy0Ob1DlpAEi4kjvRpa
eupXyFe3kM4IfwuxxxuW
=lt6+
-----END PGP SIGNATURE-----

--U14cJNEJC78Ww5XxTRQmDWwNNODiwIc47--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
