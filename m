From: Yuval Shaia <yuval.shaia@oracle.com>
Subject: Re: [PATCH net] RDS: Check cmsg_len before dereferencing CMSG_DATA
Date: Fri, 22 Dec 2017 14:55:05 +0200
Message-ID: <20171222125504.GA2660@yuvallap>
References: <1513916224-9445-1-git-send-email-avinash.repaka@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1513916224-9445-1-git-send-email-avinash.repaka@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Avinash Repaka <avinash.repaka@oracle.com>
Cc: Santosh Shilimkar <santosh.shilimkar@oracle.com>, "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Dec 21, 2017 at 08:17:04PM -0800, Avinash Repaka wrote:
> RDS currently doesn't check if the length of the control message is
> large enough to hold the required data, before dereferencing the control
> message data. This results in following crash:
> 
> BUG: KASAN: stack-out-of-bounds in rds_rdma_bytes net/rds/send.c:1013
> [inline]
> BUG: KASAN: stack-out-of-bounds in rds_sendmsg+0x1f02/0x1f90
> net/rds/send.c:1066
> Read of size 8 at addr ffff8801c928fb70 by task syzkaller455006/3157
> 
> CPU: 0 PID: 3157 Comm: syzkaller455006 Not tainted 4.15.0-rc3+ #161
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
> Google 01/01/2011
> Call Trace:
>  __dump_stack lib/dump_stack.c:17 [inline]
>  dump_stack+0x194/0x257 lib/dump_stack.c:53
>  print_address_description+0x73/0x250 mm/kasan/report.c:252
>  kasan_report_error mm/kasan/report.c:351 [inline]
>  kasan_report+0x25b/0x340 mm/kasan/report.c:409
>  __asan_report_load8_noabort+0x14/0x20 mm/kasan/report.c:430
>  rds_rdma_bytes net/rds/send.c:1013 [inline]
>  rds_sendmsg+0x1f02/0x1f90 net/rds/send.c:1066
>  sock_sendmsg_nosec net/socket.c:628 [inline]
>  sock_sendmsg+0xca/0x110 net/socket.c:638
>  ___sys_sendmsg+0x320/0x8b0 net/socket.c:2018
>  __sys_sendmmsg+0x1ee/0x620 net/socket.c:2108
>  SYSC_sendmmsg net/socket.c:2139 [inline]
>  SyS_sendmmsg+0x35/0x60 net/socket.c:2134
>  entry_SYSCALL_64_fastpath+0x1f/0x96
> RIP: 0033:0x43fe49
> RSP: 002b:00007fffbe244ad8 EFLAGS: 00000217 ORIG_RAX: 0000000000000133
> RAX: ffffffffffffffda RBX: 00000000004002c8 RCX: 000000000043fe49
> RDX: 0000000000000001 RSI: 000000002020c000 RDI: 0000000000000003
> RBP: 00000000006ca018 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000217 R12: 00000000004017b0
> R13: 0000000000401840 R14: 0000000000000000 R15: 0000000000000000
> 
> To fix this, we verify that the cmsg_len is large enough to hold the
> data to be read, before proceeding further.
> 
> Reported-by: syzbot <syzkaller-bugs@googlegroups.com>
> Signed-off-by: Avinash Repaka <avinash.repaka@oracle.com>
> ---
>  net/rds/send.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/net/rds/send.c b/net/rds/send.c
> index b52cdc8..f72466c 100644
> --- a/net/rds/send.c
> +++ b/net/rds/send.c
> @@ -1009,6 +1009,9 @@ static int rds_rdma_bytes(struct msghdr *msg, size_t *rdma_bytes)
>  			continue;
>  
>  		if (cmsg->cmsg_type == RDS_CMSG_RDMA_ARGS) {
> +			if (cmsg->cmsg_len <
> +			    CMSG_LEN(sizeof(struct rds_rdma_args)))
> +				return -EINVAL;
>  			args = CMSG_DATA(cmsg);
>  			*rdma_bytes += args->remote_vec.bytes;
>  		}

Reviewed-by: Yuval Shaia <yuval.shaia@oracle.com>

> -- 
> 2.4.11
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
