From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH] net/smc: mark as BROKEN due to remote memory exposure
Date: Sun, 14 May 2017 20:44:04 -0400 (EDT)
Message-ID: <20170514.204404.1844909849561204299.davem@davemloft.net>
References: <20170514055848.GA23149@lst.de>
        <20170514.115116.499149210596634881.davem@davemloft.net>
        <1494788929.21774.1.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1494788929.21774.1.camel@sandisk.com>
Sender: netdev-owner@vger.kernel.org
To: Bart.VanAssche@sandisk.com
Cc: hch@lst.de, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, stable@vger.kernel.org, ubraun@linux.vnet.ibm.com
List-Id: linux-rdma@vger.kernel.org

From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Date: Sun, 14 May 2017 19:08:50 +0000

> What is your plan to avoid that applications start using and
> depending on AF_SMC?

The API is out there already so we are out of luck, and neither
you nor I nor anyone else can "stop" this from happening.
