From: David Miller <davem@davemloft.net>
Subject: Re: RFC on writel and writel_relaxed
Date: Wed, 28 Mar 2018 11:55:09 -0400 (EDT)
Message-ID: <20180328.115509.481837809903086401.davem@davemloft.net>
References: <CA+55aFxULkhZGhg-tTBBxBBvXbL7QV7f6zvwW7U2wHFijqGEqw@mail.gmail.com>
        <b02cc752d90c5e5ae2cc8cc4f67429a7@codeaurora.org>
        <1522249996.21446.25.camel@kernel.crashing.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1522249996.21446.25.camel@kernel.crashing.org>
Sender: netdev-owner@vger.kernel.org
To: benh@kernel.crashing.org
Cc: okaya@codeaurora.org, torvalds@linux-foundation.org, alexander.duyck@gmail.com, will.deacon@arm.com, arnd@arndb.de, jgg@ziepe.ca, David.Laight@aculab.com, oohall@gmail.com, linuxppc-dev@lists.ozlabs.org, linux-rdma@vger.kernel.org, alexander.h.duyck@redhat.com, paulmck@linux.vnet.ibm.com, netdev@vger.kernel.org, linus971@gmail.com
List-Id: linux-rdma@vger.kernel.org

From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Date: Thu, 29 Mar 2018 02:13:16 +1100

> Let's fix all archs, it's way easier than fixing all drivers. Half of
> the archs are unused or dead anyway.

Agreed.
