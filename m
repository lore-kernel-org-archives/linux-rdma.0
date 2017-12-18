From: Santosh Shilimkar <santosh.shilimkar-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: BUG: unable to handle kernel NULL pointer dereference in
 rds_send_xmit
Date: Mon, 18 Dec 2017 08:28:05 -0800
Message-ID: <5ba83a68-0103-d514-1b22-900f755f5aa4@oracle.com>
References: <001a1145ac5480242305609956b3@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <001a1145ac5480242305609956b3-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: syzbot <bot+aaf54a8c644d559d34dedcf3126aac68a20c9e63-Pl5Pbv+GP7P466ipTTIvnc23WoclnBCfAL8bYrjMMd8@public.gmane.org>, davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, rds-devel-N0ozoZBvEnrZJqsBc5GL+g@public.gmane.org, syzkaller-bugs-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 12/18/2017 12:43 AM, syzbot wrote:
> Hello,
> 
> syzkaller hit the following crash on 
> 6084b576dca2e898f5c101baef151f7bfdbb606d
> git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/master
> compiler: gcc (GCC) 7.1.1 20170620
> .config is attached
> Raw console output is attached.
> 
> Unfortunately, I don't have any reproducer for this bug yet.
> 
> 
> BUG: unable to handle kernel NULL pointer dereference at 0000000000000028
> program syz-executor6 is using a deprecated SCSI ioctl, please convert 
> it to SG_IO
> IP: rds_send_xmit+0x80/0x930 net/rds/send.c:186

Looks like another one tripping on empty transport. Mostly below should
address it but we will test it if it does.

diff --git a/net/rds/send.c b/net/rds/send.c
index 7244d2e..e2d0eaa 100644
--- a/net/rds/send.c
+++ b/net/rds/send.c
@@ -183,7 +183,7 @@ int rds_send_xmit(struct rds_conn_path *cp)
                 goto out;
         }

-       if (conn->c_trans->xmit_path_prepare)
+       if (conn->c_trans && conn->c_trans->xmit_path_prepare)
                 conn->c_trans->xmit_path_prepare(cp);



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
