From: Cong Wang <xiyou.wangcong@gmail.com>
Subject: Re: [PATCH] infiniband: fix a subtle race condition
Date: Thu, 14 Jun 2018 09:57:12 -0700
Message-ID: <CAM_iQpUkAsNFSK4F7AtKsgtk91H4Wu3nBdeWjb2r60yWuO6Q3g@mail.gmail.com>
References: <20180613234947.15767-1-xiyou.wangcong@gmail.com>
 <20180614053446.GB18426@mtr-leonro.mtl.com> <CAM_iQpXxHk+yFqqK-Hezsc83_mKfbUXr4=jjNnik5DwGscRKUA@mail.gmail.com>
 <20180614070108.GD18426@mtr-leonro.mtl.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180614070108.GD18426@mtr-leonro.mtl.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-rdma@vger.kernel.org, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

On Thu, Jun 14, 2018 at 12:01 AM, Leon Romanovsky <leon@kernel.org> wrote:
> On Wed, Jun 13, 2018 at 11:21:54PM -0700, Cong Wang wrote:
>> On Wed, Jun 13, 2018 at 10:34 PM, Leon Romanovsky <leon@kernel.org> wrote:
>> >
>> > Hi Cong,
>> >
>> > If the compiler optimizes the first line (mutex_lock) as you wrote,
>> > it will reuse "f" for the second line (mutex_unlock) too.
>>
>> Nope, check the assembly if you don't trust me, at least
>> my compiler always fetches ctx->file without this patch.
>>
>> I can show you the assembly code tomorrow (too late to
>> access my dev machine now).
>
> I trust you, so don't need to check it however wanted to emphasize
> that your solution is compiler specific and not universally true.

So are you saying even with my patch compiler could still re-fetch
ctx->file? I doubt...


>
>>
>>
>> >
>> > You need to ensure that ucma_modify_id() doesn't run in parallel to
>> > anything that uses "ctx->file" directly and indirectly.
>> >
>>
>> Talk is easy, show me the code. :) I knew there is probably
>> some other race with this code even after my patch, possibly with
>> ->close() for example, but for this specific unlock warning, this patch
>> is sufficient. I can't solve all the races in one patch.
>
> We do prefer complete solution once the problem is fully understood.
>

The unlock imbalance problem is fully understood and is clearly shown
in my changelog.

My patch never intends to solve any other problem except this one.


> It looks like you are one step away from final patch. It will be conversion
> of mutex to be rwlock and separating between read (almost in all places)
> and write (in ucma_migrate_id) paths.
>

Excuse me. How does this even solve the imbalance problem?

f = ctx->file;
                        ucma_lock_files(f, new_file); // write sem
                        ctx->file = new_file
                        ucma_lock_files(f, new_file); // write sem
down_read(&f->rw); // still the old file, nothing change
f = ctx->file; // new file
up_read(&f->rw); // still imbalance
