From: Santosh Shilimkar <santosh.shilimkar@oracle.com>
Subject: Re: WARNING in rds_message_alloc_sgs
Date: Wed, 31 Oct 2018 09:44:28 -0700
Message-ID: <1537ebeb-2c03-0068-58f1-6c348a2f718e@oracle.com>
References: <0000000000003c6b7b0579772ff3@google.com>
 <a7a834e0-c300-b5b9-67b5-78fa3eba8ebb@oracle.com>
 <20181031064220.GN3974@mtr-leonro.mtl.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181031064220.GN3974@mtr-leonro.mtl.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>
Cc: syzbot <syzbot+26de17458aeda9d305d8@syzkaller.appspotmail.com>, linux-rdma@vger.kernel.org, netdev@vger.kernel.org, rds-devel@oss.oracle.com, syzkaller-bugs@googlegroups.com, davem@davemloft.net, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On 10/30/2018 11:42 PM, Leon Romanovsky wrote:
> On Tue, Oct 30, 2018 at 12:38:02PM -0700, Santosh Shilimkar wrote:
>> On 10/30/2018 12:28 PM, syzbot wrote:
>>> Hello,
>>>
>>> syzbot found the following crash on:
>>>
>>> HEAD commit:    6201f31a39f8 Add linux-next specific files for 20181030
>>> git tree:       linux-next
>>> console output: https://syzkaller.appspot.com/x/log.txt?x=1397d06d400000
>>> kernel config:  https://syzkaller.appspot.com/x/.config?x=2a22859d870756c1
>>> dashboard link:
>>> https://syzkaller.appspot.com/bug?extid=26de17458aeda9d305d8
>>> compiler:       gcc (GCC) 8.0.1 20180413 (experimental)
>>> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10bb52eb400000
>>> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=118bdfc5400000
>>>
>>> IMPORTANT: if you fix the bug, please add the following tag to the commit:
>>> Reported-by: syzbot+26de17458aeda9d305d8@syzkaller.appspotmail.com
>>>
>>> WARNING: CPU: 0 PID: 19789 at net/rds/message.c:316
>>> rds_message_alloc_sgs+0x10c/0x160 net/rds/message.c:316
>>> Kernel panic - not syncing: panic_on_warn set ...
>> Looks like this kernel build has panic on warn enabled which
>> triggers panic for " WARN_ON(!nr_pages)" case. Will look into
>> it. Thanks !!
> 
> Please don't forget to remove user triggered WARN_ON.
> https://lwn.net/Articles/769365/
> "Greg Kroah-Hartman raised the problem of core kernel API code that will
> use WARN_ON_ONCE() to complain about bad usage; that will not generate
> the desired result if WARN_ON_ONCE() is configured to crash the machine.
> He was told that the code should just call pr_warn() instead, and that
> the called function should return an error in such situations. It was
> generally agreed that any WARN_ON() or WARN_ON_ONCE() calls that can be
> triggered from user space need to be fixed."
> 
OK. Thanks for the note !!
