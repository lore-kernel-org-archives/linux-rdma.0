From: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Question on merge windows.
Date: Tue, 17 Jun 2014 17:03:05 +0000
Message-ID: <2807E5FD2F6FDA4886F6618EAC48510E04BB67C1@CRSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org" <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Roland,

I see the merge window closed on Sunday and Linus has released 3.16-rc1.  Does that mean now is the time you will start accepting things destined for 3.17 while 3.16 "bakes"?

If that is the case would you like me to rebase the latest version of following patches onto your most recent "for-next" branch and resubmit?  Or would you prefer I _not_ do so?  I would like to see if we can get this series into 3.17 if possible.

Thanks,
Ira

> -----Original Message-----
> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-
> owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
> Sent: Monday, May 05, 2014 6:45 PM
> To: roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org
> Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Subject: [PATCH RESEND 0/5] ib/mad: Add ability for user space applications to
> control RMPP directly
> 
> My apologies if anyone receives duplicates of these emails.  Apparently the
> series did not make it to linux-rdma the first time.
> 
> The first 3 patches update the umad and mad modules to use pr_* style print
> messages in preparation for adding pr_notice messages to the existing and new
> registration functions.
> 
> The final 2 patches add a new registration mechanism which allows for flags to
> be specified at ib_mad registration time.  The first such flag is to allow user
> control of RMPP transactions.
> 
> Existing registration and RMPP transactions are unaffected by this change.
> 
> [PATCH 1/5] ib/umad: update module to pr_* style print messages
> [PATCH 2/5] ib/mad: update module to pr_* style print messages
> [PATCH 3/5] ib/mad: Add pr_notice messages for various umad/mad
> [PATCH 4/5] ib/mad: add new ioctl to user space to support new
> [PATCH 5/5] ib/mad: Add user space RMPP support
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in the body
> of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org More majordomo info at
> http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
