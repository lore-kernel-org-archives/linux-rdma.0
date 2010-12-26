From: Ali Ayoub <ali-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [ewg] IPoIB to Ethernet routing performance
Date: Sat, 25 Dec 2010 23:43:21 -0800
Message-ID: <AANLkTi=2-FJtJCY0+79wyXRszwrhRwQStDTNjRCjr66F@mail.gmail.com>
References: <20101206112454.76bb85f1@frecb012350.frec.bull.fr>
	<00d701cb9533$71c5f2e0$5551d8a0$@com>
	<20101206124023.025c2f88@frecb012350.frec.bull.fr>
	<00f201cb953e$53f66a00$fbe33e00$@com>
	<20101206140505.20cfc9e2@frecb012350.frec.bull.fr>
	<alpine.DEB.2.00.1012091745070.29367@router.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.00.1012091745070.29367-sBS69tsa9Uj/9pzu0YdTqQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Cc: sebastien dugue <sebastien.dugue-6ktuUTfB/bM@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Richard Croucher <richard-jNDFPZUTrfRJpuwtbJ71GdBPR1lH4CV8@public.gmane.org>, OF EWG <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

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
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
