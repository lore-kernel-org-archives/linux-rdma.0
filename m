From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: compile ofed 1.5.3 against lustre kernel
Date: Tue, 14 Jun 2011 15:43:57 -0500
Message-ID: <4DF7C80D.1060408@opengridcomputing.com>
References: <BANLkTin1Pg3e0S=2Hb3=0W=M_qo_TiqRrw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <BANLkTin1Pg3e0S=2Hb3=0W=M_qo_TiqRrw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Michael Di Domenico <mdidomenico4-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 06/14/2011 03:34 PM, Michael Di Domenico wrote:
> is there a mechanism somewhere inside the kernel source rpm that
> detects which specific RHEL kernel is running and then applies those
> backport patches?
>
> I'm trying to get OFED 1.5.3 to compile against RHEL5.6 with the lustre patches
>
> I've already compiled OFED 1.5.3 against the stock RHEL5.6 kernel that
> ships 2.6.18-238 and that worked fine
>
> I've downloaded the kernel source rpm for 2.6.18-238 from redhat and
> recompiled my kernel with the lustre 1.8.5 kernel patches
>
> however, when i try to compile OFED against this new kernel version
> 2.6.18-lustre18-1 its failing with a bunch of random errors that look
> like missing patches
>
> the command I'm using
>
> ./install.pl --hpc -s /opt/lustre/kernel/rpmbuild/BUILD/kernel-2.6.18lustre18
>
> When i diff the two OFED build logs i do see in the stock kernel build
> patches being applied from the 2.6.18-EL5.6 directory, but don't see
> that in the lustre build log file which heightens my suspicion of
> missing patches.

The ofa kernel configure/build scripts are not detecting that your kernel source is RHEL5.x.  If you just use the 
ofa_kernel tree to build/install the OFED modules, then you can specify explicitly which backport patches to use when 
you configure it.  Or if you correctly name your kernel tree and set the version to be something like 
2.6.18-238.el5.lustre18 it should correctly detect it.


> Is there a parameter i can override somewhere tell rpmbuild that even
> though the kernel version doesn't match 2.6.18-238 it really is a
> 2.6.18-238 kernel?
>
> thanks
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
