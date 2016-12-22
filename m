From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 0/3] IB/rxe: Three small fixes
Date: Thu, 22 Dec 2016 19:18:33 +0200
Message-ID: <20161222171833.GD18935@mtr-leonro.local>
References: <1482414878-6892-1-git-send-email-andrew.boyer@dell.com>
 <9f5e0225-c53e-43e7-13b5-ae715f74b198@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="+xNpyl7Qekk2NvDX"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <9f5e0225-c53e-43e7-13b5-ae715f74b198-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Andrew Boyer <andrew.boyer-8PEkshWhKlo@public.gmane.org>, monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--+xNpyl7Qekk2NvDX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Dec 22, 2016 at 11:41:24AM -0500, Doug Ledford wrote:
> On 12/22/2016 8:54 AM, Andrew Boyer wrote:
> > This patch series addresses two issues found during heavy traffic
> > testing as well as a recently-reported Smatch issue.
> >
> > Andrew Boyer (3):
> >   IB/rxe: Use BTH_PSN_MASK when ACKing duplicate sends
> >   IB/rxe: Drop future atomic/read packets rather than retrying
> >   IB/rxe: Don't check for null ptr in send()
> >
> >  drivers/infiniband/sw/rxe/rxe_comp.c | 2 +-
> >  drivers/infiniband/sw/rxe/rxe_net.c  | 3 +--
> >  drivers/infiniband/sw/rxe/rxe_resp.c | 3 ++-
> >  3 files changed, 4 insertions(+), 4 deletions(-)
> >
>
> Thanks, series applied.

Hi Doug,

Thank you for such fast response, but can you please give enough time to
other reviewers/relevant maintainers to take a look on them before
applying?

Thanks

>
> --
> Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>     GPG Key ID: B826A3330E572FDD
>     Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
>




--+xNpyl7Qekk2NvDX
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlhcCukACgkQ5GN7iDZy
WKd7sRAAnmkA9S/tQ+ZJ7TbGNuj54bxU+3biM76qqI4dwNw193FXlPYJ+UuF03iR
mVJvqep2wSqT7ONaxEXfOaS+a/+bow4DQVXCm8e/Mv2PdPksHF/9AsKjcCWy2Fe+
0FlJT6N308kM3aEMRCCLGEK4gDsZYcerItzyYpgv9hDVfb9dsobCB3AcjoppCt2o
So2qT3wRT8zfEKXnqM3+6FCXB7N7X3eSFdJ7CV77g9c5a00lTm5PXycgN4IWXmXY
lgzv8WdTNCgsKMLhIhAbc7h2PcdQwmVi5WeaX+HJc1wRbG+8BUCQmJsLh2BA9GsL
4axcnJ0P221jKSc8+nc+7riVQI143ValkAaoEh2mxrgoq7ucJtCcwL2rT3xhcHJe
EcThBq3F2DXraDiI/gIVLqowB2swoEz3r9klcebi5ty+dj/tZuiMVzMEy17D9WDf
cbspw/FmZ49N8ovmBPwhJuf684xicAZ/MY+Fn1voelqemnH+sr1++jma5TLDi0ZS
q8yYxiEKinnAqfQvFqZiGD+czlJelif+OtakgU/xI4JDA+CSTuQGD4YNJxh7k5zf
c/yMrIa1xzY6QuscfjehlOR7qIBL6ocXq5331JHgsJ7c0Jmj+zWhmgO5bRzmoKqf
hXcHQ63Kndhr2KoyR7DuLDQEVNRdj5UYlBfCGKj28EcmipmhCIs=
=w/Op
-----END PGP SIGNATURE-----

--+xNpyl7Qekk2NvDX--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
