From: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH v1 0/2] On-demand paging minor fixes
Date: Tue,  6 Jan 2015 13:56:00 +0200
Message-ID: <1420545362-18571-1-git-send-email-haggaie@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Roland,

I've updated these patches' commit message and subject lines with some style
changed following comments from Or Gerlitz. They contain fixes for minor issues
with the on-demand paging patchset. I hope you can accept them for v3.19-rc4.

Regards,
Haggai

Haggai Eran (1):
  IB/core: Properly handle registration of on-demand paging MRs after
    dereg

Majd Dibbiny (1):
  IB/mlx5: Update the dev in reg_create

 drivers/infiniband/core/umem_odp.c | 3 ++-
 drivers/infiniband/hw/mlx5/mr.c    | 1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

-- 
1.7.11.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
