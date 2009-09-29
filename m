From: "Robert D. Russell" <rdr-zcUZCMB5SQOVc3sceRu5cw@public.gmane.org>
Subject: getting path to backport directory
Date: Tue, 29 Sep 2009 16:15:08 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0909291613310.13129@postal.iol.unh.edu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


A general question on getting the correct backport.

On my machine, if I do "uname -r" I get
2.6.18-128.el5

If I do "cat /etc/redhat-release" I get
CentOs release 5.3 (Final)

If I look in "/usr/src/ofa_kernel/kernel_addons/backport"
the subdirectory I need to use for the current kernel is:
2.6.18-EL5.3

My question:  Is there somewhere in the system where I can
find (or generate) the string "2.6.18-EL5.3"?
I want to put that in my scripts so they will automatically
pick it up whenever we change versions (as we just did when
going to Centos -- it used to be 2.6.18-EL5.2 in the RedHat
version we were running before).  At present I have to edit
these scripts by hand, and that's a lousy way to do business.

Thanks,
Bob Russell

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
