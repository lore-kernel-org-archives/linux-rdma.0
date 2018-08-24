From: syzbot <syzbot+8967084bcac563795dc6@syzkaller.appspotmail.com>
Subject: Re: Re: KASAN: use-after-free Read in __rhashtable_lookup (2)
Date: Fri, 24 Aug 2018 16:05:02 -0700
Message-ID: <000000000000d8879a05743667a2@google.com>
References: <20180824230446.GA16891@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180824230446.GA16891@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
Cc: davem@davemloft.net, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, netdev@vger.kernel.org, rds-devel@oss.oracle.com, santosh.shilimkar@oracle.com, sowmini.varadhan@oracle.com, syzkaller-bugs@googlegroups.com
List-Id: linux-rdma@vger.kernel.org



> #syz dup KASAN: use-after-free Read in rds_find_bound

unknown command "dup"


> The problem is a missing synchronize_net() in rds_release.
> References:
>    https://www.spinics.net/lists/netdev/msg475074.html
>    https://www.spinics.net/lists/netdev/msg507908.html

> --
> You received this message because you are subscribed to the Google  
> Groups "syzkaller-bugs" group.
> To unsubscribe from this group and stop receiving emails from it, send an  
> email to syzkaller-bugs+unsubscribe@googlegroups.com.
> To view this discussion on the web visit  
> https://groups.google.com/d/msgid/syzkaller-bugs/20180824230446.GA16891%40oracle.com.
> For more options, visit https://groups.google.com/d/optout.
