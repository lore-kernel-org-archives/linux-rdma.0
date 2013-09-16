From: Gandalf Corvotempesta <gandalf.corvotempesta-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [ceph-users] Help needed porting Ceph to RSockets
Date: Mon, 16 Sep 2013 15:29:08 +0200
Message-ID: <CAJH6TXhXkK1WiPAzrQCFLZfZj1TQhaJ7A+1RTVZ3azFVEXH39A@mail.gmail.com>
References: <1828884A29C6694DAF28B7E6B8A8237388CA7C88@ORSMSX109.amr.corp.intel.com>
	<20130910154847.3fb7dd02@doppio>
	<CAJH6TXg94x+jcc=1MQQoQaF5JcGKuxbG_SzLEMt3EVQOrFeNjw@mail.gmail.com>
	<20130912141254.0a1642de@doppio>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130912141254.0a1642de@doppio>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andreas Bluemle <andreas.bluemle-jy6uzZffzV0b1SvskN2V4Q@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Matthew Anderson <manderson8787-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "ceph-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <ceph-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

2013/9/12 Andreas Bluemle <andreas.bluemle-jy6uzZffzV0b1SvskN2V4Q@public.gmane.org>:
> I have not yet done any performance testing.
>
> The next step I have to take is more related to setting up
> a larger cluster with sth. like 150 osd's without hitting any
> resource limitations.

How do you manage failover ? Will you use mulitple HBA (or dual-port
HBA) on each node or just a single IB fabric ?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
