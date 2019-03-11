From: syzbot <syzbot+78923eea7cf44364f4fb@syzkaller.appspotmail.com>
Subject: Re: BUG: MAX_STACK_TRACE_ENTRIES too low!
Date: Mon, 11 Mar 2019 06:26:01 -0700
Message-ID: <00000000000080952b0583d183f0@google.com>
References: <000000000000299b190583172880@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <000000000000299b190583172880@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: akpm@linux-foundation.org, bvanassche@acm.org, darrick.wong@oracle.com, dledford@redhat.com, gustavo@embeddedor.com, hch@infradead.org, jannh@google.com, jgg@ziepe.ca, johannes.berg@intel.com, leon@kernel.org, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, linux-xfs@vger.kernel.org, longman@redhat.com, mingo@kernel.org, mingo@redhat.com, paulmck@linux.vnet.ibm.com, peterz@infradead.org, roland@purestorage.com, sean.hefty@intel.com, shamir.rabinovitch@oracle.com, swise@opengridcomputing.com, syzkaller-bugs@googlegroups.com, tglx@linutronix.de, tj@kernel.org, torvalds@linux-foundation.org, will.deacon@arm.com, xiyou.wangcong@gmail.com
List-Id: linux-rdma@vger.kernel.org

syzbot has bisected this bug to:

commit 669de8bda87b92ab9a2fc663b3f5743c2ad1ae9f
Author: Bart Van Assche <bvanassche@acm.org>
Date:   Thu Feb 14 23:00:54 2019 +0000

     kernel/workqueue: Use dynamic lockdep keys for workqueues

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=17dec757200000
start commit:   669de8bd kernel/workqueue: Use dynamic lockdep keys for wo..
git tree:       upstream
final crash:    https://syzkaller.appspot.com/x/report.txt?x=143ec757200000
console output: https://syzkaller.appspot.com/x/log.txt?x=103ec757200000
kernel config:  https://syzkaller.appspot.com/x/.config?x=bd349f14600e1305
dashboard link: https://syzkaller.appspot.com/bug?extid=78923eea7cf44364f4fb
userspace arch: amd64
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=149c858d200000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=111aee33200000

Reported-by: syzbot+78923eea7cf44364f4fb@syzkaller.appspotmail.com
Fixes: 669de8bd ("kernel/workqueue: Use dynamic lockdep keys for  
workqueues")
