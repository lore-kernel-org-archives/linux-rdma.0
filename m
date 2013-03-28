From: "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH] IB/ipath: fix error return code in
 ipath_register_ib_device()
Date: Thu, 28 Mar 2013 18:24:43 +0000
Message-ID: <32E1700B9017364D9B60AED9960492BC0DF6B7B1@FMSMSX108.amr.corp.intel.com>
References: <CAPgLHd-ZH-DTBKHBfppYX409qLddst46dXkZ_dn5c2i_A+YCQQ@mail.gmail.com>
	<32E1700B9017364D9B60AED9960492BC0DF6AB22@FMSMSX108.amr.corp.intel.com>
 <CAPgLHd_wmyj=kLLfikrWxngnVKOp9iW1K9KU_bvix4UuFAfdvQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAPgLHd_wmyj=kLLfikrWxngnVKOp9iW1K9KU_bvix4UuFAfdvQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Wei Yongjun <weiyj.lk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: infinipath <infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "yongjun_wei-zrsr2BFq86L20UzCJQGyNP8+0UxHXcjY@public.gmane.org" <yongjun_wei-zrsr2BFq86L20UzCJQGyNP8+0UxHXcjY@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> Since your will change qib_verbs_register_sysfs() as the same, you can change
> both of them.

http://marc.info/?l=linux-rdma&m=136449464411193&w=2 and http://marc.info/?l=linux-rdma&m=136449435211122&w=2 are the proposed patches.

Mike
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
