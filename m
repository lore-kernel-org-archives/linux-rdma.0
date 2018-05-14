From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH net] qede: Fix ref-cnt usage count
Date: Sun, 13 May 2018 20:27:59 -0400 (EDT)
Message-ID: <20180513.202759.122123618609853060.davem@davemloft.net>
References: <20180513175406.21350-1-Michal.Kalderon@cavium.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180513175406.21350-1-Michal.Kalderon@cavium.com>
Sender: netdev-owner@vger.kernel.org
To: Michal.Kalderon@cavium.com
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, chad.dupuis@cavium.com, ariel.elior@cavium.com
List-Id: linux-rdma@vger.kernel.org

From: Michal Kalderon <Michal.Kalderon@cavium.com>
Date: Sun, 13 May 2018 20:54:06 +0300

> Rebooting while qedr is loaded with a VLAN interface present
> results in unregister_netdevice waiting for the usage count
> to become free.
> The fix is that rdma devices should be removed before unregistering
> the netdevice, to assure all references to ndev are decreased.
> 
> Fixes: cee9fbd8e2e9 ("qede: Add qedr framework")
> Signed-off-by: Ariel Elior <ariel.elior@cavium.com>
> Signed-off-by: Michal Kalderon <michal.kalderon@cavium.com>

Applied.
