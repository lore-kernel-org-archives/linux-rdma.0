From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [patch 44/44] Kconfig
Date: Fri, 22 Jul 2011 15:32:34 +0200
Message-ID: <CAO+b5-rm9gAEVuKVEYORtgv59dBhWVY4Y0HL16krugMMzRSY-Q@mail.gmail.com>
References: <20110701131821.928693424@systemfabricworks.com> <20110701132202.824114065@systemfabricworks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110701132202.824114065-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: rpearson-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Fri, Jul 1, 2011 at 3:19 PM, <rpearson-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org> wrote:
> +++ infiniband/drivers/infiniband/hw/rxe/Kconfig
> @@ -0,0 +1,26 @@
> +config INFINIBAND_RXE
> + =A0 =A0 =A0 tristate "Software RDMA driver"
> + =A0 =A0 =A0 depends on 64BIT && NET
> + =A0 =A0 =A0 ---help---
> + =A0 =A0 =A0 This is a driver for a software implementation of IBTA
> + =A0 =A0 =A0 RDMA transport.
> +
> + =A0 =A0 =A0 There are three kernel modules:
> +
> + =A0 =A0 =A0 ib_rxe =A0 =A0 =A0 =A0 =A0- device independant transpor=
t driver.
> + =A0 =A0 =A0 ib_rxe_net =A0 =A0 =A0- connects transport to the netde=
v stack
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 and runs on Etherne=
t devices. Follows the
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 RoCE protocol i.e. =
GRH and no LRH.
> + =A0 =A0 =A0 ib_rxe_sample =A0 - sample module that connects the tra=
nsport
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 to itself as a loop=
back and follows the
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 InfiniBand protocol=
 i.e. uses LRH. This
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 could be used as a =
start for other experimantal
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 software implementa=
tions of InfiniBand.
> +
> + =A0 =A0 =A0 Normal use is to load ib_rxe and ib_rxe_net after loadi=
ng ib_core.
> + =A0 =A0 =A0 There is a script rxe_cfg that automates the configurat=
ion of rxe.
> +
> + =A0 =A0 =A0 This driver supports kernel and user space ULPs. For us=
er space
> + =A0 =A0 =A0 verbs applications you must install librxe with libibve=
rbs.
> +
> + =A0 =A0 =A0 If you don't know what to use this for, you don't need =
it.

Maybe it's a good idea to add more information in the above text about
RoCE and to change the above text such that people are invited to
learn more about RDMA ? As an example, this is how the PPPOL2TP
Kconfig entry looks like:

config PPPOL2TP
        tristate "PPP over L2TP (EXPERIMENTAL)"
        depends on EXPERIMENTAL && L2TP && PPP
        help
          Support for PPP-over-L2TP socket family. L2TP is a protocol
          used by ISPs and enterprises to tunnel PPP traffic over UDP
          tunnels. L2TP is replacing PPTP for VPN uses.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
