From: Eric Biggers <ebiggers3@gmail.com>
Subject: Re: general protection fault in rds_ib_get_mr
Date: Wed, 4 Jul 2018 14:35:06 -0700
Message-ID: <20180704213506.GH725@sol.localdomain>
References: <089e082ce58896ad350567ee4825@google.com>
 <20180513211058.GE677@sol.localdomain>
 <27665604-6a26-36e2-3a58-9c8b3d9eab80@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <27665604-6a26-36e2-3a58-9c8b3d9eab80@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "santosh.shilimkar@oracle.com" <santosh.shilimkar@oracle.com>, linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com
Cc: syzbot <syzbot+b51c77ef956678a65834@syzkaller.appspotmail.com>, davem@davemloft.net, linux-kernel@vger.kernel.org, netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
List-Id: linux-rdma@vger.kernel.org

On Sun, May 13, 2018 at 10:46:37PM -0700, santosh.shilimkar@oracle.com wrote:
> On 5/13/18 2:10 PM, Eric Biggers wrote:
> > On Wed, Mar 21, 2018 at 09:00:01AM -0700, syzbot wrote:
> 
> [...]
> 
> 
> > Still reproducible on Linus' tree (commit 66e1c94db3cd4) and linux-next
> > (next-20180511).  Here's a simplified reproducer:
> > 
> Thanks for the test case !!
> 
> Regards,
> Santosh

Ping; this RDS bug is still unfixed.  The same reproducer I gave earlier still
works, even when run as a non-root user.  I tested upstream commit
fc36def997cfd6 (v4.18-rc3-113-gfc36def997cfd), and linux-next commit
bce40927669338 (next-20180704).

- Eric
