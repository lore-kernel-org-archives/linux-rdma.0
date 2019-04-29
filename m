From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL] Please pull RDMA subsystem changes
Date: Sun, 28 Apr 2019 17:09:08 -0700
Message-ID: <CAHk-=whWh+5-jGmgw2HPM8XhzXzvGcLo19UGLtqYe_teJsRgRA@mail.gmail.com>
References: <20190428115207.GA11924@ziepe.ca> <CAHk-=wj4ay=jy6wuN4d9p9v+O32i0aH9SMfu39VKP-Ai7hKp=g@mail.gmail.com>
 <20190428234935.GA15233@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190428234935.GA15233@mellanox.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@mellanox.com>
Cc: Doug Ledford <dledford@redhat.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, Apr 28, 2019 at 4:49 PM Jason Gunthorpe <jgg@mellanox.com> wrote:
>
> It is for high availability - we have situations where the hardware
> can fault and needs some kind of destructive recovery. For instance a
> firmware reboot, or a VM migration.
>
> In these designs there may be multiple cards in the system and the
> userspace application could be using both. Just because one card
> crashed we can't send SIGBUS and kill the application, that breaks the
> HA design.

Why can't this magical application that is *so* special that it is HA
and does magic mmap's of special rdma areas just catch the SIGBUS?

Honestly, the whole "it's for HA" excuse stinks. It stinks because you
now silently just replace the mapping with *garbage*. That's not HA,
that's just random.

Wouldn't it be a lot better to just get the SIGBUS, and then that
magical application knows that "oh, it's gone", and it could - in its
SIGBUS handler - just do the dummy anonymous mmap() with /dev/zero it
if it wants to?

Whatever. It really sounds like this is yet another horrible back for
bad interfaces for all these "super-special high-end enterprise
people".

I hope that some day enterprise people will wake up and realize that
"enterprise" seems to be often a code name for "lots of random hacks".

                    Linus
