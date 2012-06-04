From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH for-next V1 0/4] IB/IPoIB TSS and RSS support for
 datagram mode
Date: Mon, 4 Jun 2012 17:06:23 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237346A25BFF@ORSMSX101.amr.corp.intel.com>
References: <1338810598-9488-1-git-send-email-ogerlitz@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1338810598-9488-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Shlomo Pongratz <shlomop-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> Still, the 1st and most thing to handle here is feedback on the QP
> groups concept suggested by this patch set to support TSS/RSS over
> verbs. The plan is for this concept to (with little help from a
> framework for verbs extension) apply to user space RSS as well,
> for both UD and RAW QPs.

Conceptually, it seems that there should be more alignment with XRC, which also ends up with an associated group of QPs.

Is the use of these QPs restricted to TCP/UDP/IP traffic?

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
