From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: BUG: MAX_STACK_TRACE_ENTRIES too low!
Date: Mon, 11 Mar 2019 10:48:07 -0700
Message-ID: <CAHk-=wh_H+Wce_n8vW68ZzoSs3m=exP+kKZZZRCxAfi6dG2_Mg@mail.gmail.com>
References: <00000000000080952b0583d183f0@google.com> <1552317574.45180.94.camel@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1552317574.45180.94.camel@acm.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: syzbot <syzbot+78923eea7cf44364f4fb@syzkaller.appspotmail.com>, Andrew Morton <akpm@linux-foundation.org>, "Darrick J. Wong" <darrick.wong@oracle.com>, dledford@redhat.com, "Gustavo A. R. Silva" <gustavo@embeddedor.com>, Christoph Hellwig <hch@infradead.org>, Jann Horn <jannh@google.com>, Jason Gunthorpe <jgg@ziepe.ca>, johannes.berg@intel.com, leon@kernel.org, Linux List Kernel Mailing <linux-kernel@vger.kernel.org>, linux-rdma@vger.kernel.org, linux-xfs@vger.kernel.org, Waiman Long <longman@redhat.com>, Ingo Molnar <mingo@kernel.org>, Ingo Molnar <mingo@redhat.com>, Paul McKenney <paulmck@linux.vnet.ibm.com>, Peter Zijlstra <peterz@infradead.org>, roland@purestorage.com, sean.hefty@intel.com, shamir.rabinovitch@oracle.com, swise@opengridcomputing.com, syzkaller-bugs@googl
List-Id: linux-rdma@vger.kernel.org

On Mon, Mar 11, 2019 at 8:19 AM Bart Van Assche <bvanassche@acm.org> wrote:
>
> I think this issue has been fixed by a commit that went upstream yesterday. Hence:
>
> #syz fix: workqueue, lockdep: Fix an alloc_workqueue() error path

Well, syzbot just reported a problem with that fix itself ("WARNING in
lockdep_unregister_key").

Looks like now the lockdep_unregister_key() cleanup might be called
even when the lockdep map was never initialized at all in that error
case. Hmm?

I _think_ you need to split that "err_free_wq" label into "just free
the wq" and "unregister lockdep and free wq".

But I didn't look any more closely, I might be misreading things.

                Linus
