From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [RESEND PATCH V3 for-next 0/3] HW Device hot-removal support
Date: Mon, 18 May 2015 18:21:38 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373A8FDC9A4@ORSMSX109.amr.corp.intel.com>
References: <1431515438-24042-1-git-send-email-yishaih@mellanox.com>
 <1828884A29C6694DAF28B7E6B8A82373A8FDA36D@ORSMSX109.amr.corp.intel.com>
 <555486CA.8080409@dev.mellanox.co.il>
 <1828884A29C6694DAF28B7E6B8A82373A8FDA931@ORSMSX109.amr.corp.intel.com>
 <55586E5D.1030801@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <55586E5D.1030801-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "jackm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <jackm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> In this case, all FDs and memory mappings remain open.

*Why* is this needed?  The fd remains open -- that seems to be needed -- but all other kernel resources should be safe to clean up.  Any future calls into the kernel will just fail.  (Or mark the objects as defunct, so that close works.)

> these remaining resources may be device-specific.
> The proposed framework first of all allows a provider to indicate
> whether hot-removal is supported (i.e., the presence of the
> 'disassociate_ucontext' callback), and if so, allow the provider to
> perform the proper cleanup so that the corresponding user-space driver
> will continue to function.

The approach seems strange.  The driver knows that it is being removed.  It was informed up front which open contexts were associated with user space processes.  But the driver calls up to indicate that it is being removed, so that the upper layer can call back down to tell the driver to process the removal.

I wasn't asking what this series did.  I was asking why the uverbs driver just can't delete the underlying resources.  That's the natural thing to expect.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
