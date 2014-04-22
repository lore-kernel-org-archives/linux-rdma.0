From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH] librdmacm: Fix verbs leak due to reentrancy issue
Date: Tue, 22 Apr 2014 18:35:45 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373992F2EE8@ORSMSX109.amr.corp.intel.com>
References: <20140422112202.GA7440@shamir-pc>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140422112202.GA7440@shamir-pc>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: shamir rabinovitch <shamir.rabinovitch-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> I was out of work so I tested the patch "librdmacm: lazy initialization
> for ib devices" today. The patch works fine for my test case. The only
> concern I have is that I think the patch might leak verbs context. I
> think that any call to ucma_init_device must be done with mutex locked.
> Please correct me if I am wrong.

I think you're correct; the lock needs to move up.  I'll apply your fix.  Thanks!
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
