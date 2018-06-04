From: Cong Wang <xiyou.wangcong@gmail.com>
Subject: Re: [PATCH] infiniband: fix a possible use-after-free bug
Date: Mon, 4 Jun 2018 09:30:34 -0700
Message-ID: <CAM_iQpV2PJZUQEcXh=TpHRZzLEqGLDAQ1j1_ibPY_kNfbWoAEQ@mail.gmail.com>
References: <20180601183144.17374-1-xiyou.wangcong@gmail.com> <CAJX1YtZNdwiwPmj5gGTqURjvLqa5g7Ly_h+TEZfNJSW=mrqRiQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAJX1YtZNdwiwPmj5gGTqURjvLqa5g7Ly_h+TEZfNJSW=mrqRiQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Gi-Oh Kim <gi-oh.kim@profitbricks.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Noam Rathaus <noamr@beyondsecurity.com>, Sean Hefty <sean.hefty@intel.com>, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Jun 4, 2018 at 9:23 AM, Gi-Oh Kim <gi-oh.kim@profitbricks.com> wrote:
> Hi,
>
> Your patch is reasonable to me.
> Can I ask a question for that?
> Could it be solved by asymmetric locking as following?

Maybe, if you are sure taking file->mut is safe in that place.

Can you double check atomic_inc_not_zero(&mc->ctx->ref)?
I am too far away from familiar with infiniband. ;)
