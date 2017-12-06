From: David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>
Subject: Re: [PATCH net] rds: Fix NULL pointer dereference in __rds_rdma_map
Date: Wed, 06 Dec 2017 15:45:03 -0500 (EST)
Message-ID: <20171206.154503.335867422494464163.davem@davemloft.net>
References: <20171206161828.8368-1-Haakon.Bugge@oracle.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171206161828.8368-1-Haakon.Bugge-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Haakon.Bugge-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org
Cc: santosh.shilimkar-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, rds-devel-N0ozoZBvEnrZJqsBc5GL+g@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Håkon Bugge <Haakon.Bugge-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Date: Wed,  6 Dec 2017 17:18:28 +0100

> This is a fix for syzkaller719569, where memory registration was
> attempted without any underlying transport being loaded.
> 
> Analysis of the case reveals that it is the setsockopt() RDS_GET_MR
> (2) and RDS_GET_MR_FOR_DEST (7) that are vulnerable.
> 
> Here is an example stack trace when the bug is hit:
 ...
> The fix is to check the existence of an underlying transport in
> __rds_rdma_map().
> 
> Signed-off-by: Håkon Bugge <haakon.bugge-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> Reported-by: syzbot <syzkaller-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>

Applied and queued up for -stable, thanks.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
