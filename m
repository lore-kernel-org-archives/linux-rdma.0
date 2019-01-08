From: Jason Gunthorpe <jgg@mellanox.com>
Subject: [PATCH] packet: Do not leak dev refcounts on error exit
Date: Tue, 8 Jan 2019 23:27:06 +0000
Message-ID: <20190108232658.GA1911@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <netdev-owner@vger.kernel.org>
Content-Language: en-US
Content-ID: <253C6A0983443A4C9259ED32537E793A@eurprd05.prod.outlook.com>
Sender: netdev-owner@vger.kernel.org
To: "David S. Miller" <davem@davemloft.net>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Cc: Willem de Bruijn <willemb@google.com>, Leon Romanovsky <leonro@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

'dev' is non NULL when the addr_len check triggers so it must goto a label
that does the dev_put otherwise dev will have a leaked refcount.

This bug causes the ib_ipoib module to become unloadable when using
systemd-network as it triggers this check on InfiniBand links.

Fixes: 99137b7888f4 ("packet: validate address length")
Reported-by: Leon Romanovsky <leonro@mellanox.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
---
 net/packet/af_packet.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

This patch should go to -rc please. Thanks

diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index eedacdebcd4c61..d0945253f43b3e 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -2628,7 +2628,7 @@ static int tpacket_snd(struct packet_sock *po, struct=
 msghdr *msg)
 		addr	=3D saddr->sll_halen ? saddr->sll_addr : NULL;
 		dev =3D dev_get_by_index(sock_net(&po->sk), saddr->sll_ifindex);
 		if (addr && dev && saddr->sll_halen < dev->addr_len)
-			goto out;
+			goto out_put;
 	}
=20
 	err =3D -ENXIO;
@@ -2828,7 +2828,7 @@ static int packet_snd(struct socket *sock, struct msg=
hdr *msg, size_t len)
 		addr	=3D saddr->sll_halen ? saddr->sll_addr : NULL;
 		dev =3D dev_get_by_index(sock_net(sk), saddr->sll_ifindex);
 		if (addr && dev && saddr->sll_halen < dev->addr_len)
-			goto out;
+			goto out_unlock;
 	}
=20
 	err =3D -ENXIO;
--=20
2.20.1
