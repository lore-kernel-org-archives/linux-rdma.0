From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH] mlx5: avoid 64-bit division
Date: Tue, 28 May 2019 17:01:45 +0300
Message-ID: <20190528140145.GO4633@mtr-leonro.mtl.com>
References: <20190520111902.7104DE0184@unicorn.suse.cz>
 <20190520112835.GF4573@mtr-leonro.mtl.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190520112835.GF4573@mtr-leonro.mtl.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Michal Kubecek <mkubecek@suse.cz>
Cc: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, Ariel Levkovich <lariel@mellanox.com>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Mon, May 20, 2019 at 02:28:35PM +0300, Leon Romanovsky wrote:
> On Mon, May 20, 2019 at 01:19:02PM +0200, Michal Kubecek wrote:
> > Commit 25c13324d03d ("IB/mlx5: Add steering SW ICM device memory type")
> > breaks i386 build by introducing three 64-bit divisions. As the divisor
> > is MLX5_SW_ICM_BLOCK_SIZE() which is always a power of 2, we can replace
> > the division with bit operations.
>
> Interesting, we tried to solve it differently.
> I added it to our regression to be on the same side.

This patch works for us.

Thanks,
Reviewed-by: Leon Romanovsky <leonro@mellanox.com>
