From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] libdmacm/rspreload: Avoid rsocket calls until after fork
Date: Tue, 28 Aug 2012 00:34:54 +0300
Message-ID: <CAJZOPZKXBt01QfQOd-vd_-MGnycjxexDmfpGbpvrV7SZf_eRAg@mail.gmail.com>
References: <1828884A29C6694DAF28B7E6B8A8237346A8AB32@ORSMSX101.amr.corp.intel.com>
	<5039CF81.6010304@mellanox.com>
	<1828884A29C6694DAF28B7E6B8A8237346A8B2E4@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A8237346A8B2E4-P5GAC/sN6hmkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Aug 27, 2012 at 8:54 PM, Hefty, Sean <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:

> rsockets enables fork support only when RDMAV_FORK_SAFE has been set.
> I do not call ibv_fork_init().

understood, so you see the problem also when RDMAV_FORK_SAFE has been set?

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
