From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 1/2] rdma/cm: Fix crash in request handlers
Date: Tue, 15 Mar 2011 07:13:47 -0700
Message-ID: <CF9C39F99A89134C9CF9C4CCB68B8DDF25CCB3A2D5@orsmsx501.amr.corp.intel.com>
References: <CF9C39F99A89134C9CF9C4CCB68B8DDF25CC6C536C@orsmsx501.amr.corp.intel.com>
 <AANLkTinE3hzALRn9=5QOHiZCOGJU8RYm77c2vb_qzW5P@mail.gmail.com>
 <CF9C39F99A89134C9CF9C4CCB68B8DDF25CCB3A08D@orsmsx501.amr.corp.intel.com>
 <AANLkTi=O+An6XSFR-jWnYjQzsED63=DRnTBGF=itgAR3@mail.gmail.com>
 <AANLkTi=jDsCFEsfhT0Vwq2APQKmF5ZYFFV91=rEMUe=+@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTi=jDsCFEsfhT0Vwq2APQKmF5ZYFFV91=rEMUe=+@mail.gmail.com>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

>  - one thread create an id with an invalid userspace pointer
>    (so the copy_to_user in ucma_create_id returns -EFAULT
>    and calls rdma_destroy_id before idr_remove)
>  - another thread guess the id that is going to be returned and
>    call ucma_destroy_id()
> 
> if the second thread hits the window where the cm_id is
> destroyed but the ctx is still in the idr, it can trigger a double free.

I think we'd have to hold the file->mut around the entire ucma_create_id() operation to fix this.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
