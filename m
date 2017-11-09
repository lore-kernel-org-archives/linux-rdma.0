From: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Subject: [PATCH v1 rdma-core 0/2] libbnxt_re bug fixes
Date: Thu,  9 Nov 2017 06:10:38 -0500
Message-ID: <1510225840-20034-1-git-send-email-devesh.sharma@broadcom.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This patch series contains important bug fixes.
Patch 1 address the memory barrier changes Jason
asked while reviewing a similar change in bnxt_re
driver.

Patch 2 is another fix found during internal testing.

Devesh Sharma (2):
  bnxt_re/lib: fix the memory barrier call during poll-cq
  bnxt_re/lib:increment psn in case of 0 length packets

 providers/bnxt_re/main.h  | 8 ++++++--
 providers/bnxt_re/verbs.c | 2 ++
 2 files changed, 8 insertions(+), 2 deletions(-)

-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
