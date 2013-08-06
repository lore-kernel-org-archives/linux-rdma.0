From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH ibacm 0/8} PKey and QKey related ACM fixes
Date: Tue, 06 Aug 2013 07:45:06 -0400
Message-ID: <5200E1C2.4010300@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Miscellaneous fixes for P_Key and Q_Key handling in ACM.

Hal Rosenstock (8):
  libacm.c: Remove unneeded structures
  acm.c: In acm_port_up, handle noncontiguous pkeys
  acm.c: Invalid pkey has low order 15 bits 0
  acm.c: Fix endian of transaction ID
  acm.c: Make sure MGID has full member pkey bit on
  acm.c: Send multicast joins to SA on default partition
  acm.c: Fix endian of qkey in MCMemberRecord in acm_init_join
  acm.c: In acm_join_group, no need to set qkey in umad addr to send to
    SA

 src/acm.c    |   38 ++++++++++++++++++++++++--------------
 src/libacm.c |   15 ---------------
 2 files changed, 24 insertions(+), 29 deletions(-)

-- 
1.7.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
