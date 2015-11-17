From: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/ipoib: Change sendq threshold size
Date: Tue, 17 Nov 2015 17:02:44 +0200
Message-ID: <20151117150243.GC2432@yuval-lab>
References: <1447700076-795-1-git-send-email-yuval.shaia@oracle.com>
 <564AE125.4030700@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <564AE125.4030700-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Nov 17, 2015 at 10:11:17AM +0200, Or Gerlitz wrote:
> On 11/16/2015 8:54 PM, Yuval Shaia wrote:
> >-	    test_bit(IPOIB_FLAG_ADMIN_UP, &priv->flags))
> >+	    likely(test_bit(IPOIB_FLAG_ADMIN_UP, &priv->flags)))
> 
> this hunk has nothing to do with the proposed change, remove it from here.
np
> 
> upstream patches should have one logical change,
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
