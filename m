From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v5 2/9] IB/core: Replace semaphore sm_sem with an atomic wait
Date: Mon, 21 Nov 2016 23:51:36 +0100
Message-ID: <2759800.6ytmLjdbJ3@wuerfel>
References: <1479708496-9828-1-git-send-email-binoy.jayan@linaro.org> <4374986.OFD8bCgUa1@wuerfel> <CA+55aFyd7d+C39ipC5XuZg1gJjJ+HFSgcPQU7Xb26Fsh6Z1_0A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <CA+55aFyd7d+C39ipC5XuZg1gJjJ+HFSgcPQU7Xb26Fsh6Z1_0A@mail.gmail.com>
Sender: target-devel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Binoy Jayan <binoy.jayan@linaro.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, Mustafa Ismail <mustafa.ismail@intel.com>, Lijun Ou <oulijun@huawei.com>, Nicholas Bellinger <nab@linux-iscsi.org>, Leon Romanovsky <leonro@mellanox.com>, target-devel <target-devel@vger.kernel.org>, Tatyana E Nikolova <tatyana.e.nikolova@intel.com>, Doug Ledford <dledford@redhat.com>, Jenny Derzhavetz <jennyf@mellanox.com>, Sagi Grimberg <sagi@grimberg.me>, Sean Hefty <sean.hefty@intel.com>, Faisal Latif <faisal.latif@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "Wei Hu(Xavier)" <xavier.huwei@huawei.com>, Mark Brown <broonie@kernel.org>, Mark Bloch <markb@mellanox.com>, Steve
List-Id: linux-rdma@vger.kernel.org

On Monday, November 21, 2016 9:57:51 AM CET Linus Torvalds wrote:
> 
>  - semaphores are "old-fashioned mutexes". A mutex is better than a
> semaphore, but a semaphore is better than just about all the other
> alternatives. There's nothing _wrong_ with using a semaphore per se.
> 
> In this case, either use a semaphore or a mutex. If you are doing
> mutual exclusion, those are really the only two acceptable sleeping
> models.

The main problem with semaphores is that they are slowly spreading
into areas that really should be mutexes or completions. A couple
of years ago, we had only around 30 semaphores left in the kernel
and while a lot of those have been removed in the meantime, over
100 new ones have come in, the majority of them in the category
that can be trivially converted to a mutex or semaphore.

This in turn is not much of a problem, except to a certain degree
for preempt-rt users.

I suggested to Binoy that he could look into replacing the existing
semaphores one subsystem at a time under the assumption that we
could find a relatively easy alternative for every one of them
and then remove the implementation completely.

Christoph's suggestion is probably more productive here: let's
remove the ones that are obviously wrong or inferior, and only
once they have been taken care of we can look into whether it's
worth doing something about the rest or not.

	Arnd
