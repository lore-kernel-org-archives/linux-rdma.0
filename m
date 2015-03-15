From: Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] net: ethernet: mellanox: correct page conversion
Date: Sun, 15 Mar 2015 12:05:39 +0200
Message-ID: <CAPcc5Pi8yM4hQ6uwmiAMJAh9zYf8wO9ujp7mxoJaLZKP7JV3BQ@mail.gmail.com>
References: <1424977168-19523-1-git-send-email-timur@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1424977168-19523-1-git-send-email-timur-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: timur-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sinan Kaya <okaya-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Feb 26, 2015 at 8:59 PM,  <timur-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org> wrote:
> From: Sinan Kaya <okaya-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
>
> Current code is assuming that the addresses returned
> by dma_alloc_coherent is a logical address. This is
> not true on ARM/ARM64 systems. This patch uses
> dma_to_phys API to reach to the actual physical address
> and then convert to the page pointer.
>
> Signed-off-by: Sinan Kaya <okaya-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
> ---
>  drivers/net/ethernet/mellanox/mlx4/alloc.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/ethernet/mellanox/mlx4/alloc.c b/drivers/net=
/ethernet/mellanox/mlx4/alloc.c
> index 963dd7e..8eca66a 100644
> --- a/drivers/net/ethernet/mellanox/mlx4/alloc.c
> +++ b/drivers/net/ethernet/mellanox/mlx4/alloc.c
> @@ -634,8 +634,13 @@ int mlx4_buf_alloc(struct mlx4_dev *dev, int siz=
e, int max_direct,
>                         pages =3D kmalloc(sizeof *pages * buf->nbufs,=
 gfp);
>                         if (!pages)
>                                 goto err_free;
> -                       for (i =3D 0; i < buf->nbufs; ++i)
> -                               pages[i] =3D virt_to_page(buf->page_l=
ist[i].buf);
> +                       for (i =3D 0; i < buf->nbufs; ++i) {
> +                               phys_addr_t phys;
> +
> +                               phys =3D dma_to_phys(&dev->pdev->dev,
> +                                                  buf->page_list[i].=
map);
> +                               pages[i] =3D phys_to_page(phys);
> +                       }
>                         buf->direct.buf =3D vmap(pages, buf->nbufs, V=
M_MAP, PAGE_KERNEL);
>                         kfree(pages);
>                         if (!buf->direct.buf)
> --
> Qualcomm Innovation Center, Inc.
> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora F=
orum,
> a Linux Foundation Collaborative Project.
>

This will not compile on non ARM arch. For example x86:

drivers/net/ethernet/mellanox/mlx4/alloc.c: In function =E2=80=98mlx4_b=
uf_alloc=E2=80=99:
drivers/net/ethernet/mellanox/mlx4/alloc.c:642:5: error: implicit
declaration of function =E2=80=98phys_to_page=E2=80=99
[-Werror=3Dimplicit-function-declaration]
     pages[i] =3D phys_to_page(phys);

Amir
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
