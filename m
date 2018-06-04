From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH net-next v2] qed: Add srq core support for RoCE and
 iWARP
Date: Mon, 04 Jun 2018 17:12:15 -0400 (EDT)
Message-ID: <20180604.171215.1900107573480185166.davem@davemloft.net>
References: <20180603161307.29832-1-yuval.bason@cavium.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180603161307.29832-1-yuval.bason@cavium.com>
Sender: netdev-owner@vger.kernel.org
To: yuval.bason@cavium.com
Cc: netdev@vger.kernel.org, jgg@mellanox.com, dledford@redhat.com, linux-rdma@vger.kernel.org, michal.kalderon@cavium.com, ariel.elior@cavium.com
List-Id: linux-rdma@vger.kernel.org

From: Yuval Bason <yuval.bason@cavium.com>
Date: Sun, 3 Jun 2018 19:13:07 +0300

> This patch adds support for configuring SRQ and provides the necessary
> APIs for rdma upper layer driver (qedr) to enable the SRQ feature.
> 
> Signed-off-by: Michal Kalderon <michal.kalderon@cavium.com>
> Signed-off-by: Ariel Elior <ariel.elior@cavium.com>
> Signed-off-by: Yuval Bason <yuval.bason@cavium.com>
> ---
> Changes from v1:
> 	- sparse warnings
> 	- replace memset with ={}

Applied, thanks.
