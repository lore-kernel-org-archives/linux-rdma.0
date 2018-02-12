From: Sowmini Varadhan <sowmini.varadhan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: WARNING: suspicious RCU usage in rds_tcp_conn_alloc
Date: Mon, 12 Feb 2018 11:15:16 -0500
Message-ID: <20180212161516.GC21125@oracle.com>
References: <001a11499df4ce6c2d056505e5c0@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <001a11499df4ce6c2d056505e5c0-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: syzbot <syzbot+a0564419941aaae3fe3c-Pl5Pbv+GP7P466ipTTIvnc23WoclnBCfAL8bYrjMMd8@public.gmane.org>
Cc: davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, rds-devel-N0ozoZBvEnrZJqsBc5GL+g@public.gmane.org, santosh.shilimkar-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, syzkaller-bugs-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

#syz dup: WARNING: suspicious RCU usage in rds_loop_conn_alloc

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
