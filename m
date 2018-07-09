From: Jann Horn <jannh@google.com>
Subject: Re: [PATCH v2] IB/mlx5: fix uaccess beyond "count" in debugfs
 read/write handlers
Date: Mon, 9 Jul 2018 14:22:14 +0200
Message-ID: <CAG48ez2nLELb0bvK_SkQZuLLReaohZbk9yjMnyC7AYHJdtEEnw@mail.gmail.com>
References: <20180706204803.131152-1-jannh@google.com> <20180708065623.GK3014@mtr-leonro.mtl.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180708065623.GK3014@mtr-leonro.mtl.com>
Sender: linux-kernel-owner@vger.kernel.org
To: leon@kernel.org
Cc: dledford@redhat.com, jgg@ziepe.ca, linux-rdma@vger.kernel.org, kernel list <linux-kernel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, Jul 8, 2018 at 8:56 AM Leon Romanovsky <leon@kernel.org> wrote:
>
> On Fri, Jul 06, 2018 at 10:48:03PM +0200, Jann Horn wrote:
> > In general, accessing userspace memory beyond the length of the supplied
> > buffer in VFS read/write handlers can lead to both kernel memory corruption
> > (via kernel_read()/kernel_write(), which can e.g. be triggered via
> > sys_splice()) and privilege escalation inside userspace.
> >
> > In this case, the affected files are in debugfs (and should therefore only
> > be accessible to root), and the read handlers check that *pos is zero
> > (meaning that at least sys_splice() can't trigger kernel memory
> > corruption). Because of the root requirement, this is not a security fix,
> > but rather a cleanup.
> >
> > For the read handlers, fix it by using simple_read_from_buffer() instead of
> > custom logic. Add min() calls to the write handlers.
> >
> > changed in v2:
> >  - also fix write handlers
>
> No changelog in commit messages, please

I will try to do that better in the future. I never noticed that
changelogs go below the three dashes...

> > Fixes: 4a2da0b8c078 ("IB/mlx5: Add debug control parameters for congestion control")
> > Fixes: e126ba97dba9 ("mlx5: Add driver for Mellanox Connect-IB adapters")
> > Signed-off-by: Jann Horn <jannh@google.com>
> > ---
> >  drivers/infiniband/hw/mlx5/cong.c |  9 +--------
> >  drivers/infiniband/hw/mlx5/mr.c   | 32 ++++++++-----------------------
> >  2 files changed, 9 insertions(+), 32 deletions(-)
> >
>
> Thanks,
> Reviewed-by: Leon Romanovsky <leonro@mellanox.com>
