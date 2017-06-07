From: "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH] RDMA/qib: Fix MR reference count leak on write with
 immediate
Date: Wed, 7 Jun 2017 14:38:00 +0000
Message-ID: <32E1700B9017364D9B60AED9960492BC3431EF6A@fmsmsx120.amr.corp.intel.com>
References: <20170606150244.14663.71707.stgit@phlsvslse11.ph.intel.com>
 <201706071515.DptFcIHE%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <201706071515.DptFcIHE%fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: lkp <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "kbuild-all-JC7UmRfGjtg@public.gmane.org" <kbuild-all-JC7UmRfGjtg@public.gmane.org>, "stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "stable-commits-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <stable-commits-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

>    drivers/infiniband/hw/qib/qib_rc.c: In function 'qib_rc_rcv':
> >> drivers/infiniband/hw/qib/qib_rc.c:1960:4: error: implicit declaration of
> function 'qib_put_ss' [-Werror=implicit-function-declaration]
>        qib_put_ss(&qp->r_sge);
>        ^~~~~~~~~~

The patch is intended for stable kernels as noted in:

 Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org> # 3.10.x,3.16.x,4.1.x,4.4.x

Mike
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
