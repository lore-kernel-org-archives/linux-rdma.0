From: Eric Biggers <ebiggers3@gmail.com>
Subject: Re: KASAN: use-after-free Read in __list_add_valid (5)
Date: Wed, 4 Jul 2018 16:26:29 -0700
Message-ID: <20180704232629.GJ725@sol.localdomain>
References: <089e0825fc78410eaa056845781e@google.com>
 <20180513230237.GG677@sol.localdomain>
 <CAL1RGDVNaJ8OG+4ajmCZN1GnvsZUAqY3LXMRPv57mGSPJyhwAQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAL1RGDVNaJ8OG+4ajmCZN1GnvsZUAqY3LXMRPv57mGSPJyhwAQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Roland Dreier <roland@purestorage.com>
Cc: linux-rdma@vger.kernel.org, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, rds-devel@oss.oracle.com, syzbot <syzbot+db1c219466daac1083df@syzkaller.appspotmail.com>, LKML <linux-kernel@vger.kernel.org>, syzkaller-bugs@googlegroups.com
List-Id: linux-rdma@vger.kernel.org

On Tue, May 15, 2018 at 01:49:23PM -0700, Roland Dreier wrote:
> > Still reproducible on Linus' tree (commit 66e1c94db3cd4e) and on linux-next
> > (next-20180511).  Here's a simplified reproducer:
> 
> Thanks!  That's a fantastic test case.
> 
> The issue is a race where rdma_listen() sees invalid state in the
> middle of an rdma_bind_addr() call that will ultimately fail.  I'll
> send a proposed patch shortly.
> 
>  - R.

Ping; there's still no fix merged for this.  The reproducer also works as an
unprivileged user.

- Eric
