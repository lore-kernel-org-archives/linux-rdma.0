From: Santosh Shilimkar <santosh.shilimkar-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: BUG: spinlock bad magic (2)
Date: Mon, 18 Dec 2017 08:46:21 -0800
Message-ID: <6dbd4f85-f3f2-97f3-5b82-451276fbf877@oracle.com>
References: <001a113fae28c2fd6605609c97a2@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <001a113fae28c2fd6605609c97a2-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: syzbot <bot+d3f5d339869eb8cd834d2c9f0a88bf4f05c29781-Pl5Pbv+GP7P466ipTTIvnc23WoclnBCfAL8bYrjMMd8@public.gmane.org>, davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, rds-devel-N0ozoZBvEnrZJqsBc5GL+g@public.gmane.org, syzkaller-bugs-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 12/18/2017 4:36 AM, syzbot wrote:
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
[...]

> BUG: unable to handle kernel NULL pointer dereference at 0000000000000028
> IP: rds_send_xmit+0x80/0x930 net/rds/send.c:186

This one seems to be same bug as reported as below.

BUG: unable to handle kernel NULL pointer dereference in rds_send_xmit
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
