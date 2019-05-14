From: Nathan Chancellor <natechancellor@gmail.com>
Subject: undefined reference to `__aeabi_uldivmod' after 25c13324d03d
 ("IB/mlx5: Add steering SW ICM device memory type")
Date: Tue, 14 May 2019 12:45:10 -0700
Message-ID: <20190514194510.GA15465@archlinux-i9>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Ariel Levkovich <lariel@mellanox.com>, Eli Cohen <eli@mellanox.com>, Mark Bloch <markb@mellanox.com>, Leon Romanovsky <leonro@mellanox.com>, Jason Gunthorpe <jgg@ziepe.ca>, Doug Ledford <dledford@redhat.com>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Hi all,

I checked the RDMA mailing list and trees and I haven't seen this
reported/fixed yet (forgive me if it has) but when building for arm32
with multi_v7_defconfig and the following configs (distilled from
allyesconfig):

CONFIG_INFINIBAND=y
CONFIG_INFINIBAND_ON_DEMAND_PAGING=y
CONFIG_INFINIBAND_USER_ACCESS=y
CONFIG_MLX5_CORE=y
CONFIG_MLX5_INFINIBAND=y

The following link time errors occur:

arm-linux-gnueabi-ld: drivers/infiniband/hw/mlx5/main.o: in function `mlx5_ib_alloc_dm':
main.c:(.text+0x60c): undefined reference to `__aeabi_uldivmod'
arm-linux-gnueabi-ld: drivers/infiniband/hw/mlx5/cmd.o: in function `mlx5_cmd_alloc_sw_icm':
cmd.c:(.text+0x6d4): undefined reference to `__aeabi_uldivmod'
arm-linux-gnueabi-ld: drivers/infiniband/hw/mlx5/cmd.o: in function `mlx5_cmd_dealloc_sw_icm':
cmd.c:(.text+0x9ec): undefined reference to `__aeabi_uldivmod'

Bisect log:

git bisect start
# good: [e93c9c99a629c61837d5a7fc2120cd2b6c70dbdd] Linux 5.1
git bisect good e93c9c99a629c61837d5a7fc2120cd2b6c70dbdd
# bad: [63863ee8e2f6f6ae47be3dff4af2f2806f5ca2dd] Merge tag 'gcc-plugins-v5.2-rc1' of ssh://gitolite.kernel.org/pub/scm/linux/kernel/git/kees/linux
git bisect bad 63863ee8e2f6f6ae47be3dff4af2f2806f5ca2dd
# good: [80f232121b69cc69a31ccb2b38c1665d770b0710] Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next
git bisect good 80f232121b69cc69a31ccb2b38c1665d770b0710
# good: [a2d635decbfa9c1e4ae15cb05b68b2559f7f827c] Merge tag 'drm-next-2019-05-09' of git://anongit.freedesktop.org/drm/drm
git bisect good a2d635decbfa9c1e4ae15cb05b68b2559f7f827c
# bad: [8e4ff713ce313dcabbb60e6ede1ffc193e67631f] Merge tag 'rtc-5.2' of git://git.kernel.org/pub/scm/linux/kernel/git/abelloni/linux
git bisect bad 8e4ff713ce313dcabbb60e6ede1ffc193e67631f
# good: [055128ee008b00fba14e3638e7e84fc2cff8d77d] Merge tag 'dmaengine-5.2-rc1' of git://git.infradead.org/users/vkoul/slave-dma
git bisect good 055128ee008b00fba14e3638e7e84fc2cff8d77d
# bad: [abde77eb5c66b2f98539c4644b54f34b7e179e6b] Merge branch 'for-5.2' of git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup
git bisect bad abde77eb5c66b2f98539c4644b54f34b7e179e6b
# good: [3b70508a6bfbdc78b565e9da22fd98483263494e] RDMA/mlx5: Create flow table with max size supported
git bisect good 3b70508a6bfbdc78b565e9da22fd98483263494e
# bad: [e7a5b4aafd82771f8924905c208d5d236ddcb671] RDMA/device: Don't fire uevent before device is fully initialized
git bisect bad e7a5b4aafd82771f8924905c208d5d236ddcb671
# good: [dd05cb828d0ebecd3d772075fccb85ec3618bedf] RDMA: Get rid of iw_cm_verbs
git bisect good dd05cb828d0ebecd3d772075fccb85ec3618bedf
# bad: [a808273a495c657e33281b181fd7fcc2bb28f662] RDMA/verbs: Add a DMA iterator to return aligned contiguous memory blocks
git bisect bad a808273a495c657e33281b181fd7fcc2bb28f662
# good: [3a4ef2e2b5cf9a34bcc66c0d33f7eba180a14535] RDMA/rdmavt: Catch use-after-free access of AH structures
git bisect good 3a4ef2e2b5cf9a34bcc66c0d33f7eba180a14535
# bad: [33cde96fb5d7ae36207541c8a832d7fae3cadbde] IB/mlx5: Device resource control for privileged DEVX user
git bisect bad 33cde96fb5d7ae36207541c8a832d7fae3cadbde
# good: [4056b12efd43248d8331b6ed93df5ea5250106a9] IB/mlx5: Warn on allocated MEMIC buffers during cleanup
git bisect good 4056b12efd43248d8331b6ed93df5ea5250106a9
# bad: [25c13324d03d004f9e8071bf5bf5d5c6fdace71e] IB/mlx5: Add steering SW ICM device memory type
git bisect bad 25c13324d03d004f9e8071bf5bf5d5c6fdace71e
# first bad commit: [25c13324d03d004f9e8071bf5bf5d5c6fdace71e] IB/mlx5: Add steering SW ICM device memory type

DIV_ROUND_UP is u64 / u32 in this case. I think DIV_ROUND_UP_ULL is
needed but I am not sure if that has any unintended side effects so I
didn't want to send a patch.

I would appreciate if you guys could look into this.

Cheers,
Nathan
