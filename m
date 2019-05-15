From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: undefined reference to `__aeabi_uldivmod' after 25c13324d03d
 ("IB/mlx5: Add steering SW ICM device memory type")
Date: Tue, 14 May 2019 21:32:02 -0300
Message-ID: <20190515003202.GA14522@ziepe.ca>
References: <20190514194510.GA15465@archlinux-i9>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190514194510.GA15465@archlinux-i9>
Sender: linux-kernel-owner@vger.kernel.org
To: Nathan Chancellor <natechancellor@gmail.com>, fengguang.wu@intel.com, kbuild@01.org
Cc: Ariel Levkovich <lariel@mellanox.com>, Eli Cohen <eli@mellanox.com>, Mark Bloch <markb@mellanox.com>, Leon Romanovsky <leonro@mellanox.com>, Doug Ledford <dledford@redhat.com>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Tue, May 14, 2019 at 12:45:10PM -0700, Nathan Chancellor wrote:
> Hi all,
> 
> I checked the RDMA mailing list and trees and I haven't seen this
> reported/fixed yet (forgive me if it has) but when building for arm32
> with multi_v7_defconfig and the following configs (distilled from
> allyesconfig):
> 
> CONFIG_INFINIBAND=y
> CONFIG_INFINIBAND_ON_DEMAND_PAGING=y
> CONFIG_INFINIBAND_USER_ACCESS=y
> CONFIG_MLX5_CORE=y
> CONFIG_MLX5_INFINIBAND=y
> 
> The following link time errors occur:
> 
> arm-linux-gnueabi-ld: drivers/infiniband/hw/mlx5/main.o: in function `mlx5_ib_alloc_dm':
> main.c:(.text+0x60c): undefined reference to `__aeabi_uldivmod'
> arm-linux-gnueabi-ld: drivers/infiniband/hw/mlx5/cmd.o: in function `mlx5_cmd_alloc_sw_icm':
> cmd.c:(.text+0x6d4): undefined reference to `__aeabi_uldivmod'
> arm-linux-gnueabi-ld: drivers/infiniband/hw/mlx5/cmd.o: in function `mlx5_cmd_dealloc_sw_icm':
> cmd.c:(.text+0x9ec): undefined reference to `__aeabi_uldivmod'

Fengguang, I'm surprised that 0-day didn't report this earlier.. 

and come to think of it, I haven't seen a success email from 0-day for
the rdma trees in some time - is it still working?

Thanks,
Jason
