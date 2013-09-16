From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: Re: rsockets addressing
Date: Mon, 16 Sep 2013 22:00:57 +0200
Message-ID: <1379361657.2476.11.camel@localhost.localdomain>
References: <CAJH6TXhY---UhpvsquYrNXBc5ji_hYp7zJ+CwRrfy-naM_aGaA@mail.gmail.com>
	 <1828884A29C6694DAF28B7E6B8A8237388CC0B81@ORSMSX109.amr.corp.intel.com>
	 <CAJH6TXgHZpyMgDzFG9pUKvkJyxybjBFsTPNHGxvbQUJ76XtJuQ@mail.gmail.com>
	 <a87f274640d3a8bcfa70579668edba2c@meuh.org>
	 <CAJH6TXj=8OeavwyRHEaEBE=UUN0hyQGdTXh3iJiD7Ot7tnEqFA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJH6TXj=8OeavwyRHEaEBE=UUN0hyQGdTXh3iJiD7Ot7tnEqFA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Gandalf Corvotempesta <gandalf.corvotempesta-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi,

Le lundi 16 septembre 2013 =C3=A0 18:31 +0200, Gandalf Corvotempesta a
=C3=A9crit :
> 2013/9/16 Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>:
> > You have to use InfiniBand port bonding to benefit from fail-over (=
through
> > APM: Automatic Path Migration ?)
> >
> > http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree=
/Documentation/networking/bonding.txt
>=20
> IB boinding is exactly what I would like to do but I have some questi=
ons:
>=20
> 1. is the ISL supported? I've seen that is not suggested to
> interconnect two IB switches (and I don't know why)
> http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/D=
ocumentation/networking/bonding.txt#n1967
> Without ISL and using two different IB switches, one port failure wil=
l
> result in the whole node down because there is no other active path t=
o
> the primary switch
> This would be good in my environment by I prefere to get a real failo=
ver.
>=20

The InfiniBand fabrics support "ISL" ... indeed.

InfiniBand fabrics support more complicated network topology than
(plain) Ethernet: that's why there's (at least) one Subnet Manager,
while Ethernet struggle with Spanning Tree ...

You definitely need link between switches if you want to use a "high
availability" fabric topology with HCA ports connected to differents
switches. (additionally, a switch should have a link to two others
switches ... then it's starting to be complicated, since you have to
design your fabric topology to match the communication pattern / data
locality used by your application ...).

> 2. can I use active-active mode like standard ethernet bonding with
> some sort of balancing?
> http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/D=
ocumentation/networking/bonding.txt#n2127

AFAIK, IPoIB bonding doesn't support "active-active" bonding.
Only high availability is provided. Link aggregate is not supported.

Regards.

--=20
Yann Droneaud
OPTEYA


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
