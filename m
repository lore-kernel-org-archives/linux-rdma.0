From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [ewg] rping is not resolving ipv6 addresses
Date: Fri, 9 Oct 2009 23:22:10 +0200
Message-ID: <15ddcffd0910091422m64db1baax1d1cc18abc9539e2@mail.gmail.com>
References: <1254957121.23471.17.camel@wilder.ibm.com>
	 <adavdiqn63u.fsf@cisco.com> <1255114672.3533.8.camel@wilder.ibm.com>
	 <15ddcffd0910091353w51bddc60w8452ca107de296fb@mail.gmail.com>
	 <1255122901.3533.20.camel@wilder.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1255122901.3533.20.camel-XfwDJb4SXxnMbYB6QlFGEg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "David J. Wilder" <dwilder-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Cc: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, wilder-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

David J. Wilder <dwilder-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org> wrote:

> If I run rping without my rping change to add the source address to
> rdma_resolve_address(), =A0ip neigh show gives: =A0fe80::202:c903:1:1=
925 dev eth1 =A0FAILED
> Notice that interface is incorrect, it should be ib0. tcpdump showed =
the
> neighbor-discovery sent out the eth0 interface.

yes, this is as of what Roland explained.


> Running with my rping change to specify the local-link address of my =
ib0
> interface "ip neigh show" never shows any entry for  fe80::202:c903:1=
:1925

mmm... weird, run your rping with tcp dump in another screen and see
if ND takes place

> ping6 will work but I must specify the interface to use: ping6 fe80::=
202:c903:1:1925%ib0

after the tcpdump experiment, run ping6 and immediatly following that
or in parallel on another window run rping
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
