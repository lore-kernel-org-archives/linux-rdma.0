From: Jason Gunthorpe <jgg@mellanox.com>
Subject: Re: Annoying gcc / rdma / networking warnings
Date: Mon, 13 May 2019 18:30:58 +0000
Message-ID: <20190513183053.GI7948@mellanox.com>
References: <CAHk-=whbuwm5FbkPSfftZ3oHMWw43ZNFXqvW1b6KFMEj5wBipA@mail.gmail.com>
 <20190513011131.GA7948@mellanox.com>
 <20190512.201701.1918995863082655897.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190512.201701.1918995863082655897.davem@davemloft.net>
Content-Language: en-US
Content-ID: <93EB29960ADB1A469EF8B5521F803208@eurprd05.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: David Miller <davem@davemloft.net>, "g@mellanox.com" <g@mellanox.com>
Cc: "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>, "dledford@redhat.com" <dledford@redhat.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, May 12, 2019 at 08:17:01PM -0700, David Miller wrote:
> From: Jason Gunthorpe <jgg@mellanox.com>
> Date: Mon, 13 May 2019 01:11:42 +0000
>=20
> > I think the specific sockaddr types should only ever be used if we
> > *know* the sa_family is that type. If the sa_family is not known then
> > it should be sockaddr or sockaddr_storage. Otherwise things get very
> > confusing.
> >=20
> > When using sockaddr_storage code always has the cast to sockaddr
> > anyhow, as it is not a union, so this jaunty cast is not out of place
> > in sockets code.
>=20
> From what I can see, each and every call side of these helpers like
> rdma_gid2ip() et al. redefine this union type over and over and over
> again in the local function.

Yes, the repeated union is very ugly and could be consolidated - or
should just use sockaddr_storage in the first place.

> It seems that if we just defined it explicitly in one place, like
> include/rdma/ib_addr.h, then we could have tdma_gid2ip(), addr_resolve(),
> and rdma_resolve_ip() take that type explcitily.

I pulled on this thread for a while and the number of places that
would need to convert to use a global 'union rdma_sockaddr_inet'
started to become pretty silly and weird. I eventually reached a point
where I had to cast a sockaddr * to the union - which is something
that makes no sense and I gave up.

So, I think this feels simpler to follow the usual sockaddr_storage
pattern and only use the union to declare the initial storage. Then
everything else just uses the sockaddr * plus casts..

Jason
