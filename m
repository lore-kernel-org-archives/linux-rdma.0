From: Cong Wang <xiyou.wangcong@gmail.com>
Subject: Re: [PATCH] infiniband: fix a subtle race condition
Date: Thu, 14 Jun 2018 16:14:13 -0700
Message-ID: <CAM_iQpXFmqcCQWkyGPmev5LrPpDoEc=wpXQVDWJx2UQWPhwb2g@mail.gmail.com>
References: <20180613234947.15767-1-xiyou.wangcong@gmail.com>
 <20180614053446.GB18426@mtr-leonro.mtl.com> <CAM_iQpXxHk+yFqqK-Hezsc83_mKfbUXr4=jjNnik5DwGscRKUA@mail.gmail.com>
 <20180614070108.GD18426@mtr-leonro.mtl.com> <20180614142448.GC24762@mellanox.com>
 <CAM_iQpWz9b01ksW_OUHgr1=pf-bNsq_TxoNCQxuDdhUXfvoyOQ@mail.gmail.com> <20180614172441.GE24762@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180614172441.GE24762@mellanox.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leon@kernel.org>, LKML <linux-kernel@vger.kernel.org>, linux-rdma@vger.kernel.org, Doug Ledford <dledford@redhat.com>
List-Id: linux-rdma@vger.kernel.org

On Thu, Jun 14, 2018 at 10:24 AM, Jason Gunthorpe <jgg@mellanox.com> wrote:
> On Thu, Jun 14, 2018 at 10:03:09AM -0700, Cong Wang wrote:
>> On Thu, Jun 14, 2018 at 7:24 AM, Jason Gunthorpe <jgg@mellanox.com> wrote:
>> >
>> > This was my brief reaction too, this code path almost certainly has a
>> > use-after-free, and we should fix the concurrency between the two
>> > places in some correct way..
>>
>> First of all, why use-after-free could trigger an imbalance unlock?
>> IOW, why do we have to solve use-after-free to fix this imbalance
>> unlock?
>
> The issue syzkaller hit is that accessing ctx->file does not seem
> locked in any way and can race with other manipulations of ctx->file.
>
> So.. for this patch to be correct we need to understand how this
> statement:
>
>    f = ctx->file
>
> Avoids f becoming a dangling pointer - and without locking, my


It doesn't, because this is not the point, this is not the cause
of the unlock imbalance either. syzbot didn't report use-after-free
or a kernel segfault here.


> suspicion is that it doesn't - because missing locking around
> ctx->file is probably the actual bug syzkaller found.

Does my patch make it lockless or dangling? Apparently no.

Before my patch:

        mutex_lock(&ctx->file->mut);

After my patch:

        cur_file = ctx->file;
        mutex_lock(&cur_file->mut);

The deference is same as before, it was lockless and it is lockless
after my patch.

Look at the assembly code *without* my patch:

ffffffff819354f0:       49 8b 7c 24 78          mov    0x78(%r12),%rdi
ffffffff819354f5:       48 89 c3                mov    %rax,%rbx
ffffffff819354f8:       31 f6                   xor    %esi,%esi
ffffffff819354fa:       e8 d8 dd 40 00          callq
ffffffff81d432d7 <mutex_lock_nested>

Apparently the pointer is dereferenced before lock.

What difference does my patch make?

ffffffff819354f2:       4d 8b 74 24 78          mov    0x78(%r12),%r14
ffffffff819354f7:       48 89 c3                mov    %rax,%rbx
ffffffff819354fa:       31 f6                   xor    %esi,%esi
ffffffff819354fc:       4c 89 f7                mov    %r14,%rdi
ffffffff819354ff:       e8 9b df 40 00          callq
ffffffff81d4349f <mutex_lock_nested>
...
ffffffff8193567d:       4c 89 f7                mov    %r14,%rdi
ffffffff81935680:       e8 98 dd 40 00          callq
ffffffff81d4341d <mutex_unlock>


The %r14 here is the whole point of my patch.


>
> If this is not the case, then add a comment explaining how f's
> lifetime is OK.
>
> Otherwise, we need some kind of locking and guessing we need to hold a
> kref for f?


I agree with you, but again, this is not necessary for unlock
imbalance.


>
>> Third of all, the use-after-free I can see (race with ->close) exists
>> before my patch, this patch doesn't make it better or worse, nor
>> I have any intend to fix it.
>
> I'm not sure that race exists, there should be something that flushes
> the WQ on the path to close... (though I have another email that
> perhaps that is broken, sigh)
>

This is not related to my patch, but to convince you, let me explain:

struct ucma_file is not refcnt'ed, I know you cancel the work in
rdma_destroy_id(), but after ucma_migrate_id() the ctx has already
been moved to the new file, for the old file, it won't cancel the
ctx flying with workqueue. So, I think the following use-after-free
could happen:


ucma_event_handler():
cur_file = ctx->file; // old file

ucma_migrate_id():
lock();
list_move_tail(&ctx->list, &new_file->ctx_list);
ctx->file = new_file;
unlock();

ucma_close():
// retrieve old file via filp->private_data
// the loop won't cover the ctx moved to the new_file
kfree(file);

ucma_event_handler():
// continued from above
lock(&cur_file->mux); // already freed!


This is _not_ the cause of the unlock imbalance, and is _not_ expected
to solve by patch either.
