From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH V3 for-next 0/5] IB/IPoIB: Add multi-queue TSS and RSS support
Date: Wed, 3 Apr 2013 23:14:38 +0300
Message-ID: <CAJZOPZ+_5Mx5CVusQdQ4bZggU65b6Xjq1ExLOmwzm0uwdYPgGg@mail.gmail.com>
References: <1362676288-19906-1-git-send-email-ogerlitz@mellanox.com>
	<CAJZOPZJ_runtaQnj+3n03FniBR83AeRD+Lh_2tn_1XZ0F2wKYg@mail.gmail.com>
	<1828884A29C6694DAF28B7E6B8A823736F366357@ORSMSX101.amr.corp.intel.com>
	<514EF53F.3000200@mellanox.com>
	<CAJZOPZLbj+YxbELMRh9TioWptHG88Qz2VfzGTsreB+PFTdkNPA@mail.gmail.com>
	<CAJZOPZJ3G3weqAmaTytVAgQTvfiSOjgnZ_ROk4osRv8fxuRWwA@mail.gmail.com>
	<1828884A29C6694DAF28B7E6B8A823736F36B547@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A823736F36B547-P5GAC/sN6hmkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Shlomo Pongratz <shlomop-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tzahi Oved <tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Apr 3, 2013 at 11:12 PM, Hefty, Sean <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
>> Hi Sean, Ping. You had concerns on the suggested concept, we want to
>> know if we addressed them, can you comment?

> I'm in meetings this week until tomorrow.  I'll try to take a look at the updated patches > then or Friday.

OK, thanks, the 3.10 merge window is coming closer and I want to know
where are we in that respect. Almost every Ethernet NIC you use has
RSS, there's no reason for IPoIB not to support that too.

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
