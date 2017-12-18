From: David Miller <davem@davemloft.net>
Subject: Re: BUG: unable to handle kernel NULL pointer dereference in
 rds_send_xmit
Date: Mon, 18 Dec 2017 12:12:13 -0500 (EST)
Message-ID: <20171218.121213.289437104214632276.davem@davemloft.net>
References: <001a1145ac5480242305609956b3@google.com>
        <5ba83a68-0103-d514-1b22-900f755f5aa4@oracle.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5ba83a68-0103-d514-1b22-900f755f5aa4@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: santosh.shilimkar@oracle.com
Cc: bot+aaf54a8c644d559d34dedcf3126aac68a20c9e63@syzkaller.appspotmail.com, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, netdev@vger.kernel.org, rds-devel@oss.oracle.com, syzkaller-bugs@googlegroups.com
List-Id: linux-rdma@vger.kernel.org

From: Santosh Shilimkar <santosh.shilimkar@oracle.com>
Date: Mon, 18 Dec 2017 08:28:05 -0800

> On 12/18/2017 12:43 AM, syzbot wrote:
>> Hello,
>> syzkaller hit the following crash on
>> 6084b576dca2e898f5c101baef151f7bfdbb606d
>> git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/master
>> compiler: gcc (GCC) 7.1.1 20170620
>> .config is attached
>> Raw console output is attached.
>> Unfortunately, I don't have any reproducer for this bug yet.
>> BUG: unable to handle kernel NULL pointer dereference at
>> 0000000000000028
>> program syz-executor6 is using a deprecated SCSI ioctl, please convert
>> it to SG_IO
>> IP: rds_send_xmit+0x80/0x930 net/rds/send.c:186
> 
> Looks like another one tripping on empty transport. Mostly below
> should
> address it but we will test it if it does.
> 
> diff --git a/net/rds/send.c b/net/rds/send.c
> index 7244d2e..e2d0eaa 100644
> --- a/net/rds/send.c
> +++ b/net/rds/send.c
> @@ -183,7 +183,7 @@ int rds_send_xmit(struct rds_conn_path *cp)
>                 goto out;
>         }
> 
> -       if (conn->c_trans->xmit_path_prepare)
> +       if (conn->c_trans && conn->c_trans->xmit_path_prepare)
>                 conn->c_trans->xmit_path_prepare(cp);

We're seeming to accumulate a lot of checks like this, maybe there
is a more general way to deal with this problem?
