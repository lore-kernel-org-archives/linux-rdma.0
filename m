From: Roland Dreier <roland@purestorage.com>
Subject: Re: KASAN: use-after-free Read in __list_add_valid (5)
Date: Tue, 15 May 2018 13:49:23 -0700
Message-ID: <CAL1RGDVNaJ8OG+4ajmCZN1GnvsZUAqY3LXMRPv57mGSPJyhwAQ@mail.gmail.com>
References: <089e0825fc78410eaa056845781e@google.com> <20180513230237.GG677@sol.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180513230237.GG677@sol.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
To: Eric Biggers <ebiggers3@gmail.com>
Cc: linux-rdma@vger.kernel.org, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, rds-devel@oss.oracle.com, syzbot <syzbot+db1c219466daac1083df@syzkaller.appspotmail.com>, LKML <linux-kernel@vger.kernel.org>, syzkaller-bugs@googlegroups.com
List-Id: linux-rdma@vger.kernel.org

> Still reproducible on Linus' tree (commit 66e1c94db3cd4e) and on linux-next
> (next-20180511).  Here's a simplified reproducer:

Thanks!  That's a fantastic test case.

The issue is a race where rdma_listen() sees invalid state in the
middle of an rdma_bind_addr() call that will ultimately fail.  I'll
send a proposed patch shortly.

 - R.
