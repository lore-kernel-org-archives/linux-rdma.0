From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH] IB/umem: use tgid instead of pid in ib_umem structure
Date: Fri, 4 May 2018 12:23:02 -0600
Message-ID: <20180504182302.zunfryk2czge5adx@ziepe.ca>
References: <1525356274-736-1-git-send-email-lidongchen@tencent.com>
 <20180503153310.GA9738@ziepe.ca>
 <CAOGPPbd8ysq3XDpa4TYQpWVMmpVo4NPhPw5NWyQS1OSc6rXjQQ@mail.gmail.com>
 <CAOGPPbenmtuFwCuGMFJDZrqK+D5atkhK+srm+2yX=+CAwgjPHQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAOGPPbenmtuFwCuGMFJDZrqK+D5atkhK+srm+2yX=+CAwgjPHQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: 858585 jemmy <jemmy858585@gmail.com>
Cc: dledford@redhat.com, akpm@linux-foundation.org, qing.huang@oracle.com, Leon Romanovsky <leon@kernel.org>, artemyko@mellanox.com, dan.j.williams@intel.com, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, adido@mellanox.com, Gal Shachaf <galsha@mellanox.com>, Aviad Yehezkel <aviadye@mellanox.com>, Lidong Chen <lidongchen@tencent.com>
List-Id: linux-rdma@vger.kernel.org

On Fri, May 04, 2018 at 04:51:15PM +0800, 858585 jemmy wrote:
> On Fri, May 4, 2018 at 11:14 AM, 858585 jemmy <jemmy858585@gmail.com> wrote:
> > On Thu, May 3, 2018 at 11:33 PM, Jason Gunthorpe <jgg@ziepe.ca> wrote:
> >> On Thu, May 03, 2018 at 10:04:34PM +0800, Lidong Chen wrote:
> >>> The userspace may invoke ibv_reg_mr and ibv_dereg_mr by different threads.
> >>> If when ibv_dereg_mr invoke and the thread which invoked ibv_reg_mr has
> >>> exited, get_pid_task will return NULL, ib_umem_release does not decrease
> >>> mm->pinned_vm. This patch fixes it by use tgid.
> >>>
> >>> Signed-off-by: Lidong Chen <lidongchen@tencent.com>
> >>>  drivers/infiniband/core/umem.c | 12 ++++++------
> >>>  include/rdma/ib_umem.h         |  2 +-
> >>>  2 files changed, 7 insertions(+), 7 deletions(-)
> >>
> >> Why are we even using a struct pid for this? Does anyone know?
> >
> > commit 87773dd56d5405ac28119fcfadacefd35877c18f add pid in ib_umem structure.
> >
> > and the comment has such information:
> > Later a different process with a different mm_struct than the one that
> > allocated the ib_umem struct
> > ends up releasing it which results in decrementing the new processes
> > mm->pinned_vm count past
> > zero and wrapping.
> 
> I think a different process should not have the permission to release ib_umem.
> so maybe the reason is not a different process?
> can ib_umem_release be invoked in interrupt context?

We plan to restore fork support and add some way to share MRs between
processes, so we must consider having a different process release the
umem than acquired it.

Jason
