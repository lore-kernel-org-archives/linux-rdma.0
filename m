From: syzbot <syzbot+4b4f8163c2e246df3c4c@syzkaller.appspotmail.com>
Subject: Re: general protection fault in rds_recv_rcvbuf_delta
Date: Wed, 20 Mar 2019 19:03:00 -0700
Message-ID: <00000000000044534c058491234b@google.com>
References: <000000000000445dd9057a7149f1@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <000000000000445dd9057a7149f1@google.com>
Sender: netdev-owner@vger.kernel.org
To: chien.yen@oracle.com, davem@davemloft.net, dennis.dalessandro@intel.com, dledford@redhat.com, ira.weiny@intel.com, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, mike.marciniszyn@intel.com, netdev@vger.kernel.org, rds-devel@oss.oracle.com, santosh.shilimkar@oracle.com, syzkaller-bugs@googlegroups.com
List-Id: linux-rdma@vger.kernel.org

syzbot has bisected this bug to:

commit b534875d5ab348fb9193692589e2ee82ae768e3a
Author: Dennis Dalessandro <dennis.dalessandro@intel.com>
Date:   Wed Jan 6 18:02:59 2016 +0000

     IB/rdmavt: Add device specific info prints

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=13e03843200000
start commit:   b534875d IB/rdmavt: Add device specific info prints
git tree:       upstream
final crash:    https://syzkaller.appspot.com/x/report.txt?x=10103843200000
console output: https://syzkaller.appspot.com/x/log.txt?x=17e03843200000
kernel config:  https://syzkaller.appspot.com/x/.config?x=2e0064f906afee10
dashboard link: https://syzkaller.appspot.com/bug?extid=4b4f8163c2e246df3c4c
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11631328c00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1172c7ef400000

Reported-by: syzbot+4b4f8163c2e246df3c4c@syzkaller.appspotmail.com
Fixes: b534875d ("IB/rdmavt: Add device specific info prints")
