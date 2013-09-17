From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: Re: rsockets addressing
Date: Tue, 17 Sep 2013 11:41:46 +0200
Message-ID: <56ea23e8dda74a3f5bc0c215dd58f825@meuh.org>
References: <CAJH6TXhY---UhpvsquYrNXBc5ji_hYp7zJ+CwRrfy-naM_aGaA@mail.gmail.com>
 <1828884A29C6694DAF28B7E6B8A8237388CC0B81@ORSMSX109.amr.corp.intel.com>
 <CAJH6TXgHZpyMgDzFG9pUKvkJyxybjBFsTPNHGxvbQUJ76XtJuQ@mail.gmail.com>
 <a87f274640d3a8bcfa70579668edba2c@meuh.org>
 <CAJH6TXj=8OeavwyRHEaEBE=UUN0hyQGdTXh3iJiD7Ot7tnEqFA@mail.gmail.com>
 <1379361657.2476.11.camel@localhost.localdomain>
 <CAJH6TXiEEsx01j1PbWVi7EyAW=MH0vj0j=cRMnA_tcy+rGjQ0Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJH6TXiEEsx01j1PbWVi7EyAW=MH0vj0j=cRMnA_tcy+rGjQ0Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Gandalf Corvotempesta <gandalf.corvotempesta-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Le 16.09.2013 22:41, Gandalf Corvotempesta a =C3=A9crit=C2=A0:
> 2013/9/16 Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>:
>> The InfiniBand fabrics support "ISL" ... indeed.
> [cut]
>> You definitely need link between switches if you want to use a "high
>> availability" fabric topology with HCA ports connected to differents
>> switches. (additionally, a switch should have a link to two others
>> switches ... then it's starting to be complicated, since you have to
>> design your fabric topology to match the communication pattern / dat=
a
>> locality used by your application ...).
>=20
> I've read somewhere that this is not suggested because issues on one
> switch could affect also the second switch, but doing so will allow m=
e
> to use both port in hot-standby failover.
>=20

Are talking about Ethernet network or InfiniBand Fabric ?

> In one port fails, IPoIB bonding will switch on the second port and a=
t
> the same time , traffic will be routed trough the ISL link
>=20

It's "routed" through the fabric.

> Without the ISL, a port failure will bring down the whole node.
>=20
> So:
>  - switch1 conntected to switch2
>  - node1 connected to both switches
>  - node2 connected to both switches
>  - IPoIB on each node with active-passive bonding for each IB port.
>=20
> How can I create a redundant ISL ? Should I connect two or more port=20
> and
> the subnet manager will automatically take care of this or I have to=20
> configure
> something like STP on plain ethernet networks.

In case of InfiniBand, the subnet manager should take care of it.

> Will the ISL be used in loadbalancing in case of 2 or more cables=20
> connected ?

It should depend on the topology chosen for the fabric. You might ask t=
o=20
someone else for this.

Regards.

--=20
Yann Droneaud
OPTEYA

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
