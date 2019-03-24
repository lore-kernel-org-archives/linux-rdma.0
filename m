From: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: KASAN: use-after-free Read in addr_handler
Date: Sun, 24 Mar 2019 14:20:47 +0100 (CET)
Message-ID: <alpine.DEB.2.21.1903241419510.1798@nanos.tec.linutronix.de>
References: <0000000000001f5bce0584d5b095@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <0000000000001f5bce0584d5b095@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: syzbot <syzbot+b358909d8d01556b790b@syzkaller.appspotmail.com>
Cc: alexander.h.duyck@intel.com, amritha.nambiar@intel.com, andrew@lunn.ch, avagin@gmail.com, danielj@mellanox.com, davem@davemloft.net, dledford@redhat.com, dmitry.torokhov@gmail.com, gregory.clement@bootlin.com, jason@lakedaemon.net, jeffrey.t.kirsher@intel.com, jgg@ziepe.ca, joe@perches.com, leon@kernel.org, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, marc.zyngier@arm.com, miquel.raynal@bootlin.com, netdev@vger.kernel.org, parav@mellanox.com, sebastian.hesselbarth@gmail.com, swise@opengridcomputing.com, syzkaller-bugs@googlegroups.com, tyhicks@canonical.com
List-Id: linux-rdma@vger.kernel.org

On Sun, 24 Mar 2019, syzbot wrote:

> syzbot has bisected this bug to:
> 
> commit 4f4c867c91e644fc9d461c8c5cf2f09d6d5bcac2
> Author: Miquel Raynal <miquel.raynal@bootlin.com>
> Date:   Tue Oct 2 08:54:16 2018 +0000
> 
>    irqchip/irq-mvebu-icu: Support ICU subnodes

Yet another bogus bisect result. Why? That code is ARM only and cannot
influence x86 by any means.

Thanks,

	tglx
