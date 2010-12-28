From: Ali Ayoub <ali-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [ewg] IPoIB to Ethernet routing performance
Date: Mon, 27 Dec 2010 16:06:25 -0800
Message-ID: <AANLkTi=ausgOuEMRe622dNRzVyhN3pxPWeTAJiJihssW@mail.gmail.com>
References: <20101206112454.76bb85f1@frecb012350.frec.bull.fr>
	<00d701cb9533$71c5f2e0$5551d8a0$@com>
	<20101206124023.025c2f88@frecb012350.frec.bull.fr>
	<00f201cb953e$53f66a00$fbe33e00$@com>
	<20101206140505.20cfc9e2@frecb012350.frec.bull.fr>
	<alpine.DEB.2.00.1012091745070.29367@router.home>
	<AANLkTi=2-FJtJCY0+79wyXRszwrhRwQStDTNjRCjr66F@mail.gmail.com>
	<018d01cba4eb$aa507320$fef15960$@com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <018d01cba4eb$aa507320$fef15960$@com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: richard.croucher-jNDFPZUTrfRJpuwtbJ71GdBPR1lH4CV8@public.gmane.org
Cc: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, sebastien dugue <sebastien.dugue-6ktuUTfB/bM@public.gmane.org>, OF EWG <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, Dec 26, 2010 at 2:57 AM, Richard Croucher
<richard-jNDFPZUTrfRJpuwtbJ71GdBPR1lH4CV8@public.gmane.org> wrote:
> The vNIC driver only works when you have Ethernet/InfiniBand hardware
> gateways in your environment. =A0 It is useful when you have external=
 hosts to
> communicate with which do not have direct InfiniBand connectivity.
> IPoIB is still heavily used in these environments to provide TCP/IP
> connectivity within the InfiniBand fabric.

Once you have BridgeX HW, Mellanox vNic (EoIB) driver provides IB to
EN connectivity, as well as IB to IB connectivity.
Note that IB to IB connectivity doesn't involve the bridge HW
(peer-to-peer communication) so any packet sent internally within the
IB fabric doesn't reach the bridge HW.
Today, EoIB requires the BridgeX HW, in the future, Mellanox may
support "bridge-less" mode where it can work without the bridge HW.

> The primary Use Case for vNICs is probably for virtualization servers=
, so
> that individual Guests can be presented with a virtual Ethernet NIC a=
nd do
> not lead to load any InfiniBand drivers. =A0Only the hypervisor needs=
 to have
> the InfiniBand software stack loaded.

EoIB primary use is not virtualization, although it can support it in
better ways than other ULPs.
=46YI, today running full/para virtualized driver in the Guest OS is
needed also for IPoIB.
Only when platform-virtualization solution is available, the GOS will
run IB stack (for any ULP).

> -----Original Message-----
> From: ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
> [mailto:ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org] On Behalf Of Ali Ayoub
> Sent: 26 December 2010 07:43
> To: Christoph Lameter
> Cc: linux-rdma; sebastien dugue; Richard Croucher; OF EWG
> Subject: Re: [ewg] IPoIB to Ethernet routing performance
>
> On Thu, Dec 9, 2010 at 3:46 PM, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org> wrot=
e:
>> On Mon, 6 Dec 2010, sebastien dugue wrote:
>>
>>> > The Mellanox BridgeX looks a better hardware solution with 12x 10=
Ge
>>> > ports but when I tested this they could only provide vNIC
>>> > functionality and would not commit to adding IPoIB gateway on the=
ir
>>> > roadmap.
>>>
>>> =A0 Right, we did some evaluation on it and this was really a show =
stopper.
>>
>> Did the same thing here came to the same conclusions.
>
> May I ask why do you need IPoIB when you have EoIB (vNic driver)?
> Why it's a show stopper?
> _______________________________________________
> ewg mailing list
> ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
> http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ewg
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
