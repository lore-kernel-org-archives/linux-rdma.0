From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH librdmacm] Fixed build problem due to missing macro
Date: Tue, 4 Dec 2012 10:21:32 +0200
Message-ID: <CAJZOPZL2-vO3muh6FKcKLgGLhom_u044mcC22o_Se165wByeJA@mail.gmail.com>
References: <1354449863-20990-1-git-send-email-ogerlitz@mellanox.com>
	<1828884A29C6694DAF28B7E6B8A8237346ADC3F3@ORSMSX101.amr.corp.intel.com>
	<CAJZOPZJVgUdmXPd6t6ias27vTrc8LieX4J=YnVQbLTMmo8A3RQ@mail.gmail.com>
	<1828884A29C6694DAF28B7E6B8A8237346ADC43A@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A8237346ADC43A-P5GAC/sN6hmkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "esalomon-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <esalomon-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Dec 3, 2012 at 9:48 PM, Hefty, Sean <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
>
> According to my notes, I ran netperf with fork support using this:


yep, works just fine with this directive - we got 46Gbs, impressive!

Or.

> server
> ------
> export RDMAV_FORK_SAFE=1
> LD_PRELOAD=/usr/local/lib/rsocket/librspreload.so netserver
>
> client
> ------
> export RDMAV_FORK_SAFE=1
> LD_PRELOAD=/usr/local/lib/rsocket/librspreload.so netperf -H <ip-address>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
