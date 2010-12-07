From: sebastien dugue <sebastien.dugue-6ktuUTfB/bM@public.gmane.org>
Subject: Re: IPoIB to Ethernet routing performance
Date: Tue, 7 Dec 2010 12:48:05 +0100
Message-ID: <20101207124805.1fede78f@frecb012350.frec.bull.fr>
References: <20101206112454.76bb85f1@frecb012350.frec.bull.fr>
	<4CFD4BEE.5070205@shiftmail.org>
	<20101206212759.GB16788@obsidianresearch.com>
	<20101207083911.2ab47a59@frecb012350.frec.bull.fr>
	<4CFE0638.2040105@voltaire.com>
	<20101207112739.0c95db46@frecb012350.frec.bull.fr>
	<4CFE0D7C.4020904@voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4CFE0D7C.4020904-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Jabe <jabe.chapman-9AbUPqfR1/2XDw4h08c5KA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, 7 Dec 2010 12:33:32 +0200
Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org> wrote:

> On 12/7/2010 12:27 PM, sebastien dugue wrote:
> >
> >    Huh? How do you do that?
> see Documentation/infiniband/ipoib.txt on your clone of Linus tree or=
 if=20
> you're not a developer, see
> http://lxr.linux.no/#linux+v2.6.36/Documentation/infiniband/ipoib.txt=
=20
> the HCA you're using does support offloads, so you're probably runnin=
g=20
> connected mode, use datagram

  Right, I'm running in connected mode. Last time I checked, datagram m=
ode
was far from connected mode performance wise.

  S=C3=A9bastien.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
