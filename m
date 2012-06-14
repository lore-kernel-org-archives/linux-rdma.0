From: Pradeep Satyanarayana <pradeeps-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: rsockets and other performance
Date: Thu, 14 Jun 2012 08:24:35 -0700
Message-ID: <4FDA0233.6090409@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, kashyapv-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org, sri-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Traditional sockets based applications wanting high throughput could use 
rsockets Since it is layered on top of uverbs we expected to see good 
throughput numbers.
So, we started to run netperf and iperf. We observed that it tops off at 
about 20Gb/s with QDR adapters. A quick "perf top" revealed a lot of 
cycles spent in memcpy().
We had hoped these numbers would be somewhat higher since we did not 
expect the memcpy() to have such a large overhead.

Given the copy overhead, we wanted to revisit the IPoIB and SDP 
performance. Hence we installed to OFED-1.5.4.1 on RHEL 6.2. We found 
that for small packets SDP starts
with low throughputs, but seems to catch up with rsockets at about 16 KB 
packets. On the other hand IPoIB CM tops off at about 10 Gb/s.

Since SDP does in kernel RDMA we expected IPoIB CM and SDP numbers to be 
much closer. Again "perf top" revealed that IPoIB was spending a large 
number of cycles in
checksum computation. Out of curiosity Sridhar made the following changes:

--- ipoib_cm.c.orig    2012-06-10 15:27:10.589325138 -0400
+++ ipoib_cm.c    2012-06-12 11:29:49.073262516 -0400
@@ -670,6 +670,7 @@ copied:
      skb->dev = dev;
      /* XXX get correct PACKET_ type here */
      skb->pkt_type = PACKET_HOST;
+    skb->ip_summed = CHECKSUM_UNNECESSARY;
      netif_receive_skb(skb);

@@ -1464,7 +1464,8 @@ static ssize_t set_mode(struct device *d
                 "will cause multicast packet drops\n");

          rtnl_lock();
-        dev->features &= ~(NETIF_F_IP_CSUM | NETIF_F_SG | NETIF_F_TSO);
+        dev->features &= ~(NETIF_F_SG | NETIF_F_TSO);
          priv->tx_wr.send_flags &= ~IB_SEND_IP_CSUM;

          if (ipoib_cm_max_mtu(dev) > priv->mcast_mtu)


With these minimal changes IPoIB throughput reached between 19-20Gb/s 
with just 2 threads. This was really unexpected. Given that, we wanted 
to revisit the usage of checksums in IPoIB.
So, it looks worthwhile to allow for 'checksum-less' IPoIB-CM within a 
cluster on a single subnet. From a checksum perspective, this would be 
no different from RDMA. What are your thoughts?

Thanks
Pradeep

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
