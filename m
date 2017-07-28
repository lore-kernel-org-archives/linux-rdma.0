From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH 2/2] IB/mlx5: Fix existence check for extended address
 vector
Date: Fri, 28 Jul 2017 14:25:59 -0400
Message-ID: <1501266359.2593.42.camel@redhat.com>
References: <20170612073616.14852-1-leon@kernel.org>
         <20170612073616.14852-2-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20170612073616.14852-2-leon@kernel.org>
Sender: stable-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>
Cc: linux-rdma@vger.kernel.org, Majd Dibbiny <majd@mellanox.com>, stable@vger.kernel.org, Leon Romanovsky <leonro@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

On Mon, 2017-06-12 at 10:36 +0300, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@mellanox.com>
> 
> The extended address vector is the highest bit in be32 variable,
> but it was compared with the lowest. This patch fixes the endianness
> of that check and removes already declared define.
> 
> Fixes: 17d2f88f92ce ("IB/mlx5: Add ODP atomics support")
> Reviewed-by: Artemy Kovalyov <artemyko@mellanox.com>
> Signed-off-by: Leon Romanovsky <leonro@mellanox.com>

Thanks, applied.

-- 
Doug Ledford <dledford@redhat.com>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
