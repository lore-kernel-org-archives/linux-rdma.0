From: Santosh Shilimkar <santosh.shilimkar@oracle.com>
Subject: Re: WARNING in rds_message_alloc_sgs
Date: Tue, 30 Oct 2018 12:38:02 -0700
Message-ID: <a7a834e0-c300-b5b9-67b5-78fa3eba8ebb@oracle.com>
References: <0000000000003c6b7b0579772ff3@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <0000000000003c6b7b0579772ff3@google.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: syzbot <syzbot+26de17458aeda9d305d8@syzkaller.appspotmail.com>, linux-rdma@vger.kernel.org, netdev@vger.kernel.org, rds-devel@oss.oracle.com, syzkaller-bugs@googlegroups.com
Cc: davem@davemloft.net, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On 10/30/2018 12:28 PM, syzbot wrote:
> Hello,
> 
> syzbot found the following crash on:
> 
> HEAD commit:    6201f31a39f8 Add linux-next specific files for 20181030
> git tree:       linux-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=1397d06d400000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=2a22859d870756c1
> dashboard link: 
> https://syzkaller.appspot.com/bug?extid=26de17458aeda9d305d8
> compiler:       gcc (GCC) 8.0.1 20180413 (experimental)
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10bb52eb400000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=118bdfc5400000
> 
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+26de17458aeda9d305d8@syzkaller.appspotmail.com
> 
> WARNING: CPU: 0 PID: 19789 at net/rds/message.c:316 
> rds_message_alloc_sgs+0x10c/0x160 net/rds/message.c:316
> Kernel panic - not syncing: panic_on_warn set ...
Looks like this kernel build has panic on warn enabled which
triggers panic for " WARN_ON(!nr_pages)" case. Will look into
it. Thanks !!

Regards,
Santosh
