From: sebastien dugue <sebastien.dugue-6ktuUTfB/bM@public.gmane.org>
Subject: Re: IPoIB to Ethernet routing performance
Date: Tue, 7 Dec 2010 14:25:38 +0100
Message-ID: <20101207142538.051e4c1e@frecb012350.frec.bull.fr>
References: <20101206112454.76bb85f1@frecb012350.frec.bull.fr>
	<4CFD4BEE.5070205@shiftmail.org>
	<20101206212759.GB16788@obsidianresearch.com>
	<20101207083911.2ab47a59@frecb012350.frec.bull.fr>
	<4CFE0638.2040105@voltaire.com>
	<20101207112739.0c95db46@frecb012350.frec.bull.fr>
	<4CFE0D7C.4020904@voltaire.com>
	<20101207124805.1fede78f@frecb012350.frec.bull.fr>
	<AANLkTik2XaM6qyUUc+uzYCzKL+zKbN5kHz2Kf8So8arC@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTik2XaM6qyUUc+uzYCzKL+zKbN5kHz2Kf8So8arC-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hiroyuki Sato <hiroysato-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Jabe <jabe.chapman-9AbUPqfR1/2XDw4h08c5KA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


  Hiroyuki,

On Tue, 7 Dec 2010 22:01:51 +0900
Hiroyuki Sato <hiroysato-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> Basic Question.
>   MTU size matched?? on 10GbE and Infiniband

  Well, I found that the best end to end IPoIB MTU for routing to 10G E=
thernet is
8176 (in connected mode). That way the IB packet is 8192 bytes that spl=
its nicely
to the IB MTU of 2048 and at the same time fits in an Ethernet jumbo fr=
ame (9000).=20

>=20
> BTW, could you tell me more detail about 10GbE configuration.
> what kind of teaming are you using?? (ex IEEE802.3ad)
> (It is my interest.)

  I'm using no teaming right now. I'm just trying to pass 2 streams int=
o
a single IB link that then gets routed through 2 ethernet links.

  S=C3=A9bastien.

>=20
> --
> Hiroyuki Sato.
>=20
>=20
> 2010/12/7 sebastien dugue <sebastien.dugue-6ktuUTfB/bM@public.gmane.org>:
> > On Tue, 7 Dec 2010 12:33:32 +0200
> > Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org> wrote:
> >
> >> On 12/7/2010 12:27 PM, sebastien dugue wrote:
> >> >
> >> > =C2=A0 =C2=A0Huh? How do you do that?
> >> see Documentation/infiniband/ipoib.txt on your clone of Linus tree=
 or if
> >> you're not a developer, see
> >> http://lxr.linux.no/#linux+v2.6.36/Documentation/infiniband/ipoib.=
txt
> >> the HCA you're using does support offloads, so you're probably run=
ning
> >> connected mode, use datagram
> >
> > =C2=A0Right, I'm running in connected mode. Last time I checked, da=
tagram mode
> > was far from connected mode performance wise.
> >
> > =C2=A0S=C3=A9bastien.
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-rdm=
a" in
> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.=
html
> >
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
