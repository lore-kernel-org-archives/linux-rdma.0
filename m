From: Sean Hefty <pookieween-EMRzualFZlQ@public.gmane.org>
Subject: handling rdma apps using chroot
Date: Wed, 15 Aug 2012 12:07:25 -0700
Message-ID: <SNT114-DS11B5280C71EEE30408772DADB60@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

I'm looking for ideas on the best way for handling applications which use
chroot, which results in failures using the rdma libraries.  Specifically,
and not surprisingly, I see failures reading /sys/class/... and
/dev/infiniband/...

For background, I'm trying to run vsftpd over rsockets using the preload
library with fork support.  vsftpd will run only if I comment out its use of
chroot.  I can reproduce the issue by inserting a chroot call into rstream.

Does anyone have any suggestions?

- Sean

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
