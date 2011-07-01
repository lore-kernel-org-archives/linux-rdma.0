From: Michael Di Domenico <mdidomenico4-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: rhel6 ofed v1.5.3
Date: Fri, 1 Jul 2011 13:08:47 -0400
Message-ID: <BANLkTi=fJr7BypNCs-7S4-THNTUGtmiicg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

According to my installation of Ofed 1.5.3 on RHEL6, the
infiniband-diags package rpm is trying to chown /usr/local in order to
deposit a library in lib64.

In my environment /usr/local is off-limits to root and all package
installs.  Is this a bug?  Is there a workaround to allow the
install.pl to complete?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
