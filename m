From: Gandalf Corvotempesta <gandalf.corvotempesta-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: rsockets addressing
Date: Mon, 16 Sep 2013 22:41:31 +0200
Message-ID: <CAJH6TXiEEsx01j1PbWVi7EyAW=MH0vj0j=cRMnA_tcy+rGjQ0Q@mail.gmail.com>
References: <CAJH6TXhY---UhpvsquYrNXBc5ji_hYp7zJ+CwRrfy-naM_aGaA@mail.gmail.com>
	<1828884A29C6694DAF28B7E6B8A8237388CC0B81@ORSMSX109.amr.corp.intel.com>
	<CAJH6TXgHZpyMgDzFG9pUKvkJyxybjBFsTPNHGxvbQUJ76XtJuQ@mail.gmail.com>
	<a87f274640d3a8bcfa70579668edba2c@meuh.org>
	<CAJH6TXj=8OeavwyRHEaEBE=UUN0hyQGdTXh3iJiD7Ot7tnEqFA@mail.gmail.com>
	<1379361657.2476.11.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1379361657.2476.11.camel-bi+AKbBUZKY6gyzm1THtWbp2dZbC/Bob@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

2013/9/16 Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>:
> The InfiniBand fabrics support "ISL" ... indeed.
[cut]
> You definitely need link between switches if you want to use a "high
> availability" fabric topology with HCA ports connected to differents
> switches. (additionally, a switch should have a link to two others
> switches ... then it's starting to be complicated, since you have to
> design your fabric topology to match the communication pattern / data
> locality used by your application ...).

I've read somewhere that this is not suggested because issues on one
switch could affect also the second switch, but doing so will allow me
to use both port in hot-standby failover.

In one port fails, IPoIB bonding will switch on the second port and at
the same time , traffic will be routed trough the ISL link

Without the ISL, a port failure will bring down the whole node.

So:
 - switch1 conntected to switch2
 - node1 connected to both switches
 - node2 connected to both switches
 - IPoIB on each node with active-passive bonding for each IB port.

How can I create a redundant ISL ? Should I connect two or more port and
the subnet manager will automatically take care of this or I have to configure
something like STP on plain ethernet networks.
Will the ISL be used in loadbalancing in case of 2 or more cables connected ?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
