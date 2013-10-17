From: Bernd Schubert <bernd.schubert-mPn0NPGs4xGatNDF+KUbs4QuADTiUCJX@public.gmane.org>
Subject: [PATCH 0/2] opensm partition.conf issues
Date: Thu, 17 Oct 2013 13:10:41 +0200
Message-ID: <20131017111041.177713.61634.stgit@fsdevel2>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Without an partition.conf file opensm filled the log file with error messages
on every sweep.

Sep 27 18:21:47 917409 [6A60D700] 0x01 -> osm_prtn_make_partitions: Partition configuration /etc/opensm/partitions.conf is not accessible (No such file or directory)
Sep 27 18:21:47 918994 [6A60D700] 0x02 -> SUBNET UP
Sep 27 18:22:07 917436 [6A60D700] 0x01 -> osm_prtn_make_partitions: Partition configuration /etc/opensm/partitions.conf is not accessible (No such file or directory)
Sep 27 18:22:07 918979 [6A60D700] 0x02 -> SUBNET UP

With an empty partition file opensm didn't bring up the fabric properly, resulting
in endless kernel messages
ib0: multicast join failed for ff12:401b:ffff:0000:0000:0000:ffff:ffff, status -22

opensm.log file had lots of these message
Oct 17 09:31:38 461345 [67EC4700] 0x01 -> mcmr_rcv_join_mgrp: ERR 1B11: method = SubnAdmSet, scope_state = 0x1, component mask = 0x0000000000010083, expected comp mask = 0x000000
00000130c7, MGID: ff12:401b:ffff::ffff:ffff from port 0x0002c9030036dd21 (MT25408 ConnectX Mellanox Technologies)
Oct 17 09:31:38 505122 [66EC2700] 0x01 -> mcmr_rcv_join_mgrp: ERR 1B11: method = SubnAdmSet, scope_state = 0x1, component mask = 0x0000000000010083, expected comp mask = 0x000000
00000130c7, MGID: ff12:401b:ffff::ffff:ffff from port 0x0002c90300f4d6d1 (MT25408 ConnectX Mellanox Technologies)
Oct 17 09:31:46 294201 [5D6AF700] 0x02 -> SUBNET UP

So here are two patches to reduce the log level and to try the default 
partition configuration if there is not a single valid config line.


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
