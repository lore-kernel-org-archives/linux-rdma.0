From: Gandalf Corvotempesta <gandalf.corvotempesta-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: rsockets addressing
Date: Mon, 16 Sep 2013 18:31:33 +0200
Message-ID: <CAJH6TXj=8OeavwyRHEaEBE=UUN0hyQGdTXh3iJiD7Ot7tnEqFA@mail.gmail.com>
References: <CAJH6TXhY---UhpvsquYrNXBc5ji_hYp7zJ+CwRrfy-naM_aGaA@mail.gmail.com>
	<1828884A29C6694DAF28B7E6B8A8237388CC0B81@ORSMSX109.amr.corp.intel.com>
	<CAJH6TXgHZpyMgDzFG9pUKvkJyxybjBFsTPNHGxvbQUJ76XtJuQ@mail.gmail.com>
	<a87f274640d3a8bcfa70579668edba2c@meuh.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <a87f274640d3a8bcfa70579668edba2c-zgzEX58YAwA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

2013/9/16 Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>:
> You have to use InfiniBand port bonding to benefit from fail-over (through
> APM: Automatic Path Migration ?)
>
> http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/Documentation/networking/bonding.txt

IB boinding is exactly what I would like to do but I have some questions:

1. is the ISL supported? I've seen that is not suggested to
interconnect two IB switches (and I don't know why)
http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/Documentation/networking/bonding.txt#n1967
Without ISL and using two different IB switches, one port failure will
result in the whole node down because there is no other active path to
the primary switch
This would be good in my environment by I prefere to get a real failover.

2. can I use active-active mode like standard ethernet bonding with
some sort of balancing?
http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/Documentation/networking/bonding.txt#n2127
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
