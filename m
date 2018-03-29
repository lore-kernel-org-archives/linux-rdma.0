From: David Miller <davem@davemloft.net>
Subject: Re: RFC on writel and writel_relaxed
Date: Thu, 29 Mar 2018 10:04:14 -0400 (EDT)
Message-ID: <20180329.100414.1839699928682052200.davem@davemloft.net>
References: <1522249996.21446.25.camel@kernel.crashing.org>
        <20180328.115509.481837809903086401.davem@davemloft.net>
        <29fe17e0-9978-dc43-d02c-de8fabdc66c2@codeaurora.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <29fe17e0-9978-dc43-d02c-de8fabdc66c2@codeaurora.org>
Sender: netdev-owner@vger.kernel.org
To: okaya@codeaurora.org
Cc: benh@kernel.crashing.org, torvalds@linux-foundation.org, alexander.duyck@gmail.com, will.deacon@arm.com, arnd@arndb.de, jgg@ziepe.ca, David.Laight@aculab.com, oohall@gmail.com, linuxppc-dev@lists.ozlabs.org, linux-rdma@vger.kernel.org, alexander.h.duyck@redhat.com, paulmck@linux.vnet.ibm.com, netdev@vger.kernel.org, linus971@gmail.com
List-Id: linux-rdma@vger.kernel.org

From: Sinan Kaya <okaya@codeaurora.org>
Date: Thu, 29 Mar 2018 09:56:01 -0400

> sparc		question sent

Sparc never lets physical memory accesses pass MMIO, and vice versa.

They are always strongly ordered amongst eachother.

Therefore no explicit barrier instructions are necessary.
