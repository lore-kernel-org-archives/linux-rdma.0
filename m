From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH 1/2] IB/mlx5: Fix cached MR allocation flow
Date: Fri, 28 Jul 2017 14:25:43 -0400
Message-ID: <1501266343.2593.41.camel@redhat.com>
References: <20170612073616.14852-1-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20170612073616.14852-1-leon@kernel.org>
Sender: stable-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>
Cc: linux-rdma@vger.kernel.org, Majd Dibbiny <majd@mellanox.com>, stable@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Mon, 2017-06-12 at 10:36 +0300, Leon Romanovsky wrote:
> From: Majd Dibbiny <majd@mellanox.com>
> 
> When we have a miss in one order of the mkey cache, we try to get
> an mkey from a higher order.
> 
> We still need to check that the higher order can be used with UMR
> before using it. Otherwise, we will get an mkey with 0 entries and
> the post send operation that is used to fill it will complete with
> the following error:
> 
> mlx5_0:dump_cqe:275:(pid 0): dump error cqe
> 00000000 00000000 00000000 00000000
> 00000000 00000000 00000000 00000000
> 00000000 0f007806 25000025 49ce59d2
> 
> Fixes: 49780d42dfc9 ("IB/mlx5: Expose MR cache for mlx5_ib")
> Cc: <stable@vger.kernel.org> # v4.10+
> Signed-off-by: Majd Dibbiny <majd@mellanox.com>
> Reviewed-by: Ilya Lesokhin <ilyal@mellanox.com>
> Signed-off-by: Leon Romanovsky <leon@kernel.org>

Thanks, applied.

-- 
Doug Ledford <dledford@redhat.com>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
