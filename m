From: Dmitry Vyukov <dvyukov@google.com>
Subject: Re: KASAN: use-after-free Read in __list_add_valid (5)
Date: Wed, 20 Feb 2019 16:42:47 +0100
Message-ID: <CACT4Y+bm_nO=+Jzwr=d0j1u9F59BJB9fu8_5pY9n5ia4fU+y+A@mail.gmail.com>
References: <089e0825fc78410eaa056845781e@google.com> <20180513230237.GG677@sol.localdomain>
 <CAL1RGDVNaJ8OG+4ajmCZN1GnvsZUAqY3LXMRPv57mGSPJyhwAQ@mail.gmail.com> <20180704232629.GJ725@sol.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180704232629.GJ725@sol.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
To: Eric Biggers <ebiggers3@gmail.com>
Cc: Roland Dreier <roland@purestorage.com>, linux-rdma@vger.kernel.org, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, rds-devel@oss.oracle.com, syzbot <syzbot+db1c219466daac1083df@syzkaller.appspotmail.com>, LKML <linux-kernel@vger.kernel.org>, syzkaller-bugs <syzkaller-bugs@googlegroups.com>
List-Id: linux-rdma@vger.kernel.org

On Thu, Jul 5, 2018 at 1:26 AM Eric Biggers <ebiggers3@gmail.com> wrote:
>
> On Tue, May 15, 2018 at 01:49:23PM -0700, Roland Dreier wrote:
> > > Still reproducible on Linus' tree (commit 66e1c94db3cd4e) and on linux-next
> > > (next-20180511).  Here's a simplified reproducer:
> >
> > Thanks!  That's a fantastic test case.
> >
> > The issue is a race where rdma_listen() sees invalid state in the
> > middle of an rdma_bind_addr() call that will ultimately fail.  I'll
> > send a proposed patch shortly.
> >
> >  - R.
>
> Ping; there's still no fix merged for this.  The reproducer also works as an
> unprivileged user.

I don't see any patch similar to the tested one being merged. But this
stopped happening, so let's do:

#syz fix: ucma: fix a use-after-free in ucma_resolve_ip()
