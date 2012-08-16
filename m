From: Roland Dreier <roland@kernel.org>
Subject: Re: linux-next: build failure after merge of the infiniband tree
Date: Wed, 15 Aug 2012 21:07:37 -0700
Message-ID: <CAG4TOxNLenjQxZNb7Rpm2G9RNBN77uWgEgfNXgoj+gLFdObuTg@mail.gmail.com>
References: <20120816114443.600553d2fd103a5b2b36e061@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <20120816114443.600553d2fd103a5b2b36e061@canb.auug.org.au>
Sender: linux-next-owner@vger.kernel.org
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-rdma@vger.kernel.org, linux-next@vger.kernel.org, linux-kernel@vger.kernel.org, Yishai Hadas <yishaih@mellanox.com>, Or Gerlitz <ogerlitz@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

On Wed, Aug 15, 2012 at 6:44 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> After merging the infiniband tree, today's linux-next build (powerpc
> ppc64_defconfig) failed like this:
>
> drivers/net/ethernet/mellanox/mlx4/mr.c: In function 'mlx4_buddy_init':
> drivers/net/ethernet/mellanox/mlx4/mr.c:134:4: error: implicit declaration of function 'vzalloc' [-Werror=implicit-function-declaration]
> drivers/net/ethernet/mellanox/mlx4/mr.c:134:19: warning: assignment makes pointer from integer without a cast [enabled by default]
> drivers/net/ethernet/mellanox/mlx4/mr.c:148:4: error: implicit declaration of function 'vfree' [-Werror=implicit-function-declaration]
> cc1: some warnings being treated as errors

Thanks, should be fixed in tomorrow's for-next (added include of
<linux/vmalloc.h>).

> See Rule 1 in Documentation/SubmitChecklist.

Heh, but it compiles fine on x86!

 - R.
