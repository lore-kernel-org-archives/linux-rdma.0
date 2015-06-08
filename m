From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next V5 04/12] net/ipv6: Export addrconf_ifid_eui48
Date: Mon,  8 Jun 2015 17:12:07 +0300
Message-ID: <1433772735-22416-5-git-send-email-matanb@mellanox.com>
References: <1433772735-22416-1-git-send-email-matanb@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1433772735-22416-1-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Somnath Kotur <Somnath.Kotur-xCNTGe7nOvUAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

RoCE devices would like to have a default GID even
when the interface is down. In order to do so,
we use the IPv6 link local address as a default
GID. addrconf_ifid_eui48 is used to gernerate
this address.

Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 include/net/addrconf.h | 31 +++++++++++++++++++++++++++++++
 net/ipv6/addrconf.c    | 31 -------------------------------
 2 files changed, 31 insertions(+), 31 deletions(-)

diff --git a/include/net/addrconf.h b/include/net/addrconf.h
index 80456f7..89890e7 100644
--- a/include/net/addrconf.h
+++ b/include/net/addrconf.h
@@ -91,6 +91,37 @@ int ipv6_rcv_saddr_equal(const struct sock *sk, const struct sock *sk2);
 void addrconf_join_solict(struct net_device *dev, const struct in6_addr *addr);
 void addrconf_leave_solict(struct inet6_dev *idev, const struct in6_addr *addr);
 
+static inline int addrconf_ifid_eui48(u8 *eui, struct net_device *dev)
+{
+	if (dev->addr_len != ETH_ALEN)
+		return -1;
+	memcpy(eui, dev->dev_addr, 3);
+	memcpy(eui + 5, dev->dev_addr + 3, 3);
+
+	/*
+	 * The zSeries OSA network cards can be shared among various
+	 * OS instances, but the OSA cards have only one MAC address.
+	 * This leads to duplicate address conflicts in conjunction
+	 * with IPv6 if more than one instance uses the same card.
+	 *
+	 * The driver for these cards can deliver a unique 16-bit
+	 * identifier for each instance sharing the same card.  It is
+	 * placed instead of 0xFFFE in the interface identifier.  The
+	 * "u" bit of the interface identifier is not inverted in this
+	 * case.  Hence the resulting interface identifier has local
+	 * scope according to RFC2373.
+	 */
+	if (dev->dev_id) {
+		eui[3] = (dev->dev_id >> 8) & 0xFF;
+		eui[4] = dev->dev_id & 0xFF;
+	} else {
+		eui[3] = 0xFF;
+		eui[4] = 0xFE;
+		eui[0] ^= 2;
+	}
+	return 0;
+}
+
 static inline unsigned long addrconf_timeout_fixup(u32 timeout,
 						   unsigned int unit)
 {
diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index 37b70e8..7170c7b 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -1845,37 +1845,6 @@ static void addrconf_leave_anycast(struct inet6_ifaddr *ifp)
 	__ipv6_dev_ac_dec(ifp->idev, &addr);
 }
 
-static int addrconf_ifid_eui48(u8 *eui, struct net_device *dev)
-{
-	if (dev->addr_len != ETH_ALEN)
-		return -1;
-	memcpy(eui, dev->dev_addr, 3);
-	memcpy(eui + 5, dev->dev_addr + 3, 3);
-
-	/*
-	 * The zSeries OSA network cards can be shared among various
-	 * OS instances, but the OSA cards have only one MAC address.
-	 * This leads to duplicate address conflicts in conjunction
-	 * with IPv6 if more than one instance uses the same card.
-	 *
-	 * The driver for these cards can deliver a unique 16-bit
-	 * identifier for each instance sharing the same card.  It is
-	 * placed instead of 0xFFFE in the interface identifier.  The
-	 * "u" bit of the interface identifier is not inverted in this
-	 * case.  Hence the resulting interface identifier has local
-	 * scope according to RFC2373.
-	 */
-	if (dev->dev_id) {
-		eui[3] = (dev->dev_id >> 8) & 0xFF;
-		eui[4] = dev->dev_id & 0xFF;
-	} else {
-		eui[3] = 0xFF;
-		eui[4] = 0xFE;
-		eui[0] ^= 2;
-	}
-	return 0;
-}
-
 static int addrconf_ifid_eui64(u8 *eui, struct net_device *dev)
 {
 	if (dev->addr_len != IEEE802154_ADDR_LEN)
-- 
2.1.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
