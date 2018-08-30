From: Santosh Shilimkar <santosh.shilimkar@oracle.com>
Subject: Re: KMSAN: uninit-value in rds_bind
Date: Thu, 30 Aug 2018 13:56:38 -0700
Message-ID: <355351e8-71fa-6db9-ad2a-43115cc2e80e@oracle.com>
References: <000000000000010a4d0574ab4743@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <000000000000010a4d0574ab4743@google.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: syzbot <syzbot+915c9f99f3dbc4bd6cd1@syzkaller.appspotmail.com>, linux-rdma@vger.kernel.org, netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Cc: davem@davemloft.net, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On 8/30/2018 11:31 AM, syzbot wrote:
> Hello,
> 
> syzbot found the following crash on:
> 
> HEAD commit:    2dca2cbde67a kmsan: fix build warnings with CONFIG_KMSAN=n
> git tree:       https://github.com/google/kmsan.git/master

BTW, can you please fix your git url since this one doesn't work.
This tree is not vanila kernel.org tree(4.19.0-rc1+ #36), so would be
good to get the line numbers correct for sources.

Regards,
Snatosh
