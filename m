From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH 0/4] opensm: Add mtu validation to SA
Date: Tue, 04 Oct 2011 09:53:03 -0400
Message-ID: <4E8B0FBF.3070606@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The following patch series adds MTU validation to SA and is similar to the previous series on rate validation.

[PATCH 1/4] opensm/osm_helper: Add ib_mtu_is_valid
[PATCH 2/4] opensm/osm_sa_path_record.c: Add mtu validation if supplied
[PATCH 3/4] opensm/osm_sa_mcmember_record.c: Add mtu validation if supplied
[PATCH 4/4] opensm/osm_sa_multipath_record.c: Add mtu validation if supplied
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
