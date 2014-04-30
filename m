From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH] librdmacm: Fix verbs leak due to reentrancy issue
Date: Wed, 30 Apr 2014 03:14:43 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373992F6185@ORSMSX109.amr.corp.intel.com>
References: <20140422112202.GA7440@shamir-pc>
 <1828884A29C6694DAF28B7E6B8A82373992F2EE8@ORSMSX109.amr.corp.intel.com>
 <20140429134803.GA11791@shamir-pc>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140429134803.GA11791@shamir-pc>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shamir Rabinovith <shamir.rabinovitch-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> librdmacm git (git://git.openfabrics.org/~shefty/librdmacm.git)
> currently only has the lazy initialization patch (23ffef0 librdmacm:
> Support lazy initialization) but this patch is missing. can you please
> add this fix to the git if you approve it? thanks.

I pushed the fix upstream.  Thanks!
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
