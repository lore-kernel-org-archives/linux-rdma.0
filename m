From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: Re: rsockets addressing
Date: Mon, 16 Sep 2013 18:17:38 +0200
Message-ID: <a87f274640d3a8bcfa70579668edba2c@meuh.org>
References: <CAJH6TXhY---UhpvsquYrNXBc5ji_hYp7zJ+CwRrfy-naM_aGaA@mail.gmail.com>
 <1828884A29C6694DAF28B7E6B8A8237388CC0B81@ORSMSX109.amr.corp.intel.com>
 <CAJH6TXgHZpyMgDzFG9pUKvkJyxybjBFsTPNHGxvbQUJ76XtJuQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJH6TXgHZpyMgDzFG9pUKvkJyxybjBFsTPNHGxvbQUJ76XtJuQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Gandalf Corvotempesta <gandalf.corvotempesta-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Le 16.09.2013 17:59, Gandalf Corvotempesta a =C3=A9crit=C2=A0:
> 2013/9/16 Hefty, Sean <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>:
>> rsockets does not implement failover.  An application would need to=20
>> reestablish a connection in the case of a failure.  I have not looke=
d=20
>> to see what it would take to implement failover inside rsockets, and=
=20
>> that's not something I would have time to implement anytime soon.
>=20
> Connection restablishement is ok, but in case of port failure, ipoib
> will remap the remote IP against the new port/fabric ?

You have to use InfiniBand port bonding to benefit from fail-over=20
(through APM: Automatic Path Migration ?)

http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/Doc=
umentation/networking/bonding.txt

Regards.

--=20
Yann Droneaud
OPTEYA

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
