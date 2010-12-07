From: sebastien dugue <sebastien.dugue-6ktuUTfB/bM@public.gmane.org>
Subject: Re: IPoIB to Ethernet routing performance
Date: Tue, 7 Dec 2010 08:39:11 +0100
Message-ID: <20101207083911.2ab47a59@frecb012350.frec.bull.fr>
References: <20101206112454.76bb85f1@frecb012350.frec.bull.fr>
	<4CFD4BEE.5070205@shiftmail.org>
	<20101206212759.GB16788@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101206212759.GB16788-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Jabe <jabe.chapman-9AbUPqfR1/2XDw4h08c5KA@public.gmane.org>, OF EWG <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


 Hi Jason,

On Mon, 6 Dec 2010 14:27:59 -0700
Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:

> On Mon, Dec 06, 2010 at 09:47:42PM +0100, Jabe wrote:
>=20
> > Technologies MT25204 [InfiniHost III Lx HCA]; and dual E5430 xeon
> > (not nehalem).
>=20
> Newer Mellanox cards have most of the offloads you see for ethernet s=
o
> they get better performance.

  What kind of offload capabilities are you referring to for IPoIB?

> Plus > Nehalem is just better at TCP in
> the first place..

  Well that depends on which Nehalem we're talking about. I've found th=
at the EX
performs more poorly than the EP, though I didn't dig enough to find ou=
t why.

  S=C3=A9bastien.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
