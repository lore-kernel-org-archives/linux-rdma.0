From: Aleksey Senin <aleksey-192fA4vuk7xBDLzU/O5InQ@public.gmane.org>
Subject: Re: [PATCH] mlx4: properly mask MGM entry members count
Date: Tue, 16 Nov 2010 11:38:45 +0200
Message-ID: <AANLkTi=zJsFjbrZrpj-E65T49ewgqdia+MOPnqmgx5KW@mail.gmail.com>
References: <20101115140829.GA20355@mtldesk30>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101115140829.GA20355@mtldesk30>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Nov 15, 2010 at 4:08 PM, Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wro=
te:
> The members_count field size is 24 bits so mask it properly when read=
ing it.
>
> Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
> ---
> =C2=A0drivers/net/mlx4/mcg.c | =C2=A0 =C2=A02 +-
> =C2=A01 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/net/mlx4/mcg.c b/drivers/net/mlx4/mcg.c
> index c4f88b7..fff20fc 100644
> --- a/drivers/net/mlx4/mcg.c
> +++ b/drivers/net/mlx4/mcg.c
> @@ -187,7 +187,7 @@ int mlx4_multicast_attach(struct mlx4_dev *dev, s=
truct mlx4_qp *qp, u8 gid[16],
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0memcpy(mgm->gi=
d, gid, 16);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0}
>
> - =C2=A0 =C2=A0 =C2=A0 members_count =3D be32_to_cpu(mgm->members_cou=
nt);
> + =C2=A0 =C2=A0 =C2=A0 members_count =3D be32_to_cpu(mgm->members_cou=
nt) & 0xffffff;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0if (members_count =3D=3D MLX4_QP_PER_MGM) =
{
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0mlx4_err(dev, =
"MGM at index %x is full.\n", index);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0err =3D -ENOME=
M;
> --
> 1.6.0.2
>

Don't you need to do the same when detaching?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
