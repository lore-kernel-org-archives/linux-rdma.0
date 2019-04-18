From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH rdma-next 3/6] RDMA/ucontext: Do not allow BAR mappings to
 be executable
Date: Thu, 18 Apr 2019 01:30:07 -0500
Message-ID: <CAGXu5jKH-YwkzEp4UFckabJV_WOTAEQWSZ7787ovhSs215v2+Q@mail.gmail.com>
References: <20190416110730.32230-1-leon@kernel.org> <20190416110730.32230-4-leon@kernel.org>
 <14063C7AD467DE4B82DEDB5C278E8663BE6A5513@FMSMSX108.amr.corp.intel.com> <20190418055759.GA3155@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190418055759.GA3155@mellanox.com>
Sender: netdev-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@mellanox.com>
Cc: "Ruhl, Michael J" <michael.j.ruhl@intel.com>, Leon Romanovsky <leon@kernel.org>, Doug Ledford <dledford@redhat.com>, Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Andrea Arcangeli <aarcange@redhat.com>, Feras Daoud <ferasda@mellanox.com>, Haggai Eran <haggaie@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Apr 18, 2019 at 12:58 AM Jason Gunthorpe <jgg@mellanox.com> wrote:
>
> On Wed, Apr 17, 2019 at 07:05:37PM +0000, Ruhl, Michael J wrote:
>
> > >diff --git a/drivers/infiniband/core/uverbs_main.c
> > >b/drivers/infiniband/core/uverbs_main.c
> > >index fef4519d1241..3ef6474cd201 100644
> > >+++ b/drivers/infiniband/core/uverbs_main.c
> > >@@ -889,6 +889,10 @@ static struct rdma_umap_priv
> > >*rdma_user_mmap_pre(struct ib_ucontext *ucontext,
> > >     struct ib_uverbs_file *ufile = ucontext->ufile;
> > >     struct rdma_umap_priv *priv;
> > >
> > >+    if (vma->vm_flags & VM_EXEC)
> > >+            return ERR_PTR(-EINVAL);
> > >+    vma->vm_flags &= ~VM_MAYEXEC;
> > >+
> >
> > A change like this was made in HFI with:
> >
> > commit 12220267645cb7d1f3f699218e0098629e932e1f
> > IB/hfi: Protect against writable mmap
> >
> > This caused user applications that use the stack for execution to fail.
> > The VM_EXEC flag is passed down during mmaps.
> >
> > We had to remove this patch with:
> >
> > commit 7709b0dc265f28695487712c45f02bbd1f98415d
> > IB/hfi1: Remove overly conservative VM_EXEC flag check
> >
> > to resolve this issue.
> >
> > I am not sure if this is an equivalent issue, but the code path
> > appears very similar.
>
> It does seem problematic here too
>
> Kees: You have worked in this W^X area in other parts of the kernel,
> what should drivers do here?
>
> The situation is we have a driver providing mmap against BAR memory
> that is absolutely not intended for execution, so we would prefer to
> block VM_EXEC in the driver's mmap fops callback
>
> However READ_IMPLIES_EXEC forces VM_EXEC on for everything with no way
> to opt out..

Ah, my old "friend" READ_IMPLIES_EXEC!

Anything running with READ_IMPLIES_EXEC (i.e. a gnu stack marked WITH
execute) should be considered broken. Now, the trouble is that this
personality flag is carried across execve(), so if you have a launcher
that doesn't fix up the personality for children, you'll see this
spread all over your process tree. What is doing rdma mmap calls with
an executable stack? That really feels to me like the real source of
the problem.

I swear this was different handling of READ_IMPLIES_EXEC between
x86_64 and ia32, but I can't find it. (i.e. I thought the default for
64-bit was to assume NX stack even when the gnustack marking was
missing.)

Is the file for the driver coming out of /dev? Seems like that should
be mounted noexec and it would solve this too. (Though now I wonder
why /dev isn't noexec by default? /dev/pts is noexec...

Regardless, if you wanted to add a "ignore READ_IMPLIES_EXEC" flag to
struct file, maybe this bit could be populated by drivers?

-- 
Kees Cook
