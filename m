From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 1/2] IB/ipoib: Clean up send-only multicast joins
Date: Tue, 25 Aug 2015 13:49:45 -0600
Message-ID: <20150825194945.GA22335@obsidianresearch.com>
References: <1440200053-18890-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <55DCAACD.3000307@redhat.com>
 <20150825182233.GA20744@obsidianresearch.com>
 <55DCB56F.5000001@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <55DCB56F.5000001-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Aug 25, 2015 at 02:35:27PM -0400, Doug Ledford wrote:
> On 08/25/2015 02:22 PM, Jason Gunthorpe wrote:
> > On Tue, Aug 25, 2015 at 01:50:05PM -0400, Doug Ledford wrote:
> >> On 08/21/2015 07:34 PM, Jason Gunthorpe wrote:
> >>> Even though we don't expect the group to be created by the SM we
> >>> sill need to provide all the parameters to force the SM to validate
> >>> they are correct.
> >>
> >> Why does this patch embed locking changes that, as far I can tell, are
> >> not needed by the rest of the patch?
> > 
> > test_bit was lowered into ipoib_mcast_join, which requires pushing the
> > lock unlock down as well. The set_bit side holds that lock.
> 
> I see the confusion.  The test bit of SENDONLY isn't protected by the
> lock, just the setting and clearing of BUSY.

Well, I don't like to see locking elided unless necessary. The flags
is clearly lock protected data, the lock should be held when accessing
it - even if one can reason some of the locking away today. That just
increases maintainability and clarity.

In this instance pushing the locking is trivial. Do you really want it
gone?

.. and looking at this, I feel justified in this position, because
I noticed a bug in how flags is manipulated.

This:

static int ipoib_mcast_join_finish(struct ipoib_mcast *mcast,
				   struct ib_sa_mcmember_rec *mcmember)
{
[..]
		if (test_and_set_bit(IPOIB_MCAST_FLAG_ATTACHED, &mcast->flags)) {
[..]
			clear_bit(IPOIB_MCAST_FLAG_ATTACHED, &mcast->flags);
			return ret;
		}

Has two unlocked sets for flags. The above is called directly from
the sa callback.

While, the clear_bit/etc in ipoib_mcast_restart_task has a lock held
and no obvious exclusion with the above (the mcast is on the
multicast_list by now)..

Sure looks like these two race:

		if (test_and_set_bit(IPOIB_MCAST_FLAG_ATTACHED, &mcast->flags))..
		clear_bit(IPOIB_MCAST_FLAG_FOUND, &mcast->flags);

Resulting in corruption of the flags.

This ugly untested thing sort it..

>From ccfc99859d221ea4dada20e388d50e2cc6be580c Mon Sep 17 00:00:00 2001
From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Date: Tue, 25 Aug 2015 13:27:02 -0600
Subject: [PATCH] IB/ipoib: Do not write to mcast->flags without holding a lock

At a minimum the ipoib_mcast_restart_task could be called at any
time and it will also write the flags resulting in corruption
of the flags value.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 drivers/infiniband/ulp/ipoib/ipoib_multicast.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
index 2d43ec542b63..077586a867bf 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
@@ -219,9 +219,9 @@ static int ipoib_mcast_join_finish(struct ipoib_mcast *mcast,
 	/* Set the multicast MTU and cached Q_Key before we attach if it's
 	 * the broadcast group.
 	 */
+	spin_lock_irq(&priv->lock);
 	if (!memcmp(mcast->mcmember.mgid.raw, priv->dev->broadcast + 4,
 		    sizeof (union ib_gid))) {
-		spin_lock_irq(&priv->lock);
 		if (!priv->broadcast) {
 			spin_unlock_irq(&priv->lock);
 			return -EAGAIN;
@@ -244,7 +244,6 @@ static int ipoib_mcast_join_finish(struct ipoib_mcast *mcast,
 			IPOIB_UD_MTU(ib_mtu_enum_to_int(priv->broadcast->mcmember.mtu));
 
 		priv->qkey = be32_to_cpu(priv->broadcast->mcmember.qkey);
-		spin_unlock_irq(&priv->lock);
 		priv->tx_wr.wr.ud.remote_qkey = priv->qkey;
 		set_qkey = 1;
 	}
@@ -254,19 +253,24 @@ static int ipoib_mcast_join_finish(struct ipoib_mcast *mcast,
 			ipoib_warn(priv, "multicast group %pI6 already attached\n",
 				   mcast->mcmember.mgid.raw);
 
+			spin_unlock_irq(&priv->lock);
 			return 0;
 		}
 
+		spin_unlock_irq(&priv->lock);
 		ret = ipoib_mcast_attach(dev, be16_to_cpu(mcast->mcmember.mlid),
 					 &mcast->mcmember.mgid, set_qkey);
 		if (ret < 0) {
 			ipoib_warn(priv, "couldn't attach QP to multicast group %pI6\n",
 				   mcast->mcmember.mgid.raw);
 
+			spin_lock_irq(&priv->lock);
 			clear_bit(IPOIB_MCAST_FLAG_ATTACHED, &mcast->flags);
+			spin_unlock_irq(&priv->lock);
 			return ret;
 		}
-	}
+	} else
+		spin_unlock_irq(&priv->lock);
 
 	{
 		struct ib_ah_attr av = {
-- 
2.1.4


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
