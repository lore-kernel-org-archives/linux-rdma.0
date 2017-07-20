From: Ursula Braun <ubraun-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: [RFC net-next 00/10] net/smc: get rid of unsafe_global_rkey
Date: Thu, 20 Jul 2017 14:09:36 +0200
Message-ID: <20170720120946.67234-1-ubraun@linux.vnet.ibm.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: hch-jcswGhMUV9g@public.gmane.org, schwidefsky-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org, heiko.carstens-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org, hwippel-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, raspl-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, ubraun-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The smc code uses the unsafe_global_rkey, exposing all memory for
remote reads and writes once a connection is established.
Here is now a patch series to get rid of unsafe_global_rkey usage.
Main idea is to switch to SG-logic and separate memory regions for RMBs.

Before final submission to the net-Maintainer I would like to get early
feedback from the RDMA-experts, especially for the main patches:
  03/10 net/smc: introduce sg-logic for RMBs
  04/10 net/smc: use separate memory regions for RMBs
  05/10 net/smc: register RMB-related memory region
  10/10 net/smc: synchronize buffer usage with device

Thanks, Ursula


Ursula Braun (10):
  net/smc: serialize connection creation in all cases
  net/smc: shorten local bufsize variables
  net/smc: introduce sg-logic for RMBs
  net/smc: use separate memory regions for RMBs
  net/smc: register RMB-related memory region
  net/smc: remove Kconfig warning
  net/smc: introduce sg-logic for send buffers
  net/smc: common functions for RMBs and send buffers
  net/smc: cleanup function __smc_buf_create()
  net/smc: synchronize buffer usage with device

 net/smc/Kconfig    |   4 -
 net/smc/af_smc.c   |  64 ++++++---
 net/smc/smc_clc.c  |  12 +-
 net/smc/smc_core.c | 392 +++++++++++++++++++++++++++++------------------------
 net/smc/smc_core.h |  31 +++--
 net/smc/smc_ib.c   | 125 ++++++++++++++---
 net/smc/smc_ib.h   |  19 ++-
 net/smc/smc_rx.c   |   3 +
 net/smc/smc_tx.c   |   9 +-
 net/smc/smc_wr.c   |  63 +++++++++
 net/smc/smc_wr.h   |   1 +
 11 files changed, 476 insertions(+), 247 deletions(-)

-- 
2.11.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
