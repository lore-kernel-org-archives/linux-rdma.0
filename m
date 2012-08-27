From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH] libdmacm/rspreload: Avoid rsocket calls until after fork
Date: Mon, 27 Aug 2012 22:13:14 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237346A8B4C1@ORSMSX101.amr.corp.intel.com>
References: <1828884A29C6694DAF28B7E6B8A8237346A8AB32@ORSMSX101.amr.corp.intel.com>
	<5039CF81.6010304@mellanox.com>
	<1828884A29C6694DAF28B7E6B8A8237346A8B2E4@ORSMSX101.amr.corp.intel.com>
 <CAJZOPZKXBt01QfQOd-vd_-MGnycjxexDmfpGbpvrV7SZf_eRAg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJZOPZKXBt01QfQOd-vd_-MGnycjxexDmfpGbpvrV7SZf_eRAg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> > rsockets enables fork support only when RDMAV_FORK_SAFE has been set.
> > I do not call ibv_fork_init().
> 
> understood, so you see the problem also when RDMAV_FORK_SAFE has been set?

yes
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
