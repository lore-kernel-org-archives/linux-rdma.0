From: Andrey Konovalov <andreyknvl@google.com>
Subject: Re: [PATCH v16 12/16] IB, arm64: untag user pointers in ib_uverbs_(re)reg_mr()
Date: Tue, 4 Jun 2019 14:45:32 +0200
Message-ID: <CAAeHK+xyqwuJyviGhvU7L1wPZQF7Mf9g2vgKSsYmML3fV6NrXg@mail.gmail.com>
References: <cover.1559580831.git.andreyknvl@google.com> <c829f93b19ad6af1b13be8935ce29baa8e58518f.1559580831.git.andreyknvl@google.com>
 <20190603174619.GC11474@ziepe.ca> <CAAeHK+xy-dx4dLDLLj9dRzRNSVG9H5nDPPnjpYF38qKZNNCh_g@mail.gmail.com>
 <20190604122714.GA15385@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190604122714.GA15385@ziepe.ca>
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Linux ARM <linux-arm-kernel@lists.infradead.org>, Linux Memory Management List <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org, linux-rdma@vger.kernel.org, linux-media@vger.kernel.org, kvm@vger.kernel.org, "open list:KERNEL SELFTEST FRAMEWORK" <linux-kselftest@vger.kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, Vincenzo Frascino <vincenzo.frascino@arm.com>, Will Deacon <will.deacon@arm.com>, Mark Rutland <mark.rutland@arm.com>, Andrew Morton <akpm@linux-foundation.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Kees Cook <keescook@chromium.org>, Yishai Hadas <yishaih@mellanox.com>, Felix Kuehling <Felix.Kuehling@amd.com>, Alexander Deucher <Alexander.Deucher@am>
List-Id: linux-rdma@vger.kernel.org

On Tue, Jun 4, 2019 at 2:27 PM Jason Gunthorpe <jgg@ziepe.ca> wrote:
>
> On Tue, Jun 04, 2019 at 02:18:19PM +0200, Andrey Konovalov wrote:
> > On Mon, Jun 3, 2019 at 7:46 PM Jason Gunthorpe <jgg@ziepe.ca> wrote:
> > >
> > > On Mon, Jun 03, 2019 at 06:55:14PM +0200, Andrey Konovalov wrote:
> > > > This patch is a part of a series that extends arm64 kernel ABI to allow to
> > > > pass tagged user pointers (with the top byte set to something else other
> > > > than 0x00) as syscall arguments.
> > > >
> > > > ib_uverbs_(re)reg_mr() use provided user pointers for vma lookups (through
> > > > e.g. mlx4_get_umem_mr()), which can only by done with untagged pointers.
> > > >
> > > > Untag user pointers in these functions.
> > > >
> > > > Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
> > > >  drivers/infiniband/core/uverbs_cmd.c | 4 ++++
> > > >  1 file changed, 4 insertions(+)
> > > >
> > > > diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
> > > > index 5a3a1780ceea..f88ee733e617 100644
> > > > +++ b/drivers/infiniband/core/uverbs_cmd.c
> > > > @@ -709,6 +709,8 @@ static int ib_uverbs_reg_mr(struct uverbs_attr_bundle *attrs)
> > > >       if (ret)
> > > >               return ret;
> > > >
> > > > +     cmd.start = untagged_addr(cmd.start);
> > > > +
> > > >       if ((cmd.start & ~PAGE_MASK) != (cmd.hca_va & ~PAGE_MASK))
> > > >               return -EINVAL;
> > >
> > > I feel like we shouldn't thave to do this here, surely the cmd.start
> > > should flow unmodified to get_user_pages, and gup should untag it?
> > >
> > > ie, this sort of direction for the IB code (this would be a giant
> > > patch, so I didn't have time to write it all, but I think it is much
> > > saner):
> >
> > Hi Jason,
> >
> > ib_uverbs_reg_mr() passes cmd.start to mlx4_get_umem_mr(), which calls
> > find_vma(), which only accepts untagged addresses. Could you explain
> > how your patch helps?
>
> That mlx4 is just a 'weird duck', it is not the normal flow, and I
> don't think the core code should be making special consideration for
> it.

How do you think we should do untagging (or something else) to deal
with this 'weird duck' case?

>
> Jason
