From: Jack Morgenstein <jackm@dev.mellanox.co.il>
Subject: Re: [PATCH V2 5/9] IB/mlx5: Mellanox Connect-IB, IB driver part 1/5
Date: Thu, 4 Jul 2013 17:03:53 +0300
Message-ID: <201307041703.54461.jackm@dev.mellanox.co.il>
References: <1372871592-32033-1-git-send-email-ogerlitz@mellanox.com> <1372885168.1886.17.camel@joe-AO722> <201307041615.25729.jackm@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <201307041615.25729.jackm@dev.mellanox.co.il>
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
To: Joe Perches <joe@perches.com>
Cc: Or Gerlitz <ogerlitz@mellanox.com>, roland@kernel.org, linux-rdma@vger.kernel.org, netdev@vger.kernel.org, davem@davemloft.net, eli@dev.mellanox.co.il, moshel@mellanox.com, Eli Cohen <eli@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

On Thursday 04 July 2013 16:15, Jack Morgenstein wrote:
> > > +=A0=A0=A0*inlen =3D sizeof **cqb + sizeof *(*cqb)->pas * ncont;
> >=20
> > sizeof always uses parentheses
>=20
I'll fix this, too.

-Jack
