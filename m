From: Sowmini Varadhan <sowmini.varadhan@oracle.com>
Subject: Re: KASAN: use-after-free Read in rds_tcp_tune
Date: Wed, 14 Feb 2018 10:21:09 -0500
Message-ID: <20180214152109.GF11528@oracle.com>
References: <001a1141a524c513ca05628d8ad4@google.com>
 <20180112183046.GA26098@oracle.com>
 <CACT4Y+aB0dZShujVMJFV6grb_7AYOMca13a1J2AkWsT7R0cgrQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CACT4Y+aB0dZShujVMJFV6grb_7AYOMca13a1J2AkWsT7R0cgrQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dmitry Vyukov <dvyukov@google.com>
Cc: syzbot <syzbot+bbd8e9a06452cc48059b@syzkaller.appspotmail.com>, David Miller <davem@davemloft.net>, LKML <linux-kernel@vger.kernel.org>, linux-rdma@vger.kernel.org, netdev <netdev@vger.kernel.org>, rds-devel@oss.oracle.com, Santosh Shilimkar <santosh.shilimkar@oracle.com>, syzkaller-bugs@googlegroups.com
List-Id: linux-rdma@vger.kernel.org

On (02/14/18 16:11), Dmitry Vyukov wrote:
> 
> Hi Sowmini,
> 
> Was this ever fixed? What's the fix? This still hangs as open. Please
> provide "syz fix" tag.

Are you still seeing this problem?

I had expected that the changes around rds_destroy_pending - see commit
ebeeb1ad9b8a - would have taken care of this (note that ebeeb1ad9b8a
refactors/updates 3db6e0d172c9) but those fixes were done by inspection
only. In other words, I was never able to reproduce this, so we may
still have missed some race condition.

--Sowmini
