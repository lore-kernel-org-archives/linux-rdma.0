From: Michael Di Domenico <mdidomenico4-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: compile ofed 1.5.3 against lustre kernel
Date: Tue, 14 Jun 2011 16:34:23 -0400
Message-ID: <BANLkTin1Pg3e0S=2Hb3=0W=M_qo_TiqRrw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

is there a mechanism somewhere inside the kernel source rpm that
detects which specific RHEL kernel is running and then applies those
backport patches?

I'm trying to get OFED 1.5.3 to compile against RHEL5.6 with the lustre patches

I've already compiled OFED 1.5.3 against the stock RHEL5.6 kernel that
ships 2.6.18-238 and that worked fine

I've downloaded the kernel source rpm for 2.6.18-238 from redhat and
recompiled my kernel with the lustre 1.8.5 kernel patches

however, when i try to compile OFED against this new kernel version
2.6.18-lustre18-1 its failing with a bunch of random errors that look
like missing patches

the command I'm using

./install.pl --hpc -s /opt/lustre/kernel/rpmbuild/BUILD/kernel-2.6.18lustre18

When i diff the two OFED build logs i do see in the stock kernel build
patches being applied from the 2.6.18-EL5.6 directory, but don't see
that in the lustre build log file which heightens my suspicion of
missing patches.

Is there a parameter i can override somewhere tell rpmbuild that even
though the kernel version doesn't match 2.6.18-238 it really is a
2.6.18-238 kernel?

thanks
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
