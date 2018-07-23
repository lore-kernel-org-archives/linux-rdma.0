From: Santosh Shilimkar <santosh.shilimkar@oracle.com>
Subject: Re: KASAN: use-after-free Read in rds_cong_queue_updates (2)
Date: Mon, 23 Jul 2018 10:38:58 -0700
Message-ID: <ed11f25c-6e61-16c2-2ac0-e3196c32ffb6@oracle.com>
References: <000000000000cdb5450571adfe40@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <000000000000cdb5450571adfe40@google.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: syzbot <syzbot+470ae97a39f16146af45@syzkaller.appspotmail.com>, davem@davemloft.net, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, netdev@vger.kernel.org, rds-devel@oss.oracle.com, syzkaller-bugs@googlegroups.com
List-Id: linux-rdma@vger.kernel.org

On 7/23/2018 10:30 AM, syzbot wrote:
> Hello,
> 
> syzbot found the following crash on:
> 
> HEAD commit:    fcf4793e278e tls: check RCV_SHUTDOWN in tls_wait_data
> git tree:       net
> console output: https://syzkaller.appspot.com/x/log.txt?x=1738cb2c400000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=c0bdc4175608181c
> dashboard link: 
> https://syzkaller.appspot.com/bug?extid=470ae97a39f16146af45
> compiler:       gcc (GCC) 8.0.1 20180413 (experimental)
> 
> Unfortunately, I don't have any reproducer for this crash yet.
> 
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+470ae97a39f16146af45@syzkaller.appspotmail.com
> 
dup: syzbot+4c20b3866171ce8441d2@syzkaller.appspotmail.com
