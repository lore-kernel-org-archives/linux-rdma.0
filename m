From: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Subject: Re: compile ofed 1.5.3 against lustre kernel
Date: Wed, 15 Jun 2011 16:12:02 -0500 (CDT)
Message-ID: <alpine.DEB.2.00.1106151610040.4224@router.home>
References: <BANLkTin1Pg3e0S=2Hb3=0W=M_qo_TiqRrw@mail.gmail.com> <4DF7C80D.1060408@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4DF7C80D.1060408-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: Michael Di Domenico <mdidomenico4-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, 14 Jun 2011, Steve Wise wrote:

> The ofa kernel configure/build scripts are not detecting that your kernel
> source is RHEL5.x.  If you just use the ofa_kernel tree to build/install the
> OFED modules, then you can specify explicitly which backport patches to use
> when you configure it.  Or if you correctly name your kernel tree and set the
> version to be something like 2.6.18-238.el5.lustre18 it should correctly
> detect it.

I surely wish this constant nightmare would go away. Could we please have
OFED trees against each kernel version in use somewhere so that we can
just do a git pull to get these into the respective trees?

This OFED divining the kernel version and then the application of upgrade
/ downgrade patches makes a lot of things very hard.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
