From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v6 02/16] IB/pvrdma: Add user-level shared functions
Date: Wed, 5 Oct 2016 16:42:54 +0300
Message-ID: <20161005134254.GH9282@leon.nu>
References: <cover.1475458407.git.aditr@vmware.com>
 <515c704574423b16feb4c3d97847156623a8d042.1475458407.git.aditr@vmware.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="9sSKoi6Rw660DLir"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <515c704574423b16feb4c3d97847156623a8d042.1475458407.git.aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, pv-drivers-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org, jhansen-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org, asarwade-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org, georgezhang-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org, bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--9sSKoi6Rw660DLir
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Oct 02, 2016 at 07:10:22PM -0700, Adit Ranadive wrote:
> We share some common structures with the user-level driver. This patch adds
> those structures and shared functions to traverse the QP/CQ rings.
>
> Reviewed-by: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> Reviewed-by: Jorgen Hansen <jhansen-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> Reviewed-by: George Zhang <georgezhang-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> Reviewed-by: Aditya Sarwade <asarwade-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> Reviewed-by: Bryan Tan <bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> ---
> Changes v5->v6:
>  - Removed the pvrdma-uapi.h file and moved common structures into
>  pvrdma-abi.h.
>  - Moved enums and structs common to user-level and kernel driver into
>  pvrdma-abi.h.
>  - Changed _exp_ to _ex_ for extended structures.
>
> Changes v4->v5:
>  - Moved pvrdma_uapi.h and pvrdma_user.h into common UAPI folder.
>  - Renamed to pvrdma-uapi.h and pvrdma-abi.h respectively.
>  - Prefixed unsigned vars with __.
>
> Changes v3->v4:
>  - Moved pvrdma_sge into pvrdma_uapi.h
> ---
>  include/uapi/rdma/Kbuild       |   2 +
>  include/uapi/rdma/pvrdma-abi.h | 289 +++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 291 insertions(+)
>  create mode 100644 include/uapi/rdma/pvrdma-abi.h
>
> diff --git a/include/uapi/rdma/Kbuild b/include/uapi/rdma/Kbuild
> index ac62908..04357ba 100644
> --- a/include/uapi/rdma/Kbuild
> +++ b/include/uapi/rdma/Kbuild
> @@ -8,3 +8,5 @@ header-y += rdma_netlink.h
>  header-y += rdma_user_cm.h
>  header-y += hfi/
>  header-y += rdma_user_rxe.h
> +header-y += pvrdma-abi.h
> +header-y += pvrdma-uapi.h

You forgot to drop this line.

--9sSKoi6Rw660DLir
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJX9QNeAAoJEORje4g2clin2xgQAK+moQoRrLmEK2h55iQ1FmAy
Q3VlqM5v3GTtHckcy2aXomIZDuTs4IKyxGn9S2R8BOs7DeZy80yVXuF8SQaJVHuv
PysRJjjHdQKHSIeknAs8rauY+TcXjm5EDEhy5kqAznZkUtQ4FVVhv0IAIS72g85i
gYNU9oUmjSzE18PN/E4IbLLEOYAPOlI1LmImB/4vCqPMUOMQXNnCCxWyTnb+yvx/
OB9dE32YSddBg3QqVDAxfQIDTXfYnWr30sR3pOuy2blkcXsaToE6VE4uagJaQk1Q
iPd35wd5TBt6OQ1YmFMyqVLi9y/0rU3pfG7gl7RE9FlUx0LuN+MaJHJfhL8ZnAGt
wRgzLRbWSqEM5F8UYppniWFWITRZoLYYP5yJFjXzPiZfvSyva0rtnghr8e1hQ82k
EAwyb0TS8CH1EldCS3MVMJriof/LA2cobEVira+BuLaXae/YSqZK9qfT3P1rRiYF
ENvyMSwD6w2cELyovL50OE07kjjW/0MzgXRYi2MWYwsMAKlm8yAb1Q4EjcXHJKIX
eo4PaJm+S8JJX22hulT+bSeKkZ09UdowTC3A29D62GXE0O/caHOPeoROJSR+roNg
IenTObyGGBlrDb39gAlpDcTwThmI3RuMxYxt2xYlG0rWiwi0JVx6bkRYUIEirm6A
Z94OxTN1dvs7lmc+P2RW
=kuyr
-----END PGP SIGNATURE-----

--9sSKoi6Rw660DLir--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
