From: Ursula Braun <ubraun@linux.vnet.ibm.com>
Subject: [PATCH net 0/9] net/smc: bug fixes 2017-09-20
Date: Thu, 21 Sep 2017 09:16:25 +0200
Message-ID: <20170921071634.16883-1-ubraun@linux.vnet.ibm.com>
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
To: davem@davemloft.net
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, linux-s390@vger.kernel.org, jwi@linux.vnet.ibm.com, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, raspl@linux.vnet.ibm.com, ubraun@linux.vnet.ibm.com
List-Id: linux-rdma@vger.kernel.org

Hi Dave,

here is a collection of small smc-patches built for net fixing
smc problems in different areas.

Thanks,
Ursula
*** BLURB HERE ***

Hans Wippel (2):
  net/smc: add missing dev_put
  net/smc: add receive timeout check

Ursula Braun (7):
  net/smc: take RCU read lock for routing cache lookup
  net/smc: adjust net_device refcount
  net/smc: adapt send request completion notification
  net/smc: longer delay for client link group removal
  net/smc: terminate link group if out-of-sync is received
  net/smc: introduce a delay
  net/smc: no close wait in case of process shut down

 net/smc/af_smc.c    | 16 +++++++++-------
 net/smc/smc.h       |  2 +-
 net/smc/smc_clc.c   | 10 +++++-----
 net/smc/smc_clc.h   |  3 +--
 net/smc/smc_close.c | 27 +++++++++++++++------------
 net/smc/smc_core.c  | 16 ++++++++++++----
 net/smc/smc_ib.c    |  1 +
 net/smc/smc_pnet.c  |  4 +++-
 net/smc/smc_rx.c    |  2 ++
 net/smc/smc_tx.c    | 12 ++++++++----
 net/smc/smc_wr.c    |  2 +-
 11 files changed, 58 insertions(+), 37 deletions(-)

-- 
2.13.5
