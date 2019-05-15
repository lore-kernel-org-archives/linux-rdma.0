From: Leon Romanovsky <leonro@mellanox.com>
Subject: Re: undefined reference to `__aeabi_uldivmod' after 25c13324d03d
 ("IB/mlx5: Add steering SW ICM device memory type")
Date: Wed, 15 May 2019 05:03:33 +0000
Message-ID: <20190515050331.GC5225@mtr-leonro.mtl.com>
References: <20190514194510.GA15465@archlinux-i9>
 <20190515003202.GA14522@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190515003202.GA14522@ziepe.ca>
Content-Language: en-US
Content-ID: <A61103C5E14CC1499F108762A7D8805C@eurprd05.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Nathan Chancellor <natechancellor@gmail.com>, "fengguang.wu@intel.com" <fengguang.wu@intel.com>, "kbuild@01.org" <kbuild@01.org>, Ariel Levkovich <lariel@mellanox.com>, Eli Cohen <eli@mellanox.com>, Mark Bloch <markb@mellanox.com>, Doug Ledford <dledford@redhat.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, May 14, 2019 at 09:32:02PM -0300, Jason Gunthorpe wrote:
> On Tue, May 14, 2019 at 12:45:10PM -0700, Nathan Chancellor wrote:
> > Hi all,
> >
> > I checked the RDMA mailing list and trees and I haven't seen this
> > reported/fixed yet (forgive me if it has) but when building for arm32
> > with multi_v7_defconfig and the following configs (distilled from
> > allyesconfig):
> >
> > CONFIG_INFINIBAND=3Dy
> > CONFIG_INFINIBAND_ON_DEMAND_PAGING=3Dy
> > CONFIG_INFINIBAND_USER_ACCESS=3Dy
> > CONFIG_MLX5_CORE=3Dy
> > CONFIG_MLX5_INFINIBAND=3Dy
> >
> > The following link time errors occur:
> >
> > arm-linux-gnueabi-ld: drivers/infiniband/hw/mlx5/main.o: in function `m=
lx5_ib_alloc_dm':
> > main.c:(.text+0x60c): undefined reference to `__aeabi_uldivmod'
> > arm-linux-gnueabi-ld: drivers/infiniband/hw/mlx5/cmd.o: in function `ml=
x5_cmd_alloc_sw_icm':
> > cmd.c:(.text+0x6d4): undefined reference to `__aeabi_uldivmod'
> > arm-linux-gnueabi-ld: drivers/infiniband/hw/mlx5/cmd.o: in function `ml=
x5_cmd_dealloc_sw_icm':
> > cmd.c:(.text+0x9ec): undefined reference to `__aeabi_uldivmod'
>
> Fengguang, I'm surprised that 0-day didn't report this earlier..

I got many successful emails after I pushed this patch to 0-day testing.

>
> and come to think of it, I haven't seen a success email from 0-day for
> the rdma trees in some time - is it still working?
>
> Thanks,
> Jason
