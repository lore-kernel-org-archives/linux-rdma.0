From: Andrey Konovalov <andreyknvl@google.com>
Subject: Re: [PATCH v14 10/17] fs, arm64: untag user pointers in fs/userfaultfd.c
Date: Mon, 6 May 2019 16:15:20 +0200
Message-ID: <CAAeHK+yya4OR7GfSJPc59+trq3fS9Qh_1WK2hB1aoHdR0C_t8Q@mail.gmail.com>
References: <cover.1556630205.git.andreyknvl@google.com> <7d3b28689d47c0fa1b80628f248dbf78548da25f.1556630205.git.andreyknvl@google.com>
 <20190503165646.GK55449@arrakis.emea.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190503165646.GK55449@arrakis.emea.arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Linux ARM <linux-arm-kernel@lists.infradead.org>, Linux Memory Management List <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org, linux-rdma@vger.kernel.org, linux-media@vger.kernel.org, kvm@vger.kernel.org, "open list:KERNEL SELFTEST FRAMEWORK" <linux-kselftest@vger.kernel.org>, Vincenzo Frascino <vincenzo.frascino@arm.com>, Will Deacon <will.deacon@arm.com>, Mark Rutland <mark.rutland@arm.com>, Andrew Morton <akpm@linux-foundation.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Kees Cook <keescook@chromium.org>, Yishai Hadas <yishaih@mellanox.com>, Kuehling@google.com, Felix <Felix.Kuehling@amd.com>, Deucher@google.com, Alexander <Alexander.Deucher@amd.com>, Koenig@google.com
List-Id: linux-rdma@vger.kernel.org

On Fri, May 3, 2019 at 6:56 PM Catalin Marinas <catalin.marinas@arm.com> wrote:
>
> On Tue, Apr 30, 2019 at 03:25:06PM +0200, Andrey Konovalov wrote:
> > This patch is a part of a series that extends arm64 kernel ABI to allow to
> > pass tagged user pointers (with the top byte set to something else other
> > than 0x00) as syscall arguments.
> >
> > userfaultfd_register() and userfaultfd_unregister() use provided user
> > pointers for vma lookups, which can only by done with untagged pointers.
> >
> > Untag user pointers in these functions.
> >
> > Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
> > ---
> >  fs/userfaultfd.c | 5 +++++
> >  1 file changed, 5 insertions(+)
> >
> > diff --git a/fs/userfaultfd.c b/fs/userfaultfd.c
> > index f5de1e726356..fdee0db0e847 100644
> > --- a/fs/userfaultfd.c
> > +++ b/fs/userfaultfd.c
> > @@ -1325,6 +1325,9 @@ static int userfaultfd_register(struct userfaultfd_ctx *ctx,
> >               goto out;
> >       }
> >
> > +     uffdio_register.range.start =
> > +             untagged_addr(uffdio_register.range.start);
> > +
> >       ret = validate_range(mm, uffdio_register.range.start,
> >                            uffdio_register.range.len);
> >       if (ret)
> > @@ -1514,6 +1517,8 @@ static int userfaultfd_unregister(struct userfaultfd_ctx *ctx,
> >       if (copy_from_user(&uffdio_unregister, buf, sizeof(uffdio_unregister)))
> >               goto out;
> >
> > +     uffdio_unregister.start = untagged_addr(uffdio_unregister.start);
> > +
> >       ret = validate_range(mm, uffdio_unregister.start,
> >                            uffdio_unregister.len);
> >       if (ret)
>
> Wouldn't it be easier to do this in validate_range()? There are a few
> more calls in this file, though I didn't check whether a tagged address
> would cause issues.

Yes, I think it makes more sense, will do in v15, thanks!

>
> --
> Catalin
