From: Nicolas Morey-Chaisemartin <nmoreychaisemartin-IBi9RG/b67k@public.gmane.org>
Subject: [PATCHv2 rdma-core 0/2] srp_daemon fixes
Date: Wed, 13 Dec 2017 13:30:32 +0100
Message-ID: <001cdcfd-8ace-261f-ab86-a09ae3582dd8@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: fr-xx-classique+reforme1990
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org, stable-Xl5UnYtxxKxKUA01WzcqbQ@public.gmane.org, bvanassche-HInyCGIudOg@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This patch series fixes two issues of srp_daemon which occur when the master SM switches.
Both causes a failure to register to SM traps.

Changes since v1:
Patch#1
- Add Fixes tag to commit log
Patch#2
- Add comment on return codes of poll_cq_once
- Fix poll_cq behaviour when poll_cq_once returns an error

Nicolas Morey-Chaisemartin (2):
  srp_daemon: handle SM lid change
  srp_daemon: fix CQ handling

 srp_daemon/srp_daemon.c       | 10 ++++---
 srp_daemon/srp_daemon.h       |  2 +-
 srp_daemon/srp_handle_traps.c | 65 +++++++++++++++++++++++++++++++++----------
 3 files changed, 58 insertions(+), 19 deletions(-)

-- 
2.15.1.272.g8e603414b

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
