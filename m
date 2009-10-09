From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [ewg] rping is not resolving ipv6 addresses
Date: Fri, 9 Oct 2009 22:53:04 +0200
Message-ID: <15ddcffd0910091353w51bddc60w8452ca107de296fb@mail.gmail.com>
References: <1254957121.23471.17.camel@wilder.ibm.com>
	 <adavdiqn63u.fsf@cisco.com> <1255114672.3533.8.camel@wilder.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1255114672.3533.8.camel-XfwDJb4SXxnMbYB6QlFGEg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "David J. Wilder" <dwilder-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Cc: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, wilder-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

David J. Wilder <dwilder-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org> wrote:
> I added an option to rping to specify a source address and supply it =
to

patch?

> rdma_resolve_addr(), but now it is failing rdma_resolve_route().
> $ ./rping -d =A0-c -v -a fe80::202:c903:1:1925 -i fe80::202:c903:1:28=
ed
> cma_event type RDMA_CM_EVENT_ADDR_RESOLVED cma_id 0x100213d0 (parent)
> cma_event type RDMA_CM_EVENT_ROUTE_ERROR cma_id 0x100213d0 (parent)
> cma event RDMA_CM_EVENT_ROUTE_ERROR, error -22

what does the neighbour info (ip neigh show | grep 1925)  shows after
running rping?
can you do ipoib ping and ping6 to the fe80::202:c903:1:1925 host?

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
