From: Andrey Konovalov <andreyknvl@google.com>
Subject: Re: [PATCH v14 13/17] IB/mlx4, arm64: untag user pointers in mlx4_get_umem_mr
Date: Mon, 6 May 2019 18:21:56 +0200
Message-ID: <CAAeHK+weVYv4Tgj8DXv0ZTFZzGEpLYsn-3wxxmQN+ZW88MXbMw@mail.gmail.com>
References: <cover.1556630205.git.andreyknvl@google.com> <05c0c078b8b5984af4cc3b105a58c711dcd83342.1556630205.git.andreyknvl@google.com>
 <20190503170310.GL55449@arrakis.emea.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190503170310.GL55449@arrakis.emea.arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Linux ARM <linux-arm-kernel@lists.infradead.org>, Linux Memory Management List <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org, linux-rdma@vger.kernel.org, linux-media@vger.kernel.org, kvm@vger.kernel.org, "open list:KERNEL SELFTEST FRAMEWORK" <linux-kselftest@vger.kernel.org>, Vincenzo Frascino <vincenzo.frascino@arm.com>, Will Deacon <will.deacon@arm.com>, Mark Rutland <mark.rutland@arm.com>, Andrew Morton <akpm@linux-foundation.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Kees Cook <keescook@chromium.org>, Yishai Hadas <yishaih@mellanox.com>, Kuehling@google.com, Felix <Felix.Kuehling@amd.com>, Deucher@google.com, Alexander <Alexander.Deucher@amd.com>, Koenig@google.com
List-Id: linux-rdma@vger.kernel.org

On Fri, May 3, 2019 at 7:03 PM Catalin Marinas <catalin.marinas@arm.com> wrote:
>
> On Tue, Apr 30, 2019 at 03:25:09PM +0200, Andrey Konovalov wrote:
> > This patch is a part of a series that extends arm64 kernel ABI to allow to
> > pass tagged user pointers (with the top byte set to something else other
> > than 0x00) as syscall arguments.
> >
> > mlx4_get_umem_mr() uses provided user pointers for vma lookups, which can
> > only by done with untagged pointers.
> >
> > Untag user pointers in this function.
> >
> > Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
> > Reviewed-by: Leon Romanovsky <leonro@mellanox.com>
> > ---
> >  drivers/infiniband/hw/mlx4/mr.c | 7 ++++---
> >  1 file changed, 4 insertions(+), 3 deletions(-)
> >
> > diff --git a/drivers/infiniband/hw/mlx4/mr.c b/drivers/infiniband/hw/mlx4/mr.c
> > index 395379a480cb..9a35ed2c6a6f 100644
> > --- a/drivers/infiniband/hw/mlx4/mr.c
> > +++ b/drivers/infiniband/hw/mlx4/mr.c
> > @@ -378,6 +378,7 @@ static struct ib_umem *mlx4_get_umem_mr(struct ib_udata *udata, u64 start,
> >        * again
> >        */
> >       if (!ib_access_writable(access_flags)) {
> > +             unsigned long untagged_start = untagged_addr(start);
> >               struct vm_area_struct *vma;
> >
> >               down_read(&current->mm->mmap_sem);
> > @@ -386,9 +387,9 @@ static struct ib_umem *mlx4_get_umem_mr(struct ib_udata *udata, u64 start,
> >                * cover the memory, but for now it requires a single vma to
> >                * entirely cover the MR to support RO mappings.
> >                */
> > -             vma = find_vma(current->mm, start);
> > -             if (vma && vma->vm_end >= start + length &&
> > -                 vma->vm_start <= start) {
> > +             vma = find_vma(current->mm, untagged_start);
> > +             if (vma && vma->vm_end >= untagged_start + length &&
> > +                 vma->vm_start <= untagged_start) {
> >                       if (vma->vm_flags & VM_WRITE)
> >                               access_flags |= IB_ACCESS_LOCAL_WRITE;
> >               } else {
>
> Discussion ongoing on the previous version of the patch but I'm more
> inclined to do this in ib_uverbs_(re)reg_mr() on cmd.start.

OK, I want to publish v15 sooner to fix the issue with emails
addresses, so I'll implement this approach there for now.



>
> --
> Catalin
