From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH for-next V1 0/4] IB/IPoIB TSS and RSS support for datagram mode
Date: Wed, 29 Aug 2012 00:35:46 +0300
Message-ID: <CAJZOPZJguEu3LzaLNRmns4qow09h+nz3AK273j8v03SBQ6pjxw@mail.gmail.com>
References: <1338810598-9488-1-git-send-email-ogerlitz@mellanox.com>
	<1828884A29C6694DAF28B7E6B8A8237346A25BFF@ORSMSX101.amr.corp.intel.com>
	<CAJZOPZ+WX6gXAXESWge4ZsQVBun+bhWoui+f5DeKkqB3uEB2Hg@mail.gmail.com>
	<CAJZOPZJL+qhk4CcUpmXffrTsS85fMJtxvuQePzpjN902Eg5h5g@mail.gmail.com>
	<1828884A29C6694DAF28B7E6B8A8237346A30177@ORSMSX101.amr.corp.intel.com>
	<CACZyyF8o1ift2-rkV6yL7EM_iys2kWHJ=ZHNe2xMihu4jSW5+g@mail.gmail.com>
	<CAJZOPZJWGWO7vXtKhv_UFp8hdtApWsAKCeduksMJti03i1=DEg@mail.gmail.com>
	<1828884A29C6694DAF28B7E6B8A8237346A8B641@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A8237346A8B641-P5GAC/sN6hmkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Shlomo Pongratz <shlomop-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tzahi Oved <tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Aug 28, 2012 at 9:07 PM, Hefty, Sean <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
>> Can you let us know your thoughts here?

> I understand the purpose behind TSS/RSS.  I'm not fond of making verbs
> more complex, but I haven't come up with anything that's really simpler.
> Tzahi's response addressed my main concerns.

OK, thanks

> Is there a compelling reason for ever exposing this feature to user space?

RSS YES to boost application that offloads TCP/IP traffic and want
processing of incoming traffic to be carried over multiple QPs which
are in use by multiple threads or even processes

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
