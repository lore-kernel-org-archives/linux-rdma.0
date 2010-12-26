From: "Richard Croucher" <richard-jNDFPZUTrfRJpuwtbJ71GdBPR1lH4CV8@public.gmane.org>
Subject: RE: [ewg] IPoIB to Ethernet routing performance
Date: Sun, 26 Dec 2010 10:57:13 -0000
Message-ID: <018d01cba4eb$aa507320$fef15960$@com>
References: <20101206112454.76bb85f1@frecb012350.frec.bull.fr>	<00d701cb9533$71c5f2e0$5551d8a0$@com>	<20101206124023.025c2f88@frecb012350.frec.bull.fr>	<00f201cb953e$53f66a00$fbe33e00$@com>	<20101206140505.20cfc9e2@frecb012350.frec.bull.fr>	<alpine.DEB.2.00.1012091745070.29367@router.home> <AANLkTi=2-FJtJCY0+79wyXRszwrhRwQStDTNjRCjr66F@mail.gmail.com>
Reply-To: <richard.croucher-jNDFPZUTrfRJpuwtbJ71GdBPR1lH4CV8@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTi=2-FJtJCY0+79wyXRszwrhRwQStDTNjRCjr66F-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-gb
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Ali Ayoub' <ali-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, 'Christoph Lameter' <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Cc: 'linux-rdma' <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, 'sebastien dugue' <sebastien.dugue-6ktuUTfB/bM@public.gmane.org>, 'OF EWG' <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The vNIC driver only works when you have Ethernet/InfiniBand hardware
gateways in your environment.   It is useful when you have external hos=
ts to
communicate with which do not have direct InfiniBand connectivity.
IPoIB is still heavily used in these environments to provide TCP/IP
connectivity within the InfiniBand fabric.
The primary Use Case for vNICs is probably for virtualization servers, =
so
that individual Guests can be presented with a virtual Ethernet NIC and=
 do
not lead to load any InfiniBand drivers.  Only the hypervisor needs to =
have
the InfiniBand software stack loaded.
I've also applied vNICs in the Financial Services arena, for connectivi=
ty to
external TCP/IP services but there the IPoIB gateway function is arguab=
ly
more useful.

The whole vNIC arena is complicated by different, incompatible
implementations from each of Qlogic and Mellanox.

Richard

-----Original Message-----
=46rom: ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
[mailto:ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org] On Behalf Of Ali Ayoub
Sent: 26 December 2010 07:43
To: Christoph Lameter
Cc: linux-rdma; sebastien dugue; Richard Croucher; OF EWG
Subject: Re: [ewg] IPoIB to Ethernet routing performance

On Thu, Dec 9, 2010 at 3:46 PM, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org> wrote:
> On Mon, 6 Dec 2010, sebastien dugue wrote:
>
>> > The Mellanox BridgeX looks a better hardware solution with 12x 10G=
e
>> > ports but when I tested this they could only provide vNIC
>> > functionality and would not commit to adding IPoIB gateway on thei=
r
>> > roadmap.
>>
>> =A0 Right, we did some evaluation on it and this was really a show s=
topper.
>
> Did the same thing here came to the same conclusions.

May I ask why do you need IPoIB when you have EoIB (vNic driver)?
Why it's a show stopper?
_______________________________________________
ewg mailing list
ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ewg

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
