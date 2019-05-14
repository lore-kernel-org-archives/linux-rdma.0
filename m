From: Saeed Mahameed <saeedm@dev.mellanox.co.il>
Subject: Re: [PATCH mlx5-next 2/2] net/mlx5: Set completion EQs as shared resources
Date: Tue, 14 May 2019 13:14:56 -0700
Message-ID: <CALzJLG8R-MMef5_y37p=dh4iOG2Bt7=AKNq+3+uTg5=cgbDRRg@mail.gmail.com>
References: <20190514114412.30604-1-leon@kernel.org> <20190514114412.30604-3-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190514114412.30604-3-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>
Cc: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Saeed Mahameed <saeedm@mellanox.com>, Yishai Hadas <yishaih@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, May 14, 2019 at 4:44 AM Leon Romanovsky <leon@kernel.org> wrote:
>
> From: Yishai Hadas <yishaih@mellanox.com>
>
> Mark completion EQs as shared resources so that they can be used by CQs
> with uid != 0.
>
> Fixes: 7efce3691d33 ("IB/mlx5: Add obj create and destroy functionality")
> Signed-off-by: Yishai Hadas <yishaih@mellanox.com>
> Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
> Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
> ---
>  drivers/net/ethernet/mellanox/mlx5/core/eq.c | 3 +++
>  include/linux/mlx5/mlx5_ifc.h                | 2 +-
>  2 files changed, 4 insertions(+), 1 deletion(-)
>

Hi leon,

I see the patch is marked for mlx5-next,
As we spoke earlier, let's push this directly to rdma-next and skip
mlx5-next, we will need to reset the branch soon, so let's keep it
clean.

Thanks,
Saeed
