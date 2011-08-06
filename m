From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [patch v2 33/37] add rxe_net.c
Date: Sat, 6 Aug 2011 10:02:38 +0200
Message-ID: <CAO+b5-qU--gMpsH4OFkDvyjmJM-eJmS_+VunNOe6gvcHN8Grjg@mail.gmail.com>
References: <20110724194300.421253331@systemfabricworks.com>
 <20110724201229.765038738@systemfabricworks.com> <CAO+b5-pk-X7aGgg12ND17OLcqcLU6qyiV+vf22anh9bYsXUUzw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAO+b5-pk-X7aGgg12ND17OLcqcLU6qyiV+vf22anh9bYsXUUzw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bob Pearson <rpearson-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>, Linux-RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, Jul 24, 2011 at 9:43 PM, <rpearson-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org> wrote=
:
+static __be64 rxe_mac_to_eui64(struct net_device *ndev)
+{
+ =A0 =A0unsigned char *mac_addr =3D ndev->dev_addr;
+ =A0 =A0__be64 eui64;
+ =A0 =A0unsigned char *dst =3D (unsigned char *)&eui64;
+
+ =A0 =A0dst[0] =3D mac_addr[0] ^ 2;
+ =A0 =A0dst[1] =3D mac_addr[1];
+ =A0 =A0dst[2] =3D mac_addr[2];
+ =A0 =A0dst[3] =3D 0xff;
+ =A0 =A0dst[4] =3D 0xfe;
+ =A0 =A0dst[5] =3D mac_addr[3];
+ =A0 =A0dst[6] =3D mac_addr[4];
+ =A0 =A0dst[7] =3D mac_addr[5];
+
+ =A0 =A0return eui64;
+}

As far as I can see rxe_param_set_add() does not limit ndev to
Ethernet devices ? In that case my comments about the above code are
as follows:
* The name mac_addr is misleading - dev_addr is probably more appropria=
te.
* A device address length check is missing. For network devices with
addresses less than six bytes long the above code will trigger an
out-of-bounds read.
* If someone binds ib_rxe to a network device with an address length
above six bytes, some useful information will be discarded.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
