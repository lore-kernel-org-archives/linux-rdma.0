From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 6/8] IB/hns: Replace counting semaphore event_sem with wait condition
Date: Wed, 19 Oct 2016 17:15:10 +0200
Message-ID: <4225681.X40Xeo72dr@wuerfel>
References: <1476721862-7070-1-git-send-email-binoy.jayan@linaro.org> <5900385.6T4BAIyXjD@wuerfel> <CAHv-k__KG4wZ+dCEALRjw1U_eS2eQA63Qy=mzFjXD5SqFz85ew@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAHv-k__KG4wZ+dCEALRjw1U_eS2eQA63Qy=mzFjXD5SqFz85ew@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Binoy Jayan <binoy.jayan@linaro.org>
Cc: Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org, Linux kernel mailing list <linux-kernel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Tuesday, October 18, 2016 10:46:45 AM CEST Binoy Jayan wrote:
> Thank you for replying for the questions. I''ll look for alternatives
> for patches 6,7 and 8 and resend the series.

Ok, thanks!

I also looked at patch 8 some more and noticed that those four
functions all do the exact same sequence:

- initialize a mlx5_ib_umr_context on the stack
- assign "umrwr.wr.wr_cqe = &umr_context.cqe"
- take the semaphore
- call ib_post_send with a single ib_send_wr
- wait for the mlx5_ib_umr_done() function to get called
- if we get back a failure, print a warning and return -EFAULT.
- release the semaphore

Moving all of these into a shared helper function would be
a good cleanup, and it leaves only a single function using
the semaphore, which can then be rewritten to use something
else.

The existing completion in there can be simplified to a
wait_event, since we are waiting for the return value to
be filled.

	Arnd
