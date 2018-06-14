From: Cong Wang <xiyou.wangcong@gmail.com>
Subject: Re: [PATCH] infiniband: fix a subtle race condition
Date: Wed, 13 Jun 2018 23:21:54 -0700
Message-ID: <CAM_iQpXxHk+yFqqK-Hezsc83_mKfbUXr4=jjNnik5DwGscRKUA@mail.gmail.com>
References: <20180613234947.15767-1-xiyou.wangcong@gmail.com> <20180614053446.GB18426@mtr-leonro.mtl.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180614053446.GB18426@mtr-leonro.mtl.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-rdma@vger.kernel.org, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

On Wed, Jun 13, 2018 at 10:34 PM, Leon Romanovsky <leon@kernel.org> wrote:
>
> Hi Cong,
>
> If the compiler optimizes the first line (mutex_lock) as you wrote,
> it will reuse "f" for the second line (mutex_unlock) too.

Nope, check the assembly if you don't trust me, at least
my compiler always fetches ctx->file without this patch.

I can show you the assembly code tomorrow (too late to
access my dev machine now).


>
> You need to ensure that ucma_modify_id() doesn't run in parallel to
> anything that uses "ctx->file" directly and indirectly.
>

Talk is easy, show me the code. :) I knew there is probably
some other race with this code even after my patch, possibly with
->close() for example, but for this specific unlock warning, this patch
is sufficient. I can't solve all the races in one patch.
