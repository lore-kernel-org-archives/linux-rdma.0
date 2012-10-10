From: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH] IB/lmx4: silence GCC warning
Date: Wed, 10 Oct 2012 09:23:43 +0200
Message-ID: <201210100923.43927.jackm@dev.mellanox.co.il>
References: <1348836538.3626.21.camel@x61.thuisdomein>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1348836538.3626.21.camel-uMdlDhfIn7prKue/0VVhAg@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Paul Bolle <pebolle-IWqWACnzNjzz+pZb47iToQ@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

You could use:

   u16 uninitialized_var(vlan);

instead.

Although this in the special QP data flow, I still prefer to avoid addi=
ng extra code (even setting
initial values at procedure entry).  The line above will also do the jo=
b.  "uninitialized_var"
is used elsewhere in the driver.  See, for example, mlx4_ib_post_send()=
 in the same file (qp.c).

-Jack

On Friday 28 September 2012 14:48, Paul Bolle wrote:
> Building qp.o (part of the "Mellanox ConnectX HCA support" driver)
> triggers this GCC warning:
>     drivers/infiniband/hw/mlx4/qp.c: In function =E2=80=98mlx4_ib_pos=
t_send=E2=80=99:
>     drivers/infiniband/hw/mlx4/qp.c:1828:30: warning: =E2=80=98vlan=E2=
=80=99 may be used uninitialized in this function [-Wmaybe-uninitialize=
d]
>     drivers/infiniband/hw/mlx4/qp.c:1718:6: note: =E2=80=98vlan=E2=80=
=99 was declared here
>=20
> Looking at the code it is clear 'vlan' is only set and used if 'is_et=
h'
> is non-zero. But there's no harm in initializing 'vlan' to 0 (which
> matches ib_get_cached_gid()'s default return) to silence GCC.
>=20
> Signed-off-by: Paul Bolle <pebolle-IWqWACnzNjzz+pZb47iToQ@public.gmane.org>
> ---
> 0) I noticed this warning while building v3.6-rc7 on current Fedora 1=
7,
> using Fedora's default config.
>=20
> 1) Compile tested only. I tested against v3.6-rc7, with commit
> a41262bb5721f2b708ee8b23f67be2f2e16a2fab ("IB/mlx4: SR-IOV IB context
> objects and proxy/tunnel SQP") from linux-next cherry-picked, to take
> into account a trivial context change in linux-next.
>=20
>  drivers/infiniband/hw/mlx4/qp.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/infiniband/hw/mlx4/qp.c b/drivers/infiniband/hw/=
mlx4/qp.c
> index a862251..71fdda6 100644
> --- a/drivers/infiniband/hw/mlx4/qp.c
> +++ b/drivers/infiniband/hw/mlx4/qp.c
> @@ -1715,7 +1715,7 @@ static int build_mlx_header(struct mlx4_ib_sqp =
*sqp, struct ib_send_wr *wr,
>  	int is_eth;
>  	int is_vlan =3D 0;
>  	int is_grh;
> -	u16 vlan;
> +	u16 vlan =3D 0;
>  	int err =3D 0;
> =20
>  	send_size =3D 0;
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
