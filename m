From: Michael Di Domenico <mdidomenico4-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: compiling against lustre 1.8.2 kernel
Date: Mon, 17 May 2010 12:15:06 -0400
Message-ID: <AANLkTil_7L_cbglOcaHKPRmrrntXew9jwxvSrTkxNcnF@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

I ran across an error when trying to compile OFED-1.4.2 agianst the
Lustre 1.8.2 kernel on Redhat v5.4 (2.6.18-164.11.1)

/var/tmp/ofed.topdir/BUILD/ofa_kernel_1.4.2/kernel_addons/backport/2.6.18-EL5.3/include/linux/sched.h:13
error: static declaration of '__fatal_signal_pending' follows
non-static declaration include/linux/sched.h: 1570 error: previous
declaration of '__fatal_signal_pending' was here

Any suggestions?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
