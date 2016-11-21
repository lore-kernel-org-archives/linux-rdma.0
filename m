From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH v5 2/9] IB/core: Replace semaphore sm_sem with an atomic wait
Date: Mon, 21 Nov 2016 09:57:51 -0800
Message-ID: <CA+55aFyd7d+C39ipC5XuZg1gJjJ+HFSgcPQU7Xb26Fsh6Z1_0A@mail.gmail.com>
References: <1479708496-9828-1-git-send-email-binoy.jayan@linaro.org>
 <1479708496-9828-3-git-send-email-binoy.jayan@linaro.org> <CA+55aFxGjaqduhRCyk0mVxEA7aqQ-omdG8SBreZ=x5cW2ovngQ@mail.gmail.com>
 <4374986.OFD8bCgUa1@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4374986.OFD8bCgUa1@wuerfel>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: Binoy Jayan <binoy.jayan@linaro.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, Mustafa Ismail <mustafa.ismail@intel.com>, Lijun Ou <oulijun@huawei.com>, Nicholas Bellinger <nab@linux-iscsi.org>, Leon Romanovsky <leonro@mellanox.com>, target-devel <target-devel@vger.kernel.org>, Tatyana E Nikolova <tatyana.e.nikolova@intel.com>, Doug Ledford <dledford@redhat.com>, Jenny Derzhavetz <jennyf@mellanox.com>, Sagi Grimberg <sagi@grimberg.me>, Sean Hefty <sean.hefty@intel.com>, Faisal Latif <faisal.latif@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "Wei Hu(Xavier)" <xavier.huwei@huawei.com>, Mark Brown <broonie@kernel.org>, Mark Bloch <markb@mellanox.com>, Steve
List-Id: linux-rdma@vger.kernel.org

On Mon, Nov 21, 2016 at 8:52 AM, Arnd Bergmann <arnd@arndb.de> wrote:
>
> Version of the series had replaced the semaphore with a completion
> here, which worked correctly, but one reviewer suggested using
> the wait_event() instead since it's confusing to have a completion
> starting out in 'completed' state.

Quite frankly, in that case just keep it as a semaphore.

So we have a few cases:

 - completions are *slow*.

   They are designed to be entirely synchronous, exactly so that you
can wait for a completion to finish, and then immediately free the
memory that the completion is in.

 - completions used fro mutual exclusion are *confusing*.

   Yes, they end up working as a counting semaphore, and yes, that's
by design, but at the same time, they are not _meant_ to be used as a
semaphore. The name matters. They are meant to be used the way they
are named: to be a "I'm done now" event. Don't use them for anything
else, because you *will* be confusing everybody else.

 - open-coding wait-queues are really fragile and are *not* meant for exclusion.

   They don't have lockdep checking, but more importantly, people
always invariably get the memory ordering wrong. And by "wrong" I mean
both "doesn't work" (because of insufficient memory ordering) and
"slow" (due to excessive memory ordering).

 - mutexes are good for exclusion.

   mutexes are both high-performance and non-confusing. Yes, they get
lockdep warnings, but that's usually a *good* thing. If you get
lockdep warnings from mutex use, you're almost certainly doing
something iffy.

   mutexes do have a subtle downside: exactly because they are fast,
they are not entirely synchronous. You can't use them for completion
style notifications if you are going to release the memory they are
allocated in.

   So mutexes need to be either statically allocated, or in
reference-counted allocations. That's so that the lifetime of the
memory is guaranteed to be cover all the users (including the wakers).

 - semaphores are "old-fashioned mutexes". A mutex is better than a
semaphore, but a semaphore is better than just about all the other
alternatives. There's nothing _wrong_ with using a semaphore per se.

In this case, either use a semaphore or a mutex. If you are doing
mutual exclusion, those are really the only two acceptable sleeping
models.

                Linus
