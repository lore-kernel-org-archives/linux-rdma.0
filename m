From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH net-next 00/10] net/smc: get rid of unsafe_global_rkey
Date: Sat, 29 Jul 2017 11:23:16 -0700 (PDT)
Message-ID: <20170729.112316.596199895398096388.davem@davemloft.net>
References: <20170728115622.17247-1-ubraun@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20170728115622.17247-1-ubraun@linux.vnet.ibm.com>
Sender: netdev-owner@vger.kernel.org
To: ubraun@linux.vnet.ibm.com
Cc: hch@lst.de, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, linux-s390@vger.kernel.org, jwi@linux.vnet.ibm.com, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, raspl@linux.vnet.ibm.com
List-Id: linux-rdma@vger.kernel.org

From: Ursula Braun <ubraun@linux.vnet.ibm.com>
Date: Fri, 28 Jul 2017 13:56:12 +0200

> The smc code uses the unsafe_global_rkey, exposing all memory for
> remote reads and writes once a connection is established.
> Here is now a patch series to get rid of unsafe_global_rkey usage.
> Main idea is to switch to SG-logic and separate memory regions for RMBs.

Series applied, thanks.
