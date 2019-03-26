From: Dmitry Vyukov <dvyukov@google.com>
Subject: Re: KASAN: use-after-free Read in addr_handler
Date: Tue, 26 Mar 2019 10:56:08 +0100
Message-ID: <CACT4Y+ZLkhCZv+x4Tf2y989JW79Ua9rpC1enmg+h4EXtXSJ0aw@mail.gmail.com>
References: <0000000000001f5bce0584d5b095@google.com> <alpine.DEB.2.21.1903241419510.1798@nanos.tec.linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.21.1903241419510.1798@nanos.tec.linutronix.de>
Sender: netdev-owner@vger.kernel.org
To: Thomas Gleixner <tglx@linutronix.de>
Cc: syzbot <syzbot+b358909d8d01556b790b@syzkaller.appspotmail.com>, Alexander Duyck <alexander.h.duyck@intel.com>, amritha.nambiar@intel.com, andrew@lunn.ch, avagin@gmail.com, danielj@mellanox.com, David Miller <davem@davemloft.net>, Doug Ledford <dledford@redhat.com>, Dmitry Torokhov <dmitry.torokhov@gmail.com>, gregory.clement@bootlin.com, jason@lakedaemon.net, jeffrey.t.kirsher@intel.com, Jason Gunthorpe <jgg@ziepe.ca>, Joe Perches <joe@perches.com>, Leon Romanovsky <leon@kernel.org>, Linux ARM <linux-arm-kernel@lists.infradead.org>, LKML <linux-kernel@vger.kernel.org>, linux-rdma@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, miquel.raynal@bootlin.com, netdev <netdev@vger.kernel.org>, parav@mellanox.com, sebastian.hesselbarth@gmail.com, swise@opengridcomputing.com
List-Id: linux-rdma@vger.kernel.org

On Sun, Mar 24, 2019 at 2:21 PM Thomas Gleixner <tglx@linutronix.de> wrote:
>
> On Sun, 24 Mar 2019, syzbot wrote:
>
> > syzbot has bisected this bug to:
> >
> > commit 4f4c867c91e644fc9d461c8c5cf2f09d6d5bcac2
> > Author: Miquel Raynal <miquel.raynal@bootlin.com>
> > Date:   Tue Oct 2 08:54:16 2018 +0000
> >
> >    irqchip/irq-mvebu-icu: Support ICU subnodes
>
> Yet another bogus bisect result. Why? That code is ARM only and cannot
> influence x86 by any means.

>From the bisection log it seems the process diverged to a different
bug mid way ("WARNING: ODEBUG bug in netdev_freemem").
