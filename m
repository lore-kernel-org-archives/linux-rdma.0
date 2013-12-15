From: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Subject: Re: [PATCHv3 for-3.13 8/9] IB/uverbs: check access to userspace
 response buffer in extended command
Date: Sun, 15 Dec 2013 08:21:14 -0800
Message-ID: <CAL1RGDVThe_=F3EOCzYfxB8zCgv+4Z_PXiYEPqnphMEOi-drbw@mail.gmail.com>
References: <cover.1386798254.git.ydroneaud@opteya.com> <701fc3ee1136bbb4a0fd3d560c3ec1ee3bb3b828.1386798254.git.ydroneaud@opteya.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <701fc3ee1136bbb4a0fd3d560c3ec1ee3bb3b828.1386798254.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Dec 11, 2013 at 2:01 PM, Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org> wrote:
> Just like vfs_read(), uverbs_write() must check output buffer
> (eg. response) with access_ok(VERIFY_WRITE,...) to ensure
> it's in userspace memory before using the pointer in uverbs
> functions.

Is there any place where we use this pointer through something other
than copy_to_user()?  I don't think there is or ever should be, in
which case this check is redundant.

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
