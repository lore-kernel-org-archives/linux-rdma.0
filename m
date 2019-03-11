From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: BUG: MAX_STACK_TRACE_ENTRIES too low!
Date: Mon, 11 Mar 2019 11:17:19 -0700
Message-ID: <1552328239.45180.101.camel@acm.org>
References: <00000000000080952b0583d183f0@google.com>
         <1552317574.45180.94.camel@acm.org>
         <CAHk-=wh_H+Wce_n8vW68ZzoSs3m=exP+kKZZZRCxAfi6dG2_Mg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-7"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAHk-=wh_H+Wce_n8vW68ZzoSs3m=exP+kKZZZRCxAfi6dG2_Mg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: syzbot <syzbot+78923eea7cf44364f4fb@syzkaller.appspotmail.com>, Andrew Morton <akpm@linux-foundation.org>, "Darrick J. Wong" <darrick.wong@oracle.com>, dledford@redhat.com, "Gustavo A. R. Silva" <gustavo@embeddedor.com>, Christoph Hellwig <hch@infradead.org>, Jann Horn <jannh@google.com>, Jason Gunthorpe <jgg@ziepe.ca>, johannes.berg@intel.com, leon@kernel.org, Linux List Kernel Mailing <linux-kernel@vger.kernel.org>, linux-rdma@vger.kernel.org, linux-xfs@vger.kernel.org, Waiman Long <longman@redhat.com>, Ingo Molnar <mingo@kernel.org>, Ingo Molnar <mingo@redhat.com>, Paul McKenney <paulmck@linux.vnet.ibm.com>, Peter Zijlstra <peterz@infradead.org>, roland@purestorage.com, sean.hefty@intel.com, shamir.rabinovitch@oracle.com, swise@opengridcomputing.com, syzkaller-bugs@googl
List-Id: linux-rdma@vger.kernel.org

On Mon, 2019-03-11 at 10:48 -0700, Linus Torvalds wrote:
+AD4 On Mon, Mar 11, 2019 at 8:19 AM Bart Van Assche +ADw-bvanassche+AEA-acm.org+AD4 wrote:
+AD4 +AD4 
+AD4 +AD4 I think this issue has been fixed by a commit that went upstream yesterday. Hence:
+AD4 +AD4 
+AD4 +AD4 +ACM-syz fix: workqueue, lockdep: Fix an alloc+AF8-workqueue() error path
+AD4 
+AD4 Well, syzbot just reported a problem with that fix itself (+ACI-WARNING in
+AD4 lockdep+AF8-unregister+AF8-key+ACI).
+AD4 
+AD4 Looks like now the lockdep+AF8-unregister+AF8-key() cleanup might be called
+AD4 even when the lockdep map was never initialized at all in that error
+AD4 case. Hmm?
+AD4 
+AD4 I +AF8-think+AF8 you need to split that +ACI-err+AF8-free+AF8-wq+ACI label into +ACI-just free
+AD4 the wq+ACI and +ACI-unregister lockdep and free wq+ACI.
+AD4 
+AD4 But I didn't look any more closely, I might be misreading things.

Hi Linus,

>From the console output of the syzbot bug report at the start of this
e-mail thread:

WARNING: CPU: 1 PID: 7649 at kernel/locking/lockdep.c:747 register+AF8-lock+AF8-class+-0x10de/0x2220

On line 747 in lockdep.c there is the following warning statement:

			WARN+AF8-ON+AF8-ONCE(class-+AD4-name +ACEAPQ lock-+AD4-name)+ADs

My interpretation is that this means that a lockdep key got reregistered
without unregistration between the two registration calls. That's why I
posted my +ACIAIw-syz fix: workqueue, lockdep: Fix an alloc+AF8-workqueue() error
path+ACI reply.

The latest syzbot complaint is different. In the console output of the latest
report I found the following:

WARNING: CPU: 1 PID: 6970 at kernel/locking/lockdep.c:4925 lockdep+AF8-unregister+AF8-key+-0x21c/0x4e0

On line 4925 there is the following warning statement:

	WARN+AF8-ON+AF8-ONCE(+ACE-found)+ADs

In other words, lockdep+AF8-unregister+AF8-key() got called for a key that was never
registered.

I agree with your conclusion that the err+AF8-free+AF8-wq label needs to be split. I
will post a patch that realizes this.

Bart.
