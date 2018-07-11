From: Santosh Shilimkar <santosh.shilimkar@oracle.com>
Subject: Re: KASAN: slab-out-of-bounds Read in rds_cong_queue_updates (2)
Date: Wed, 11 Jul 2018 14:00:35 -0700
Message-ID: <291f2ead-fdbe-f5bb-ebfa-aaa2583df9bb@oracle.com>
References: <0000000000005274c40570be9f48@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <0000000000005274c40570be9f48@google.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: syzbot <syzbot+0570fef57a5e020bdc87@syzkaller.appspotmail.com>, davem@davemloft.net, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, netdev@vger.kernel.org, rds-devel@oss.oracle.com, syzkaller-bugs@googlegroups.com
List-Id: linux-rdma@vger.kernel.org

On 7/11/2018 12:55 PM, syzbot wrote:
> Hello,
> 
> syzbot found the following crash on:
> 
> HEAD commit:    0026129c8629 rhashtable: add restart routine in 
> rhashtable..
> git tree:       net
> console output: https://syzkaller.appspot.com/x/log.txt?x=10b7ced0400000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=b88de6eac8694da6
> dashboard link: 
> https://syzkaller.appspot.com/bug?extid=0570fef57a5e020bdc87
> compiler:       gcc (GCC) 8.0.1 20180413 (experimental)
> 
> Unfortunately, I don't have any reproducer for this crash yet.
> 
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+0570fef57a5e020bdc87@syzkaller.appspotmail.com
> 
dup: syzbot+4c20b3866171ce8441d2@syzkaller.appspotmail.com
