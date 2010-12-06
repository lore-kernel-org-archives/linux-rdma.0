From: sebastien dugue <sebastien.dugue-6ktuUTfB/bM@public.gmane.org>
Subject: IPoIB to Ethernet routing performance
Date: Mon, 6 Dec 2010 11:24:54 +0100
Message-ID: <20101206112454.76bb85f1@frecb012350.frec.bull.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: OF EWG <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


  Hi,

  I know this might be off topic, but somebody may have already run int=
o the same
problem before.

  I'm trying to use a server as a router between an IB fabric and an Et=
hernet network.

  The router is fitted with one ConnectX2 QDR HCA and one dual port Myr=
icom 10G
Ethernet adapter.

  I did some bandwidth measurements using iperf with the following setu=
p:

  +---------+               +---------+               +---------+
  |         |               |         |   10G Eth     |         |
  |         |    QDR IB     |         +---------------+         |
  | client  +---------------+  Router |   10G Eth     |  Server |
  |         |               |         +---------------+         |
  |         |               |         |               |         |
  +---------+               +---------+               +---------+

 =20
  However, the routing performance is far from what I would have expect=
ed.

  Here are some numbers:

  - 1 IPoIB stream between client and router: 20 Gbits/sec

    Looks OK.

  - 2 Ethernet streams between router and server: 19.5 Gbits/sec

    Looks OK.

  - routing 1 IPoIB stream to 1 Ethernet stream from client to server: =
9.8 Gbits/sec

    We manage to saturate the Ethernet link, looks good so far.

  - routing 2 IPoIB streams to 2 Ethernet streams from client to server=
: 9.3 Gbits/sec

    Argh, even less that when routing a single stream. I would have exp=
ected
    a bit more than this.


  Has anybody ever tried to do some routing between an IB fabric and an=
 Ethernet
network and achieved some sensible bandwidth figures?

  Are there some known limitations in what I try to achieve?


  Thanks,

  S=C3=A9bastien.




--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
