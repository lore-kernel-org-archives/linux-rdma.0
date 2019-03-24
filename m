From: syzbot <syzbot+b358909d8d01556b790b@syzkaller.appspotmail.com>
Subject: Re: KASAN: use-after-free Read in addr_handler
Date: Sun, 24 Mar 2019 04:50:01 -0700
Message-ID: <0000000000001f5bce0584d5b095@google.com>
References: <00000000000055ee31057ce8f277@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <00000000000055ee31057ce8f277@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: alexander.h.duyck@intel.com, amritha.nambiar@intel.com, andrew@lunn.ch, avagin@gmail.com, danielj@mellanox.com, davem@davemloft.net, dledford@redhat.com, dmitry.torokhov@gmail.com, gregory.clement@bootlin.com, jason@lakedaemon.net, jeffrey.t.kirsher@intel.com, jgg@ziepe.ca, joe@perches.com, leon@kernel.org, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, marc.zyngier@arm.com, miquel.raynal@bootlin.com, netdev@vger.kernel.org, parav@mellanox.com, sebastian.hesselbarth@gmail.com, swise@opengridcomputing.com, syzkaller-bugs@googlegroups.com, tglx@linutronix.de, tyhicks@canonical.com
List-Id: linux-rdma@vger.kernel.org

syzbot has bisected this bug to:

commit 4f4c867c91e644fc9d461c8c5cf2f09d6d5bcac2
Author: Miquel Raynal <miquel.raynal@bootlin.com>
Date:   Tue Oct 2 08:54:16 2018 +0000

     irqchip/irq-mvebu-icu: Support ICU subnodes

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=163319df200000
start commit:   a3b22b9f Linux 5.0-rc7
git tree:       upstream
final crash:    https://syzkaller.appspot.com/x/report.txt?x=153319df200000
console output: https://syzkaller.appspot.com/x/log.txt?x=113319df200000
kernel config:  https://syzkaller.appspot.com/x/.config?x=7132344728e7ec3f
dashboard link: https://syzkaller.appspot.com/bug?extid=b358909d8d01556b790b
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1493d4d0c00000

Reported-by: syzbot+b358909d8d01556b790b@syzkaller.appspotmail.com
Fixes: 4f4c867c91e6 ("irqchip/irq-mvebu-icu: Support ICU subnodes")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
