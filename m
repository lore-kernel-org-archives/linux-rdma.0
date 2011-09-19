From: Marcel Apfelbaum <marcela-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH RFC 0/4] adding support for FDR/FDR-10 link speed
Date: Mon, 19 Sep 2011 19:05:46 +0300
Message-ID: <201109191905.46824.marcela@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The purpose of the RFC is to introduce FDR/FDR-10:
 - FDR10 is a proprietary link speed which is 10.3125 Gbps at 64/66 encoding rather than 8b10b encoding.
 - FDR represents an extended speed: 14.0625 Gbps
 - EDR represents an extended speed: 25.78125 Gbps (EDR)

The aim is to show correct speeds and link encoding in:
  - Ibstat
  - Ibv_devinfo
  - /sys/class/infiniband/mlx4_0/ports/1/rate
  - Other user space modules

[PATCH RFC 1/4] ib/core: handle EDR/FDR extended speeds
Handle EDR/FDR extended speeds.
Extended speeds are introduced and a new formula is used for speed computation (because of different encodings)

[PATCH RFC 2/4] ib/core: handle FDR-10 link encoding
Deals with issues related to FDR-10 link encoding:
For QDR with FDR-10 encoding,  the rate is change accordingly to LinkEncodingEnable flag

[PATCH RFC 3/4] ib/mlx4: get extended active speed from port info
Gets extended active speed from Port Info packet(used for FDR/EDR)

[PATCH RFC 4/4] ib/mlx4: get extended port capabilities
An Extended Port Info packet is sent to each hw port during HCA init and if returns wihtout error it is assumed the port supports extended port capabilities.

If the port supports extended capabilities and the active speed is QDR, FDR-10 link encoding is set according to Extended Port Info.


Marcel
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
