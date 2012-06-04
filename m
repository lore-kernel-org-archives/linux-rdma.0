From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH for-next V1 0/4] IB/IPoIB TSS and RSS support for datagram mode
Date: Tue, 5 Jun 2012 01:19:26 +0300
Message-ID: <CAJZOPZ+WX6gXAXESWge4ZsQVBun+bhWoui+f5DeKkqB3uEB2Hg@mail.gmail.com>
References: <1338810598-9488-1-git-send-email-ogerlitz@mellanox.com>
	<1828884A29C6694DAF28B7E6B8A8237346A25BFF@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A8237346A25BFF-P5GAC/sN6hmkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Shlomo Pongratz <shlomop-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Jun 4, 2012 at 8:06 PM, Hefty, Sean <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:

> > Still, the 1st and most thing to handle here is feedback on the QP
> > groups concept suggested by this patch set to support TSS/RSS over
> > verbs. The plan is for this concept to (with little help from a
> > framework for verbs extension) apply to user space RSS as well,
> > for both UD and RAW QPs.

> Conceptually, it seems that there should be more alignment with XRC, which also
> ends up with an associated group of QPs.
> Is the use of these QPs restricted to TCP/UDP/IP traffic?

Yep, sure, if its possible to align/squeez/unite these QP groups into
the XRC interfaces
could be nice to go that way.

As for you question on the nature of the traffic, for example, RX
wise, its one QP (the parent) which dispatches traffic to set of
(child) QPs where with RSS the dispatching is based on hashing which
is based on the assumptions that the packets are TCP/UDP/IP, below the
RSS hood, packets for which the HW fails to apply hash on are
dispatched to a default QP in that set. The suggested scheme matches
well IB/UD QPs and Ethernet RAW packet QPs.

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
