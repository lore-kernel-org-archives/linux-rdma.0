From: Santosh Shilimkar <santosh.shilimkar@oracle.com>
Subject: Re: KMSAN: uninit-value in rds_bind
Date: Thu, 30 Aug 2018 12:30:43 -0700
Message-ID: <c8126a9a-9669-b758-039d-3e920d1dcff9@oracle.com>
References: <000000000000010a4d0574ab4743@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <000000000000010a4d0574ab4743@google.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: syzbot <syzbot+915c9f99f3dbc4bd6cd1@syzkaller.appspotmail.com>, davem@davemloft.net, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, netdev@vger.kernel.org, rds-devel@oss.oracle.com, syzkaller-bugs@googlegroups.com
List-Id: linux-rdma@vger.kernel.org

On 8/30/2018 11:31 AM, syzbot wrote:
> Hello,
> 
> syzbot found the following crash on:
> 
> HEAD commit:    2dca2cbde67a kmsan: fix build warnings with CONFIG_KMSAN=n
> git tree:       https://github.com/google/kmsan.git/master
> console output: https://syzkaller.appspot.com/x/log.txt?x=16db895a400000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=820d6393634b55e3
> dashboard link: 
> https://syzkaller.appspot.com/bug?extid=915c9f99f3dbc4bd6cd1
> compiler:       clang version 8.0.0 (trunk 339414)
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1137bffe400000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1521a7fe400000
> 
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+915c9f99f3dbc4bd6cd1@syzkaller.appspotmail.com
> 
OK. Will send the fix to address this.

Regards,
Santosh
