From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH 00/33] net: ethernet: Mark expected switch fall-throughs
Date: Tue, 07 Aug 2018 17:59:31 -0700 (PDT)
Message-ID: <20180807.175931.200772329178253653.davem@davemloft.net>
References: <cover.1533675546.git.gustavo@embeddedor.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1533675546.git.gustavo@embeddedor.com>
Sender: linux-kernel-owner@vger.kernel.org
To: gustavo@embeddedor.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, linux-net-drivers@solarflare.com, ecree@solarflare.com, bkenward@solarflare.com, jes@trained-monkey.org, linux-acenic@sunsite.dk, michael.chan@broadcom.com, nicolas.ferre@microchip.com, derek.chickles@caviumnetworks.com, satananda.burla@caviumnetworks.com, felix.manlunas@caviumnetworks.com, raghu.vatsavayi@caviumnetworks.com, ganeshgr@chelsio.com, santosh@chelsio.com, sgoutham@cavium.com, rric@kernel.org, linux-arm-kernel@lists.infradead.org, linux-parisc@vger.kernel.org, sathya.perla@broadcom.com, ajit.khaparde@broadcom.com, sriharsha.basavapatna@broadcom.com, somnath.kotur@broadcom.com, yisen.zhuang@huawei.com, salil.mehta@huawei.com, jeffrey.t.kirsher@intel.com, intel-wired-lan@lists.osuosl.org, tariqt@mellanox.coml
List-Id: linux-rdma@vger.kernel.org

From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Date: Tue, 7 Aug 2018 18:09:00 -0500

> In preparation to enabling -Wimplicit-fallthrough, this patchset aims
> to add some annotations in order to mark switch cases where we are
> expecting to fall through.

Ok, I went through all of these and they look good.

If any are not correct we can revert/fix.

Series applied, thanks.
