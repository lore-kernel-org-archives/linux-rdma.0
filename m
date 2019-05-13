From: David Miller <davem@davemloft.net>
Subject: Re: Annoying gcc / rdma / networking warnings
Date: Sun, 12 May 2019 20:17:01 -0700 (PDT)
Message-ID: <20190512.201701.1918995863082655897.davem@davemloft.net>
References: <CAHk-=whbuwm5FbkPSfftZ3oHMWw43ZNFXqvW1b6KFMEj5wBipA@mail.gmail.com>
        <20190513011131.GA7948@mellanox.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190513011131.GA7948@mellanox.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jgg@mellanox.com
Cc: torvalds@linux-foundation.org, dledford@redhat.com, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, netdev@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

From: Jason Gunthorpe <jgg@mellanox.com>
Date: Mon, 13 May 2019 01:11:42 +0000

> I think the specific sockaddr types should only ever be used if we
> *know* the sa_family is that type. If the sa_family is not known then
> it should be sockaddr or sockaddr_storage. Otherwise things get very
> confusing.
> 
> When using sockaddr_storage code always has the cast to sockaddr
> anyhow, as it is not a union, so this jaunty cast is not out of place
> in sockets code.

>From what I can see, each and every call side of these helpers like
rdma_gid2ip() et al. redefine this union type over and over and over
again in the local function.

That's the real problem.

It seems that if we just defined it explicitly in one place, like
include/rdma/ib_addr.h, then we could have tdma_gid2ip(), addr_resolve(),
and rdma_resolve_ip() take that type explcitily.

No?
