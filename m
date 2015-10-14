From: "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH] fix return value error
Date: Wed, 14 Oct 2015 14:17:47 +0000
Message-ID: <32E1700B9017364D9B60AED9960492BC25985427@fmsmsx120.amr.corp.intel.com>
References: <1444808810-29995-1-git-send-email-os@iscas.ac.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Heloise NH <os-Xj+kWLifKvnM1kAEIRd3EQ@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Or Gerlitz (gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org)" <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> > Subject: [PATCH] fix return value error
> >
> 
> I checked returns in configfs (-ENOMEM), proc (-ENOENT), proc-sys (-
> ENOMEM), ramfs (-ENOSPC), vfs (-ENOMEM).
> 
> Not entirely consistent but this matches the majority.
> 
> I agree -EPERM is pretty misleading.
> 
> Acked-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Thanks Or on catching the bad directory in the patch.

Doug, can you fix this up or do you want it resubmitted?

Mike
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
