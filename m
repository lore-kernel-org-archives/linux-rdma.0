From: Sowmini Varadhan <sowmini.varadhan@oracle.com>
Subject: Re: KASAN: use-after-free Read in rds_tcp_tune
Date: Wed, 14 Feb 2018 10:35:55 -0500
Message-ID: <20180214153555.GG11528@oracle.com>
References: <001a1141a524c513ca05628d8ad4@google.com>
 <20180112183046.GA26098@oracle.com>
 <CACT4Y+aB0dZShujVMJFV6grb_7AYOMca13a1J2AkWsT7R0cgrQ@mail.gmail.com>
 <20180214152109.GF11528@oracle.com>
 <CACT4Y+bKpi8he1ygwAxgm4F_RJ=BRPBPdMaVAK64SbvCVGt7ww@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CACT4Y+bKpi8he1ygwAxgm4F_RJ=BRPBPdMaVAK64SbvCVGt7ww@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
To: Dmitry Vyukov <dvyukov@google.com>
Cc: syzbot <syzbot+bbd8e9a06452cc48059b@syzkaller.appspotmail.com>, David Miller <davem@davemloft.net>, LKML <linux-kernel@vger.kernel.org>, linux-rdma@vger.kernel.org, netdev <netdev@vger.kernel.org>, rds-devel@oss.oracle.com, Santosh Shilimkar <santosh.shilimkar@oracle.com>, syzkaller-bugs@googlegroups.com
List-Id: linux-rdma@vger.kernel.org

On (02/14/18 16:28), Dmitry Vyukov wrote:
> syzbot is probably not seeing this problem. However if you don't add
> the Reported-by tag to commit, nor provide syz fix tag, it will
> consider it as "open". One consequence of this is that it is still on
> our radars. Another consequence is that syzbot will never report bugs
> in rds_tcp_tune ever again as it thinks that it's the same known bug,
> so no point in bothering anybody.

understood, I think I saw this in the original syzbot mail as well,
but I was hesitant to actually add the tag because the fix was
based on code-inspection only, and I would have felt more comfortable
about asserting the Reported-by if I'd done a clear-cut before/after
verification.

btw, checkpatch.pl complains about the syzbot*@syzkaller.appspotmail.com
addresses as "Unrecognized email address", we should fix that
error from checkpatch at some point.

--Sowmini 
