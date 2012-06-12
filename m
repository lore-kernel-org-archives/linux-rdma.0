From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH for-next V1 0/4] IB/IPoIB TSS and RSS support for datagram mode
Date: Tue, 12 Jun 2012 23:01:46 +0300
Message-ID: <CAJZOPZJL+qhk4CcUpmXffrTsS85fMJtxvuQePzpjN902Eg5h5g@mail.gmail.com>
References: <1338810598-9488-1-git-send-email-ogerlitz@mellanox.com>
	<1828884A29C6694DAF28B7E6B8A8237346A25BFF@ORSMSX101.amr.corp.intel.com>
	<CAJZOPZ+WX6gXAXESWge4ZsQVBun+bhWoui+f5DeKkqB3uEB2Hg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJZOPZ+WX6gXAXESWge4ZsQVBun+bhWoui+f5DeKkqB3uEB2Hg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Shlomo Pongratz <shlomop-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> Hefty, Sean <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:

>> Conceptually, it seems that there should be more alignment with XRC, which also
>> ends up with an associated group of QPs.

> Yep, sure, if its possible to align/squeez/unite these QP groups into the XRC interfaces
> could be nice to go that way.


Sean,

Do you have something more specific re how to actually align (say) the
RSS QP group into the framework used by XRC?

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
