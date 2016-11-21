From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v5 2/9] IB/core: Replace semaphore sm_sem with an atomic wait
Date: Mon, 21 Nov 2016 17:52:27 +0100
Message-ID: <4374986.OFD8bCgUa1@wuerfel>
References: <1479708496-9828-1-git-send-email-binoy.jayan@linaro.org> <1479708496-9828-3-git-send-email-binoy.jayan@linaro.org> <CA+55aFxGjaqduhRCyk0mVxEA7aqQ-omdG8SBreZ=x5cW2ovngQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CA+55aFxGjaqduhRCyk0mVxEA7aqQ-omdG8SBreZ=x5cW2ovngQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Binoy Jayan <binoy.jayan@linaro.org>, linux-rdma@vger.kernel.org, Mustafa Ismail <mustafa.ismail@intel.com>, Lijun Ou <oulijun@huawei.com>, Nicholas Bellinger <nab@linux-iscsi.org>, Leon Romanovsky <leonro@mellanox.com>, target-devel@vger.kernel.org, Tatyana E Nikolova <tatyana.e.nikolova@intel.com>, Doug Ledford <dledford@redhat.com>, Jenny Derzhavetz <jennyf@mellanox.com>, Sagi Grimberg <sagi@grimberg.me>, Sean Hefty <sean.hefty@intel.com>, Faisal Latif <faisal.latif@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, linux-kernel@vger.kernel.org, "Wei Hu(Xavier)" <xavier.huwei@huawei.com>, Mark Brown <broonie@kernel.org>, Mark Bloch <markb@mellanox.com>, Steve Wise <swise@opengridcomputing.com>, Ira Weiny <ira.weiny@intel.com>
List-Id: linux-rdma@vger.kernel.org

On Monday, November 21, 2016 7:57:53 AM CET Linus Torvalds wrote:
> Don't do this.
> 
> Never ever do your own locking primitives. You will get the memory ordering
> wrong. And even if you get it right, why do it?
> 
> If you want to get rid of semaphores, and replace them with a mutex, that's
> OK. But don't replace them with something more complex like an open coded
> waiting model.

I think a mutex would't work here, since fops->open() and fops->close()
are not called from the same context and lockdep will complain
about that.

Version of the series had replaced the semaphore with a completion
here, which worked correctly, but one reviewer suggested using
the wait_event() instead since it's confusing to have a completion
starting out in 'completed' state.

	Arnd
