From: Ursula Braun <ubraun@linux.ibm.com>
Subject: [PATCH net 0/4] net/smc: fixes 2019-02-04
Date: Mon,  4 Feb 2019 13:44:43 +0100
Message-ID: <20190204124447.39816-1-ubraun@linux.ibm.com>
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
To: davem@davemloft.net
Cc: netdev@vger.kernel.org, linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, raspl@linux.ibm.com, ubraun@linux.ibm.com
List-Id: linux-rdma@vger.kernel.org

Dave,

here are more fixes in the smc code for the net tree:
Patch 1 fixes an IB-related problem with SMCR.
Patch 2 fixes a cursor problem for one-way traffic.
Patch 3 fixes a problem with RMB-reusage.
Patch 4 fixes a closing issue.

Thanks, Ursula

Ursula Braun (4):
  net/smc: preallocated memory for rdma work requests
  net/smc: fix sender_free computation
  net/smc: delete rkey first before switching to unused
  net/smc: correct state change for peer closing

 net/smc/smc_cdc.c   | 16 ++++++----------
 net/smc/smc_cdc.h   | 34 ++++++++++++++++++++++++++++++++--
 net/smc/smc_close.c |  9 +--------
 net/smc/smc_core.c  |  2 +-
 net/smc/smc_core.h  | 20 ++++++++++++++++++++
 net/smc/smc_llc.c   |  3 ++-
 net/smc/smc_tx.c    | 47 ++++++++++++++++++++++++-----------------------
 net/smc/smc_wr.c    | 38 +++++++++++++++++++++++++++++++++++++-
 net/smc/smc_wr.h    |  1 +
 9 files changed, 124 insertions(+), 46 deletions(-)

-- 
2.16.4
