From: syzbot <syzbot+e1628a5e87492e6f1b76@syzkaller.appspotmail.com>
Subject: Re: INFO: trying to register non-static key in icmp_send
Date: Sat, 23 Mar 2019 18:25:00 -0700
Message-ID: <000000000000e560fa0584ccf44d@google.com>
References: <0000000000007cd20e05809c2f96@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <0000000000007cd20e05809c2f96@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: davem@davemloft.net, dledford@redhat.com, jgg@ziepe.ca, kuznet@ms2.inr.ac.ru, kvalo@codeaurora.org, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, monis@mellanox.com, netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com, yoshfuji@linux-ipv6.org
List-Id: linux-rdma@vger.kernel.org

syzbot has bisected this bug to:

commit abd5f00844ec7fa507064ee4a22b3605c64c7d31
Author: Kalle Valo <kvalo@codeaurora.org>
Date:   Tue Mar 27 07:06:18 2018 +0000

     Merge ath-next from  
git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=12f9389b200000
start commit:   4aa9fc2a Revert "mm, memory_hotplug: initialize struct pag..
git tree:       upstream
final crash:    https://syzkaller.appspot.com/x/report.txt?x=11f9389b200000
console output: https://syzkaller.appspot.com/x/log.txt?x=16f9389b200000
kernel config:  https://syzkaller.appspot.com/x/.config?x=4fceea9e2d99ac20
dashboard link: https://syzkaller.appspot.com/bug?extid=e1628a5e87492e6f1b76
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=175c96ef400000

Reported-by: syzbot+e1628a5e87492e6f1b76@syzkaller.appspotmail.com
Fixes: abd5f00844ec ("Merge ath-next from  
git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
