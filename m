From: Andrey Konovalov <andreyknvl@google.com>
Subject: Re: [PATCH v16 04/16] mm: untag user pointers in do_pages_move
Date: Wed, 12 Jun 2019 13:08:35 +0200
Message-ID: <CAAeHK+yTmU9Vz0OB4b7bcgjU3W1v6NFxgpiy4tud7j0AHXkwtw@mail.gmail.com>
References: <cover.1559580831.git.andreyknvl@google.com> <e410843d00a4ecd7e525a7a949e605ffc6c394c4.1559580831.git.andreyknvl@google.com>
 <d0dffcf8-d7bf-a7b4-5766-3a6f87437851@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <d0dffcf8-d7bf-a7b4-5766-3a6f87437851@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Khalid Aziz <khalid.aziz@oracle.com>
Cc: Linux ARM <linux-arm-kernel@lists.infradead.org>, Linux Memory Management List <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org, linux-rdma@vger.kernel.org, linux-media@vger.kernel.org, kvm@vger.kernel.org, "open list:KERNEL SELFTEST FRAMEWORK" <linux-kselftest@vger.kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, Vincenzo Frascino <vincenzo.frascino@arm.com>, Will Deacon <will.deacon@arm.com>, Mark Rutland <mark.rutland@arm.com>, Andrew Morton <akpm@linux-foundation.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Kees Cook <keescook@chromium.org>, Yishai Hadas <yishaih@mellanox.com>, Felix Kuehling <Felix.Kuehling@amd.com>, Alexander Deucher <Alexander.Deucher@am>
List-Id: linux-rdma@vger.kernel.org

On Tue, Jun 11, 2019 at 10:18 PM Khalid Aziz <khalid.aziz@oracle.com> wrote:
>
> On 6/3/19 10:55 AM, Andrey Konovalov wrote:
> > This patch is a part of a series that extends arm64 kernel ABI to allow to
> > pass tagged user pointers (with the top byte set to something else other
> > than 0x00) as syscall arguments.
> >
> > do_pages_move() is used in the implementation of the move_pages syscall.
> >
> > Untag user pointers in this function.
> >
> > Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
> > Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
> > ---
> >  mm/migrate.c | 1 +
> >  1 file changed, 1 insertion(+)
> >
> > diff --git a/mm/migrate.c b/mm/migrate.c
> > index f2ecc2855a12..3930bb6fa656 100644
> > --- a/mm/migrate.c
> > +++ b/mm/migrate.c
> > @@ -1617,6 +1617,7 @@ static int do_pages_move(struct mm_struct *mm, nodemask_t task_nodes,
> >               if (get_user(node, nodes + i))
> >                       goto out_flush;
> >               addr = (unsigned long)p;
> > +             addr = untagged_addr(addr);
>
> Why not just "addr = (unsigned long)untagged_addr(p);"

Will do in the next version. I think I'll also merge this commit into
the "untag user pointers passed to memory syscalls" one.

>
> --
> Khalid
>
