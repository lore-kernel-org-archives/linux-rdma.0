From: Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>
Subject: Re: [PATCH] drivers: infiniband: Mark function _c4iw_write_mem_dma()
 as static in mem.c
Date: Sat, 14 Dec 2013 12:24:45 -0800
Message-ID: <20131214202444.GB17601@leaf>
References: <20131214131214.GA8459@rashika>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20131214131214.GA8459@rashika>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Rashika Kheria <rashika.kheria-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Steve Wise <swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Sat, Dec 14, 2013 at 06:42:14PM +0530, Rashika Kheria wrote:
> This patch marks the function _c4iw_write_mem_dma() as static in
> hw/cxgb4/mem.c because it is not used outside this file.
>=20
> Thus, it also eliminates the following warning in hw/cxgb4/mem.c:
> drivers/infiniband/hw/cxgb4/mem.c:176:5: warning: no previous prototy=
pe for =E2=80=98_c4iw_write_mem_dma=E2=80=99 [-Wmissing-prototypes]
>=20
> Signed-off-by: Rashika Kheria <rashika.kheria-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Reviewed-by: Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>

>  drivers/infiniband/hw/cxgb4/mem.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/infiniband/hw/cxgb4/mem.c b/drivers/infiniband/h=
w/cxgb4/mem.c
> index 4cb8eb2..84e4500 100644
> --- a/drivers/infiniband/hw/cxgb4/mem.c
> +++ b/drivers/infiniband/hw/cxgb4/mem.c
> @@ -173,7 +173,7 @@ static int _c4iw_write_mem_inline(struct c4iw_rde=
v *rdev, u32 addr, u32 len,
>  	return ret;
>  }
> =20
> -int _c4iw_write_mem_dma(struct c4iw_rdev *rdev, u32 addr, u32 len, v=
oid *data)
> +static int _c4iw_write_mem_dma(struct c4iw_rdev *rdev, u32 addr, u32=
 len, void *data)
>  {
>  	u32 remain =3D len;
>  	u32 dmalen;
> --=20
> 1.7.9.5
>=20
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
