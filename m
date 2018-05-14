From: "santosh.shilimkar@oracle.com" <santosh.shilimkar@oracle.com>
Subject: Re: general protection fault in rds_ib_get_mr
Date: Sun, 13 May 2018 22:46:37 -0700
Message-ID: <27665604-6a26-36e2-3a58-9c8b3d9eab80@oracle.com>
References: <089e082ce58896ad350567ee4825@google.com>
 <20180513211058.GE677@sol.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180513211058.GE677@sol.localdomain>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Eric Biggers <ebiggers3@gmail.com>, linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com
Cc: syzbot <syzbot+b51c77ef956678a65834@syzkaller.appspotmail.com>, davem@davemloft.net, linux-kernel@vger.kernel.org, netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
List-Id: linux-rdma@vger.kernel.org

On 5/13/18 2:10 PM, Eric Biggers wrote:
> On Wed, Mar 21, 2018 at 09:00:01AM -0700, syzbot wrote:

[...]


> Still reproducible on Linus' tree (commit 66e1c94db3cd4) and linux-next
> (next-20180511).  Here's a simplified reproducer:
> 
Thanks for the test case !!

Regards,
Santosh
