From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH 0/2] perfquery: PortExtendedSpeedsCounters fixes
Date: Thu, 01 Dec 2011 11:21:06 -0500
Message-ID: <4ED7A972.2020608@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This series fixes a couple of bugs with PortExtendedSpeedsCounters
support in perfquery.

The patches were done against the 1.5 branch but they also should apply
to master (1.6 series) as well.

[PATCH 1/2] infiniband-diags/perfquery.c: Fix display of
PortExtendedSpeedsCounters

[PATCH 2/2] infiniband-diags/perfquery.c: Fix reset for
PortExtendedSpeedsCounters

-- Hal
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
