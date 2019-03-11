From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: BUG: MAX_STACK_TRACE_ENTRIES too low!
Date: Mon, 11 Mar 2019 08:19:34 -0700
Message-ID: <1552317574.45180.94.camel@acm.org>
References: <00000000000080952b0583d183f0@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-7"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <00000000000080952b0583d183f0@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: syzbot <syzbot+78923eea7cf44364f4fb@syzkaller.appspotmail.com>, akpm@linux-foundation.org, darrick.wong@oracle.com, dledford@redhat.com, gustavo@embeddedor.com, hch@infradead.org, jannh@google.com, jgg@ziepe.ca, johannes.berg@intel.com, leon@kernel.org, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, linux-xfs@vger.kernel.org, longman@redhat.com, mingo@kernel.org, mingo@redhat.com, paulmck@linux.vnet.ibm.com, peterz@infradead.org, roland@purestorage.com, sean.hefty@intel.com, shamir.rabinovitch@oracle.com, swise@opengridcomputing.com, syzkaller-bugs@googlegroups.com, tglx@linutronix.de, tj@kernel.org, torvalds@linux-foundation.org, will.deacon@arm.com, xiyou.wangcong@gmail.com
List-Id: linux-rdma@vger.kernel.org

On Mon, 2019-03-11 at 06:26 -0700, syzbot wrote:
+AD4 syzbot has bisected this bug to:
+AD4 
+AD4 commit 669de8bda87b92ab9a2fc663b3f5743c2ad1ae9f
+AD4 Author: Bart Van Assche +ADw-bvanassche+AEA-acm.org+AD4
+AD4 Date:   Thu Feb 14 23:00:54 2019 +-0000
+AD4 
+AD4      kernel/workqueue: Use dynamic lockdep keys for workqueues
+AD4 
+AD4 bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x+AD0-17dec757200000
+AD4 start commit:   669de8bd kernel/workqueue: Use dynamic lockdep keys for wo..
+AD4 git tree:       upstream
+AD4 final crash:    https://syzkaller.appspot.com/x/report.txt?x+AD0-143ec757200000
+AD4 console output: https://syzkaller.appspot.com/x/log.txt?x+AD0-103ec757200000
+AD4 kernel config:  https://syzkaller.appspot.com/x/.config?x+AD0-bd349f14600e1305
+AD4 dashboard link: https://syzkaller.appspot.com/bug?extid+AD0-78923eea7cf44364f4fb
+AD4 userspace arch: amd64
+AD4 syz repro:      https://syzkaller.appspot.com/x/repro.syz?x+AD0-149c858d200000
+AD4 C reproducer:   https://syzkaller.appspot.com/x/repro.c?x+AD0-111aee33200000
+AD4 
+AD4 Reported-by: syzbot+-78923eea7cf44364f4fb+AEA-syzkaller.appspotmail.com
+AD4 Fixes: 669de8bd (+ACI-kernel/workqueue: Use dynamic lockdep keys for  
+AD4 workqueues+ACI)

I think this issue has been fixed by a commit that went upstream yesterday. Hence:

+ACM-syz fix: workqueue, lockdep: Fix an alloc+AF8-workqueue() error path
