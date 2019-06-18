From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH net-next v4 2/2] ipoib: show VF broadcast address
Date: Tue, 18 Jun 2019 10:08:01 -0700 (PDT)
Message-ID: <20190618.100801.2026737630386139646.davem@davemloft.net>
References: <20190617085341.51592-1-dkirjanov@suse.com>
        <20190617085341.51592-4-dkirjanov@suse.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190617085341.51592-4-dkirjanov@suse.com>
Sender: netdev-owner@vger.kernel.org
To: kda@linux-powerpc.org
Cc: dledford@redhat.com, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, mkubecek@suse.cz
List-Id: linux-rdma@vger.kernel.org

From: Denis Kirjanov <kda@linux-powerpc.org>
Date: Mon, 17 Jun 2019 10:53:41 +0200

> in IPoIB case we can't see a VF broadcast address for but
> can see for PF

I just want to understand why this need to see the VF broadcast
address is IPoIB specific?
