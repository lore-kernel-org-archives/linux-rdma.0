From: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [ewg] IPoIB to Ethernet routing performance
Date: Mon, 3 Jan 2011 16:33:59 -0600 (CST)
Message-ID: <alpine.DEB.2.00.1101031631550.31064@router.home>
References: <20101206112454.76bb85f1@frecb012350.frec.bull.fr> <00d701cb9533$71c5f2e0$5551d8a0$@com> <20101206124023.025c2f88@frecb012350.frec.bull.fr> <00f201cb953e$53f66a00$fbe33e00$@com> <20101206140505.20cfc9e2@frecb012350.frec.bull.fr>
 <alpine.DEB.2.00.1012091745070.29367@router.home> <AANLkTi=2-FJtJCY0+79wyXRszwrhRwQStDTNjRCjr66F@mail.gmail.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463811839-760346520-1294094040=:31064"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTi=2-FJtJCY0+79wyXRszwrhRwQStDTNjRCjr66F-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ali Ayoub <ali-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: sebastien dugue <sebastien.dugue-6ktuUTfB/bM@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Richard Croucher <richard-jNDFPZUTrfRJpuwtbJ71GdBPR1lH4CV8@public.gmane.org>, OF EWG <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463811839-760346520-1294094040=:31064
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Sat, 25 Dec 2010, Ali Ayoub wrote:

> On Thu, Dec 9, 2010 at 3:46 PM, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org> wrote:
> > On Mon, 6 Dec 2010, sebastien dugue wrote:
> >
> >> > The Mellanox BridgeX looks a better hardware solution with 12x 10Ge
> >> > ports but when I tested this they could only provide vNIC
> >> > functionality and would not commit to adding IPoIB gateway on their
> >> > roadmap.
> >>
> >> =A0 Right, we did some evaluation on it and this was really a show sto=
pper.
> >
> > Did the same thing here came to the same conclusions.
>
> May I ask why do you need IPoIB when you have EoIB (vNic driver)?
> Why it's a show stopper?

EoIB is immature for some use cases like financial. No multicast support
f.e. All multicast becomes broadcast. There is extensive support for
multicast on IPoIB and the various gotchas and hiccups that where there
initially have mostly been worked out.


---1463811839-760346520-1294094040=:31064--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
