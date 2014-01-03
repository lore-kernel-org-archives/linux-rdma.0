From: Gandalf Corvotempesta <gandalf.corvotempesta-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Fwd: IPoIB and STP
Date: Fri, 3 Jan 2014 12:25:13 +0100
Message-ID: <CAJH6TXhy55VShC7tcG1smuyKzWaMTtY4PHJvkbZe7PvWSDxwWw@mail.gmail.com>
References: <CAJH6TXgBySmP9JG=dt1Gp8_oYPBK+g=O84DOjpUu-sZZJ9p-6g@mail.gmail.com>
	<CAJH6TXibJknwQJz-zB4KC=Lf-ewCaRaRZTGiMu9VHJV_Vr8OjQ@mail.gmail.com>
	<1388680941.22995.41.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1388680941.22995.41.camel-bi+AKbBUZKY6gyzm1THtWbp2dZbC/Bob@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

2014/1/2 Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>:
> STP, Spanning Tree Protocol (IEEE 802.1D), is a component of Ethernet,
> which is Layer-2/Link layer. It does not involve IP, which is
> Layer-3/Network layer. IP is not bound to Ethernet, indeed.

You are right, mine was just an example to explain what I'm trying to do.

So, I can safely link both switches with multiple cables and OpenSM
will automatically use both link for aggregated bandwidth and fault
tollerance without any additional configuration?

In this case, a simple IPoIB network , with active-standby bonded
interfaces and multiple links between switches gives me HA, Load
Sharing and IP
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
