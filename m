From: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Subject: Re: [PATCH] RDMA/ocrdma: Fixed CONFIG_VLAN_8021Q.
Date: Fri, 10 Aug 2012 16:58:44 -0700
Message-ID: <CAL1RGDWnJLNwL4PBJyNLXSUUpLugtuwrCrPHuDavB+Bx7cqGgw@mail.gmail.com>
References: <9ac93bde-c809-45c2-86e2-a50ea6a1020f@exht1.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <9ac93bde-c809-45c2-86e2-a50ea6a1020f-nbYkmrCdWxmgMrCBcu8zE0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Parav Pandit <parav.pandit-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Fri, Aug 10, 2012 at 9:28 AM, Parav Pandit <parav.pandit-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org> wrote:
> Fixed avoiding checking real vlan dev in scenario
> when VLAN is disabled and ipv6 is enabled.

It would be a nice touch to acknowledge Fengguang with a Reported-by:

> Signed-off-by: Parav Pandit <parav.pandit-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
> ---
>  drivers/infiniband/hw/ocrdma/ocrdma_main.c |   16 ++++++++++++----
>  1 files changed, 12 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_main.c b/drivers/infiniband/hw/ocrdma/ocrdma_main.c
> index 5a04452..7146ffd 100644
> --- a/drivers/infiniband/hw/ocrdma/ocrdma_main.c
> +++ b/drivers/infiniband/hw/ocrdma/ocrdma_main.c
> @@ -161,7 +161,7 @@ static void ocrdma_add_default_sgid(struct ocrdma_dev *dev)
>         ocrdma_get_guid(dev, &sgid->raw[8]);
>  }
>
> -#if defined(CONFIG_VLAN_8021Q) || defined(CONFIG_VLAN_8021Q_MODULE)
> +#if IS_ENABLED(CONFIG_VLAN_8021Q) || IS_ENABLED(CONFIG_VLAN_8021Q_MODULE)

a single IS_ENABLED() tests both CONFIG_xxx and CONFIG_xxx_MODULE

>  static void ocrdma_add_vlan_sgids(struct ocrdma_dev *dev)
>  {
>         struct net_device *netdev, *tmp;
> @@ -202,8 +202,16 @@ static int ocrdma_build_sgid_tbl(struct ocrdma_dev *dev)
>         return 0;
>  }
>
> -#if IS_ENABLED(CONFIG_IPV6) || IS_ENABLED(CONFIG_VLAN_8021Q)
> +static struct net_device *ocrdma_get_real_netdev(struct net_device *netdev)
> +{
> +#if IS_ENABLED(CONFIG_VLAN_8021Q) || IS_ENABLED(CONFIG_VLAN_8021Q_MODULE)
> +       return vlan_dev_real_dev(netdev);
> +#else
> +       return netdev;
> +#endif
> +}

This is kind of crazy: it's a big helper that you only use in one
spot, and the whole point of IS_ENABLED() is that it is usable in C
code too -- so you could at least write this without using the
preprocessor.  But I don't think it really helps to split out this
wrapper.

> +#if IS_ENABLED(CONFIG_IPV6)
>  static int ocrdma_inet6addr_event(struct notifier_block *notifier,
>                                   unsigned long event, void *ptr)
>  {
> @@ -217,7 +225,7 @@ static int ocrdma_inet6addr_event(struct notifier_block *notifier,
>         bool is_vlan = false;
>         u16 vid = 0;
>
> -       netdev = vlan_dev_real_dev(event_netdev);
> +       netdev = ocrdma_get_real_netdev(event_netdev);
>         if (netdev != event_netdev) {
>                 is_vlan = true;
>                 vid = vlan_dev_vlan_id(event_netdev);
> @@ -262,7 +270,7 @@ static struct notifier_block ocrdma_inet6addr_notifier = {
>         .notifier_call = ocrdma_inet6addr_event
>  };
>
> -#endif /* IPV6 and VLAN */
> +#endif /* IPV6 */
>
>  static enum rdma_link_layer ocrdma_link_layer(struct ib_device *device,
>                                               u8 port_num)

How about this simpler version:

>From d549f55f2e132e3d1f1288ce4231f45f12988bbf Mon Sep 17 00:00:00 2001
From: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Date: Fri, 10 Aug 2012 16:52:13 -0700
Subject: [PATCH] RDMA/ocrdma: Don't call vlan_dev_real_dev() for non-VLAN
 netdevs

If CONFIG_VLAN_8021Q is not set, then vlan_dev_real_dev() just goes BUG(),
so we shouldn't call it unless we're actually dealing with a VLAN netdev.

Reported-by: Fengguang Wu <fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
---
 drivers/infiniband/hw/ocrdma/ocrdma_main.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_main.c
b/drivers/infiniband/hw/ocrdma/ocrdma_main.c
index 5a04452..c4e0131 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_main.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_main.c
@@ -161,7 +161,7 @@ static void ocrdma_add_default_sgid(struct ocrdma_dev *dev)
 	ocrdma_get_guid(dev, &sgid->raw[8]);
 }

-#if defined(CONFIG_VLAN_8021Q) || defined(CONFIG_VLAN_8021Q_MODULE)
+#if IS_ENABLED(CONFIG_VLAN_8021Q)
 static void ocrdma_add_vlan_sgids(struct ocrdma_dev *dev)
 {
 	struct net_device *netdev, *tmp;
@@ -202,14 +202,13 @@ static int ocrdma_build_sgid_tbl(struct ocrdma_dev *dev)
 	return 0;
 }

-#if IS_ENABLED(CONFIG_IPV6) || IS_ENABLED(CONFIG_VLAN_8021Q)
+#if IS_ENABLED(CONFIG_IPV6)

 static int ocrdma_inet6addr_event(struct notifier_block *notifier,
 				  unsigned long event, void *ptr)
 {
 	struct inet6_ifaddr *ifa = (struct inet6_ifaddr *)ptr;
-	struct net_device *event_netdev = ifa->idev->dev;
-	struct net_device *netdev = NULL;
+	struct net_device *netdev = ifa->idev->dev;
 	struct ib_event gid_event;
 	struct ocrdma_dev *dev;
 	bool found = false;
@@ -217,11 +216,12 @@ static int ocrdma_inet6addr_event(struct
notifier_block *notifier,
 	bool is_vlan = false;
 	u16 vid = 0;

-	netdev = vlan_dev_real_dev(event_netdev);
-	if (netdev != event_netdev) {
-		is_vlan = true;
-		vid = vlan_dev_vlan_id(event_netdev);
+	is_vlan = netdev->priv_flags & IFF_802_1Q_VLAN;
+	if (is_vlan) {
+		vid = vlan_dev_vlan_id(netdev);
+		netdev = vlan_dev_real_dev(netdev);
 	}
+
 	rcu_read_lock();
 	list_for_each_entry_rcu(dev, &ocrdma_dev_list, entry) {
 		if (dev->nic_info.netdev == netdev) {
-- 
1.7.10.4
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
