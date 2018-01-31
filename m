From: Eric Biggers <ebiggers3@gmail.com>
Subject: Re: KASAN: stack-out-of-bounds Read in rds_sendmsg
Date: Tue, 30 Jan 2018 18:16:38 -0800
Message-ID: <20180131021638.6h5fukvzzakzu5g2@gmail.com>
References: <089e08263e589121d90560d610a5@google.com>
 <9deaf3c4-227f-f6f0-9ccb-3ad05fc32a0c@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <9deaf3c4-227f-f6f0-9ccb-3ad05fc32a0c@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Santosh Shilimkar <santosh.shilimkar@oracle.com>
Cc: syzkaller-bugs@googlegroups.com, Avinash Repaka <avinash.repaka@oracle.com>, syzbot <bot+9461c9b9d340854a404b46c42cbfc91ded1232d8@syzkaller.appspotmail.com>, davem@davemloft.net, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, netdev@vger.kernel.org, rds-devel@oss.oracle.com
List-Id: linux-rdma@vger.kernel.org

On Thu, Dec 21, 2017 at 08:44:32AM -0800, Santosh Shilimkar wrote:
> +Avinash
> 
> On 12/21/2017 1:10 AM, syzbot wrote:
> > syzkaller has found reproducer for the following crash on
> 
> [..]
> 
> > 
> > audit: type=1400 audit(1513847224.110:7): avc:  denied  { map } for
> > pid=3157 comm="syzkaller455006" path="/root/syzkaller455006870"
> > dev="sda1" ino=16481
> > scontext=unconfined_u:system_r:insmod_t:s0-s0:c0.c1023
> > tcontext=unconfined_u:object_r:user_home_t:s0 tclass=file permissive=1
> > ==================================================================
> > BUG: KASAN: stack-out-of-bounds in rds_rdma_bytes net/rds/send.c:1013
> > [inline]
> 
> Could you please post the discussed fix if you are ready with it ?
> This new report is same as last one and cmesg length check should
> address it.
> 
> Regards,
> Santosh
> 

This crash seems to have stopped occurring.  I assume it was fixed by commit
14e138a86f63 (thanks Avinash!), so let's tell syzbot so that it can start
reporting crashes in the same place again:

#syz fix: RDS: Check cmsg_len before dereferencing CMSG_DATA

- Eric
