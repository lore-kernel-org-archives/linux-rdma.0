From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH V3 for-next 0/5] IB/IPoIB: Add multi-queue TSS and RSS
 support
Date: Tue, 9 Apr 2013 17:06:28 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A823736F36D0E1@ORSMSX101.amr.corp.intel.com>
References: <1362676288-19906-1-git-send-email-ogerlitz@mellanox.com>
 <CAJZOPZJ_runtaQnj+3n03FniBR83AeRD+Lh_2tn_1XZ0F2wKYg@mail.gmail.com>
 <1828884A29C6694DAF28B7E6B8A823736F366357@ORSMSX101.amr.corp.intel.com>
 <514EF53F.3000200@mellanox.com>
 <CAJZOPZLbj+YxbELMRh9TioWptHG88Qz2VfzGTsreB+PFTdkNPA@mail.gmail.com>
 <CAJZOPZJ3G3weqAmaTytVAgQTvfiSOjgnZ_ROk4osRv8fxuRWwA@mail.gmail.com>
 <1828884A29C6694DAF28B7E6B8A823736F36B547@ORSMSX101.amr.corp.intel.com>
 <5164209D.1060101@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5164209D.1060101-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Shlomo Pongratz <shlomop-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tzahi Oved <tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> any feedback?

I have no issue with RSS/TSS.  But the 'qp group' interface to using this seems kludgy.

On a node, this is multiple send/receive queues grouped together to form a larger construct.  On the wire, this is a single QP - maybe?  I'm still not clear on that.  From what's written, all the send queues appear as a single QPN.  The receive queues appear as different QPNs.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
