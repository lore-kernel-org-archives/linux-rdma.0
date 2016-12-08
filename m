From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 03/11] IB/core: Change ah_attr.dlid from 16 to 32 bits
Date: Thu, 8 Dec 2016 17:13:56 +0200
Message-ID: <20161208151356.GE9722@mtr-leonro.local>
References: <1479843532-47496-1-git-send-email-dasaratharaman.chandramouli@intel.com>
 <1479843532-47496-4-git-send-email-dasaratharaman.chandramouli@intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="zCKi3GIZzVBPywwA"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1479843532-47496-4-git-send-email-dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dasaratharaman Chandramouli <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--zCKi3GIZzVBPywwA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 22, 2016 at 02:38:44PM -0500, Dasaratharaman Chandramouli wrote:
> dlid field in ah_attr is increased to 32 bits. This
> enables core components to use the larger addresses if needed.
> The user ABI is unchanged and userspace applications can use
> 16 bit lids when creating and modifying address handles.
>=20
> Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Dasaratharaman Chandramouli <dasaratharaman.chandramouli@i=
ntel.com>
> Signed-off-by: Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---

<...>

> diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
> index 52216f6..294d3ed 100644
> --- a/include/rdma/ib_verbs.h
> +++ b/include/rdma/ib_verbs.h
> @@ -814,7 +814,7 @@ struct ib_mr_status {
> =20
>  struct ib_ah_attr {
>  	struct ib_global_route	grh;
> -	u16			dlid;
> +	u32			dlid;
>  	u8			sl;
>  	u8			src_path_bits;
>  	u8			static_rate;

It looks like this structure can be reshuffled. Can you run pahole on it, p=
lease?

Thanks

> --=20
> 1.8.3.1
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--zCKi3GIZzVBPywwA
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlhJeK0ACgkQ5GN7iDZy
WKeaehAAujnKuK9+2fRNxNlRQI2CbdWKdmH0FvZlcztmtJokKkvgdOfJZ8SEmnwF
QSwJmVnY9t3HW2Znuyu9j0p8Ec4e94Z9mJYDeTT67XuOWkdHmnWfHEs/OPSLyejg
Gk0XdY9Ux9Om9jCrhOhGEPCgQLWxp9MJTRE9LqbRS3I1qly4/wutvuiCo4KFQzab
QdFKsmt6g7dsgBt2jUU6QB1OKIYmgWOMW2fdzTMQPu/Z9qFuVVMCwRRQd1/BudcJ
eLTxvpGYivPLFx3RxX6rRGePcWXgLgfRq62jRRtVsbUaRlCXcCU61pKLppxCYgS8
tF2Dddi/pNTAlPHpbTFvdMKptG8vksbp4HZAA4BRkF4bPIy5wJLuG7POpiSKK5nP
BMkjqduHT8qK/JbtyFk83wji7s5LplvG53apGmSu9wtw9O85Tdmy5ujimFXOBHfA
9WvqKmhwWvKDWpbOwun+r2DkIwmBmHHGTaYMWmpwJ5/QT+7W99xiDhTw6AW6s63W
8Sxy6oR3bQ0an8T5XNLrX5Rg+lM9cBM3tledpq4cdACPbphaQAfKkxPdFdEWDx+0
ArMkLLUL9JG/IXsNvD6LrZ9KvXOugZkctcLzWaRsBLAKX7q4U/TJ7wBE1RVRGN/b
dvW97TEwB0uhVnDPYsmMSCTIA4aInbgU+ejp1D4SpvC9T4o7tfA=
=DrpV
-----END PGP SIGNATURE-----

--zCKi3GIZzVBPywwA--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
