From: Ursula Braun <ubraun@linux.vnet.ibm.com>
Subject: [PATCH net-next 0/5] net/smc: fixes 2018-01-26
Date: Fri, 26 Jan 2018 09:28:45 +0100
Message-ID: <20180126082850.20655-1-ubraun@linux.vnet.ibm.com>
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
To: davem@davemloft.net
Cc: netdev@vger.kernel.org, linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org, jwi@linux.vnet.ibm.com, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, raspl@linux.vnet.ibm.com, ubraun@linux.vnet.ibm.com
List-Id: linux-rdma@vger.kernel.org

Dave,

here are some more smc patches. The first 4 patches take care about
different aspects of smc socket closing, the 5th patch improves
coding style.

Thanks, Ursula

Gustavo A. R. Silva (1):
  smc: return booleans instead of integers

Ursula Braun (4):
  net/smc: handle device, port, and QP error events
  net/smc: smc_poll improvements
  net/smc: replace sock_put worker by socket refcounting
  net/smc: release clcsock from tcp_listen_worker

 net/smc/af_smc.c    | 152 ++++++++++++++++++++++++++++++----------------------
 net/smc/smc.h       |   5 +-
 net/smc/smc_cdc.c   |  20 +++----
 net/smc/smc_close.c |  96 +++++++++++++++++++++------------
 net/smc/smc_close.h |   1 -
 net/smc/smc_core.c  |   6 +--
 net/smc/smc_ib.c    |  38 ++++++++-----
 7 files changed, 191 insertions(+), 127 deletions(-)

-- 
2.13.5
