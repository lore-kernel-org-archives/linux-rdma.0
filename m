From: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Patch series from Dec 2009 which needs reviewing/applying
Date: Thu, 4 Feb 2010 10:59:08 +0200
Message-ID: <201002041059.09368.jackm@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tziporet Koren <tziporet-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Roland,

Could you please review (and hopefully apply) the following patch series I submitted
on Dec 17, 2009? These are really small patches.

The series seems to have "fallen between the cracks".

Thanks!
-Jack

[PATCH 0/2] fix SRQ WQE buffer initialization in liblmx4 and in mlx4_ib
http://www.spinics.net/lists/linux-rdma/msg01911.html

[PATCH 1/2] libmlx4: initialize SRQ scatter entries when creating an SRQ
http://www.spinics.net/lists/linux-rdma/msg01912.html

[PATCH 2/2] mlx4_ib: initialize SRQ scatter entries when creating an SRQ
http://www.spinics.net/lists/linux-rdma/msg01910.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
