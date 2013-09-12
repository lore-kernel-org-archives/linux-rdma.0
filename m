From: Andreas Bluemle <andreas.bluemle-jy6uzZffzV0b1SvskN2V4Q@public.gmane.org>
Subject: Re: [ceph-users] Help needed porting Ceph to RSockets
Date: Thu, 12 Sep 2013 14:12:54 +0200
Message-ID: <20130912141254.0a1642de@doppio>
References: <1828884A29C6694DAF28B7E6B8A8237388CA7C88@ORSMSX109.amr.corp.intel.com>
	<20130910154847.3fb7dd02@doppio>
	<CAJH6TXg94x+jcc=1MQQoQaF5JcGKuxbG_SzLEMt3EVQOrFeNjw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJH6TXg94x+jcc=1MQQoQaF5JcGKuxbG_SzLEMt3EVQOrFeNjw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Gandalf Corvotempesta <gandalf.corvotempesta-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Matthew Anderson <manderson8787-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "ceph-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <ceph-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, 12 Sep 2013 12:20:03 +0200
Gandalf Corvotempesta <gandalf.corvotempesta-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> 2013/9/10 Andreas Bluemle <andreas.bluemle-jy6uzZffzV0b1SvskN2V4Q@public.gmane.org>:
> > Since I have added these workarounds to my version of the librdmacm
> > library, I can at least start up ceph using LD_PRELOAD and end up in
> > a healthy ceph cluster state.
> 
> Have you seen any performance improvement by using LD_PRELOAD with
> ceph? Which throughput are you able to archive with rsocket and ceph?

I have not yet done any performance testing.

The next step I have to take is more related to setting up
a larger cluster with sth. like 150 osd's without hitting any
resource limitations.

Regards

Andreas Bluemle

> --
> To unsubscribe from this list: send the line "unsubscribe ceph-devel"
> in the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 



-- 
Andreas Bluemle                     mailto:Andreas.Bluemle-jy6uzZffzV0b1SvskN2V4Q@public.gmane.org
ITXperts GmbH                       http://www.itxperts.de
Balanstrasse 73, Geb. 08            Phone: (+49) 89 89044917
D-81541 Muenchen (Germany)          Fax:   (+49) 89 89044910

Company details: http://www.itxperts.de/imprint.htm
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
