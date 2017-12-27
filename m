From: David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>
Subject: Re: [PATCH net] RDS: Check cmsg_len before dereferencing CMSG_DATA
Date: Wed, 27 Dec 2017 10:37:54 -0500 (EST)
Message-ID: <20171227.103754.1156659391056933085.davem@davemloft.net>
References: <1513916224-9445-1-git-send-email-avinash.repaka@oracle.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1513916224-9445-1-git-send-email-avinash.repaka-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: avinash.repaka-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org
Cc: santosh.shilimkar-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, rds-devel-N0ozoZBvEnrZJqsBc5GL+g@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Avinash Repaka <avinash.repaka-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Date: Thu, 21 Dec 2017 20:17:04 -0800

> RDS currently doesn't check if the length of the control message is
> large enough to hold the required data, before dereferencing the control
> message data. This results in following crash:
 ...
> To fix this, we verify that the cmsg_len is large enough to hold the
> data to be read, before proceeding further.
> 
> Reported-by: syzbot <syzkaller-bugs-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
> Signed-off-by: Avinash Repaka <avinash.repaka-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

Applied and queued up for -stable, thanks.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
