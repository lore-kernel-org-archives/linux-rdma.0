From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH for-next V1 0/4] IB/IPoIB TSS and RSS support for
 datagram mode
Date: Tue, 28 Aug 2012 18:07:03 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237346A8B641@ORSMSX101.amr.corp.intel.com>
References: <1338810598-9488-1-git-send-email-ogerlitz@mellanox.com>
	<1828884A29C6694DAF28B7E6B8A8237346A25BFF@ORSMSX101.amr.corp.intel.com>
	<CAJZOPZ+WX6gXAXESWge4ZsQVBun+bhWoui+f5DeKkqB3uEB2Hg@mail.gmail.com>
	<CAJZOPZJL+qhk4CcUpmXffrTsS85fMJtxvuQePzpjN902Eg5h5g@mail.gmail.com>
	<1828884A29C6694DAF28B7E6B8A8237346A30177@ORSMSX101.amr.corp.intel.com>
	<CACZyyF8o1ift2-rkV6yL7EM_iys2kWHJ=ZHNe2xMihu4jSW5+g@mail.gmail.com>
 <CAJZOPZJWGWO7vXtKhv_UFp8hdtApWsAKCeduksMJti03i1=DEg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJZOPZJWGWO7vXtKhv_UFp8hdtApWsAKCeduksMJti03i1=DEg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Shlomo Pongratz <shlomop-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tzahi Oved <tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> Can you let us know your thoughts here?

I understand the purpose behind TSS/RSS.  I'm not fond of making verbs more complex, but I haven't come up with anything that's really simpler.  Tzahi's response addressed my main concerns.

Is there a compelling reason for ever exposing this feature to user space?
 
- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
