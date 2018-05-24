From: Gi-Oh Kim <gi-oh.kim@profitbricks.com>
Subject: Re: [PATCH V4] mlx4_core: allocate ICM memory in page size chunks
Date: Thu, 24 May 2018 09:23:52 +0200
Message-ID: <CAJX1YtakDhk49kwrpAz27rGppq1FxXTewYFWJ_u06saa54x2vA@mail.gmail.com>
References: <20180523232246.20445-1-qing.huang@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180523232246.20445-1-qing.huang@oracle.com>
Sender: netdev-owner@vger.kernel.org
To: Qing Huang <qing.huang@oracle.com>
Cc: Tariq Toukan <tariqt@mellanox.com>, davem@davemloft.net, haakon.bugge@oracle.com, yanjun.zhu@oracle.com, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Thu, May 24, 2018 at 1:22 AM, Qing Huang <qing.huang@oracle.com> wrote:
> When a system is under memory presure (high usage with fragments),
> the original 256KB ICM chunk allocations will likely trigger kernel
> memory management to enter slow path doing memory compact/migration
> ops in order to complete high order memory allocations.
>
> When that happens, user processes calling uverb APIs may get stuck
> for more than 120s easily even though there are a lot of free pages
> in smaller chunks available in the system.
>
> Syslog:
> ...
> Dec 10 09:04:51 slcc03db02 kernel: [397078.572732] INFO: task
> oracle_205573_e:205573 blocked for more than 120 seconds.
> ...
>
> With 4KB ICM chunk size on x86_64 arch, the above issue is fixed.
>
> However in order to support smaller ICM chunk size, we need to fix
> another issue in large size kcalloc allocations.
>
> E.g.
> Setting log_num_mtt=3D30 requires 1G mtt entries. With the 4KB ICM chunk
> size, each ICM chunk can only hold 512 mtt entries (8 bytes for each mtt
> entry). So we need a 16MB allocation for a table->icm pointer array to
> hold 2M pointers which can easily cause kcalloc to fail.
>
> The solution is to use kvzalloc to replace kcalloc which will fall back
> to vmalloc automatically if kmalloc fails.


Hi,

Could you please write why it first try to allocate the contiguous pages?
I think it is necessary to comment why it uses kvzalloc instead of vzalloc.


>
> Signed-off-by: Qing Huang <qing.huang@oracle.com>
> Acked-by: Daniel Jurgens <danielj@mellanox.com>
> Reviewed-by: Zhu Yanjun <yanjun.zhu@oracle.com>

+Reviewed-by: Gioh Kim <gi-oh.kim@profitbricks.com>

> ---
> v4: use kvzalloc instead of vzalloc
>     add one err condition check
>     don't include vmalloc.h any more
>
> v3: use PAGE_SIZE instead of PAGE_SHIFT
>     add comma to the end of enum variables
>     include vmalloc.h header file to avoid build issues on Sparc
>
> v2: adjusted chunk size to reflect different architectures
>
>  drivers/net/ethernet/mellanox/mlx4/icm.c | 16 +++++++++-------
>  1 file changed, 9 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/net/ethernet/mellanox/mlx4/icm.c b/drivers/net/ether=
net/mellanox/mlx4/icm.c
> index a822f7a..685337d 100644
> --- a/drivers/net/ethernet/mellanox/mlx4/icm.c
> +++ b/drivers/net/ethernet/mellanox/mlx4/icm.c
> @@ -43,12 +43,12 @@
>  #include "fw.h"
>
>  /*
> - * We allocate in as big chunks as we can, up to a maximum of 256 KB
> - * per chunk.
> + * We allocate in page size (default 4KB on many archs) chunks to avoid =
high
> + * order memory allocations in fragmented/high usage memory situation.
>   */
>  enum {
> -       MLX4_ICM_ALLOC_SIZE     =3D 1 << 18,
> -       MLX4_TABLE_CHUNK_SIZE   =3D 1 << 18
> +       MLX4_ICM_ALLOC_SIZE     =3D PAGE_SIZE,
> +       MLX4_TABLE_CHUNK_SIZE   =3D PAGE_SIZE,
>  };
>
>  static void mlx4_free_icm_pages(struct mlx4_dev *dev, struct mlx4_icm_ch=
unk *chunk)
> @@ -398,9 +398,11 @@ int mlx4_init_icm_table(struct mlx4_dev *dev, struct=
 mlx4_icm_table *table,
>         u64 size;
>
>         obj_per_chunk =3D MLX4_TABLE_CHUNK_SIZE / obj_size;
> +       if (WARN_ON(!obj_per_chunk))
> +               return -EINVAL;
>         num_icm =3D (nobj + obj_per_chunk - 1) / obj_per_chunk;
>
> -       table->icm      =3D kcalloc(num_icm, sizeof(*table->icm), GFP_KER=
NEL);
> +       table->icm      =3D kvzalloc(num_icm * sizeof(*table->icm), GFP_K=
ERNEL);
>         if (!table->icm)
>                 return -ENOMEM;
>         table->virt     =3D virt;
> @@ -446,7 +448,7 @@ int mlx4_init_icm_table(struct mlx4_dev *dev, struct =
mlx4_icm_table *table,
>                         mlx4_free_icm(dev, table->icm[i], use_coherent);
>                 }
>
> -       kfree(table->icm);
> +       kvfree(table->icm);
>
>         return -ENOMEM;
>  }
> @@ -462,5 +464,5 @@ void mlx4_cleanup_icm_table(struct mlx4_dev *dev, str=
uct mlx4_icm_table *table)
>                         mlx4_free_icm(dev, table->icm[i], table->coherent=
);
>                 }
>
> -       kfree(table->icm);
> +       kvfree(table->icm);
>  }
> --
> 2.9.3
>



--=20
GIOH KIM
Linux Kernel Entwickler

ProfitBricks GmbH
Greifswalder Str. 207
D - 10405 Berlin

Tel:       +49 176 2697 8962
Fax:      +49 30 577 008 299
Email:    gi-oh.kim@profitbricks.com
URL:      https://www.profitbricks.de

Sitz der Gesellschaft: Berlin
Registergericht: Amtsgericht Charlottenburg, HRB 125506 B
Gesch=C3=A4ftsf=C3=BChrer: Achim Weiss, Matthias Steinberg, Christoph Steff=
ens
