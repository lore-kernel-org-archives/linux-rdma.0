From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [patch v2 37/37] add Kconfig
Date: Sat, 6 Aug 2011 20:44:29 +0200
Message-ID: <CAO+b5-q_0yoXcAdr6jQthUOYeq6y8uG8VOfdLzYf8ZQSTJ6n3w@mail.gmail.com>
References: <20110724194300.421253331@systemfabricworks.com>
 <20110724201229.966262587@systemfabricworks.com> <CAO+b5-oFKiAhTkCntAo5_mMCtdg1vb1eM_mTi-8E-T_atHa_3w@mail.gmail.com>
 <027e01cc53a4$a47f2640$ed7d72c0$@systemfabricworks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <027e01cc53a4$a47f2640$ed7d72c0$@systemfabricworks.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bob Pearson <rpearson-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Fri, Aug 5, 2011 at 9:19 PM, Bob Pearson
<rpearson-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org> wrote:
>> -----Original Message-----
>> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-
>> owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Bart Van Assche
>> Sent: Friday, August 05, 2011 1:44 PM
>> To: rpearson-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org
>> Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> Subject: Re: [patch v2 37/37] add Kconfig
>>
>> On Sun, Jul 24, 2011 at 9:43 PM, =A0<rpearson-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>=
 wrote:
>> +config INFINIBAND_RXE
>> + =A0 =A0 tristate "Software RDMA over Ethernet (RoCE) driver"
>> + =A0 =A0 depends on INET && PCI && INFINIBAND
>> + =A0 =A0 ---help---
>> + =A0 =A0 This driver implements the InfiniBand RDMA transport over
>> + =A0 =A0 the Linux network stack. It enables a system with a
>>
>> Shouldn't that read "an Ethernet network" instead of "the Linux netw=
ork
>> stack" ?
>
> Technically it will run over more than just Ethernet. RXE plugs in at=
 the
> same place as IP on top of the netdev core.
> There are some assumptions about the size of the L2 address that make=
 it
> work better on Ethernet but I used to run it over the loopback device=
 and it
> also runs over VLANs.

In that case I propose to change "Linux network stack" into "Linux
network driver" - that's all what the rxe driver uses from the network
stack, and there is more in the Linux network stack than only the
network drivers.

>> + =A0 =A0 standard Ethernet adapter to interoperate with a RoCE
>> + =A0 =A0 adapter or with another system running the RXE driver.
>> + =A0 =A0 Documentation on InfiniBand and RoCE can be downloaded at
>> + =A0 =A0 www.infinibandta.org and www.openfabrics.org. (See also
>> + =A0 =A0 siw which is a similar software driver for iWARP.)
>>
>> Isn't RoCE an official IBTA standard ? If so, seems like a good idea
>> to me to mention that here.
>
> I'll do that for v3.

Thanks. Maybe it's a good idea to mention also that while RoCE
benefits from a lossless converged Ethernet network, that the protocol
also works over a regular (not lossless) Ethernet network.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
