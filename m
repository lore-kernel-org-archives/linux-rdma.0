From: syzbot <syzbot+4b628fcc748474003457@syzkaller.appspotmail.com>
Subject: Re: WARNING: bad unlock balance in ucma_destroy_id
Date: Wed, 10 Apr 2019 23:53:01 -0700
Message-ID: <000000000000192b4405863ba337@google.com>
References: <0000000000003b9c4b0574806070@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <0000000000003b9c4b0574806070@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: dledford@redhat.com, haggaie@mellanox.com, hal.rosenstock@gmail.com, jgg@ziepe.ca, leon@kernel.org, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, parav@mellanox.com, raindel@mellanox.com, roland@purestorage.com, sean.hefty@intel.com, swise@opengridcomputing.com, syzkaller-bugs@googlegroups.com, yishaih@mellanox.com
List-Id: linux-rdma@vger.kernel.org

syzbot has bisected this bug to:

commit e1c30298ccab87151a0c4241fc5985c591598361
Author: Yishai Hadas <yishaih@mellanox.com>
Date:   Thu Aug 13 15:32:07 2015 +0000

     IB/ucma: HW Device hot-removal support

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=157538d3200000
start commit:   5b394b2d Linux 4.19-rc1
git tree:       upstream
final crash:    https://syzkaller.appspot.com/x/report.txt?x=177538d3200000
console output: https://syzkaller.appspot.com/x/log.txt?x=137538d3200000
kernel config:  https://syzkaller.appspot.com/x/.config?x=49927b422dcf0b29
dashboard link: https://syzkaller.appspot.com/bug?extid=4b628fcc748474003457
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13351e2e400000

Reported-by: syzbot+4b628fcc748474003457@syzkaller.appspotmail.com
Fixes: e1c30298ccab ("IB/ucma: HW Device hot-removal support")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
