From: Gandalf Corvotempesta <gandalf.corvotempesta-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Dual star topology
Date: Sat, 27 Jul 2013 12:47:49 +0200
Message-ID: <CAJH6TXgzQC_jPy+hi=R3kAwYdj6Nh3O0sJix==yEPcZ89N+hNQ@mail.gmail.com>
References: <CAJH6TXipMaLMcwuBbR+Jvb3KueZ1gBW7ohcb5Ke8ixO1bCEWAw@mail.gmail.com>
	<51F01724.7010504@dev.mellanox.co.il>
	<CAJH6TXgJGALyCcyPo+GvAninXQkZ+Md8c0NPmi_PUoU4XKDUHA@mail.gmail.com>
	<CAJH6TXjYW8w=RafoXgFiYNcFHc8ub+o-2v0_NsD8efoB0vyHpA@mail.gmail.com>
	<CAJH6TXg3+ZzQAK1Wbf2HtfymrToHY7bSVWTpxP3_Ddi6CL0BbQ@mail.gmail.com>
	<51F044B0.305@dev.mellanox.co.il>
	<CAJH6TXiQNc_y8KHO79aOY0A9-PJ7bm54URyhNhVFkd18ZmyM5Q@mail.gmail.com>
	<CAJH6TXgOTbfBqqatMQOxtgnUUt=p9c4mkqaq3s-ujh5hLZJ5Zw@mail.gmail.com>
	<1828884A29C6694DAF28B7E6B8A8237384567F02@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A8237384567F02-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

2013/7/25 Hefty, Sean <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>:
> Currently, rsockets cannot fail over between local HCA ports.  This is an implementation restriction resulting from no automatic path migration support.

This is still unclear.
>From the README (
http://git.openfabrics.org/git?p=~shefty/librdmacm.git;a=blob;f=README;h=e1f222740144ed8f7d8bc935ea6643355b077bcd;hb=refs/heads/master
) I can read:
"Using multiple interfaces
  The librdmacm does support multiple interfaces."

so, multiple interfaces are supported. Why I can't use both port? Each
port is threathed as a single interface.

Next question: rsockets addressing is done by IPoIB ? How can I reach
a remote IP address without IPoIB ?
If yes, I think that I could use a bonded IPoIB interface to have an
"always-on" path.

English is not my primary language, so, i repeat: today, is not
possible to use librdma_cm in a fault tollerance architecture ? I
don't need bandwidth aggregation, but just a fault tollerance across 2
switches.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
