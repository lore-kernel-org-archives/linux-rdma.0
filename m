From: Santosh Shilimkar <santosh.shilimkar@oracle.com>
Subject: Re: KMSAN: uninit-value in rds_connect
Date: Thu, 30 Aug 2018 12:30:26 -0700
Message-ID: <d3a92af1-cbdd-b727-bd57-6c1895e72238@oracle.com>
References: <00000000000005859b0574ab47e5@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <00000000000005859b0574ab47e5@google.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: syzbot <syzbot+0049bebbf3042dbd2e8f@syzkaller.appspotmail.com>, davem@davemloft.net, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, netdev@vger.kernel.org, rds-devel@oss.oracle.com, syzkaller-bugs@googlegroups.com
List-Id: linux-rdma@vger.kernel.org

On 8/30/2018 11:31 AM, syzbot wrote:
> Hello,
> 
> syzbot found the following crash on:
> 
> HEAD commit:    2dca2cbde67a kmsan: fix build warnings with CONFIG_KMSAN=n
> git tree:       https://github.com/google/kmsan.git/master
> console output: https://syzkaller.appspot.com/x/log.txt?x=1519734a400000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=820d6393634b55e3
> dashboard link: 
> https://syzkaller.appspot.com/bug?extid=0049bebbf3042dbd2e8f
> compiler:       clang version 8.0.0 (trunk 339414)
> 
> Unfortunately, I don't have any reproducer for this crash yet.
> 
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+0049bebbf3042dbd2e8f@syzkaller.appspotmail.com
> 
OK. Will send the fix to address this.

Regards,
Santosh
