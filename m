From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH v4 4/7] libibverbs: Add support for XRC QPs
Date: Mon, 18 Mar 2013 18:01:30 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A823736F365E91@ORSMSX101.amr.corp.intel.com>
References: <1828884A29C6694DAF28B7E6B8A8237346A981A0@FMSMSX151.amr.corp.intel.com>
	<1363394326-908-4-git-send-email-sean.hefty@intel.com>
	<5145C820.9090801@mellanox.com>
	<1828884A29C6694DAF28B7E6B8A823736F365DA2@ORSMSX101.amr.corp.intel.com>
 <CAJZOPZ+-korcbr=7kyraXdRZeH8hE1JdBLBRcykvqRJqNSGeQQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJZOPZ+-korcbr=7kyraXdRZeH8hE1JdBLBRcykvqRJqNSGeQQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org" <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> Got it good,  let me see if I follow what would it take to do that:
> 
> 1. add  IBV_QP_INIT_ATTR_CREATE_FLAGS to enum ibv_qp_init_attr_mask
> 2. add uint32_t  create_flags to struct ibv_qp_init_attr_ex
> 
> and etc respective changes to the kernel/user structures, will that be all?

yes - that would be all that's needed to add the flags 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
