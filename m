From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-core 0/5] Common systemd/udev based boot support
Date: Tue, 25 Jul 2017 11:05:06 -0600
Message-ID: <20170725170506.GB3164@obsidianresearch.com>
References: <1500929067-1583-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <00e601d30562$f5a7dff0$e0f79fd0$@opengridcomputing.com>
 <20170725164004.GA20959@obsidianresearch.com>
 <00f601d30567$b1300140$139003c0$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <00f601d30567$b1300140$139003c0$@opengridcomputing.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, 'Leon Romanovsky' <notifications-9UaJU3cA/F/QT0dZR+AlfA@public.gmane.org>, 'Doug Ledford' <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, 'Ram Amrani' <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, 'Ira Weiny' <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Benjamin Drung' <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, 'Jarod Wilson' <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Jul 25, 2017 at 12:01:43PM -0500, Steve Wise wrote:

> Hmm, the rdma-core rpm built ok, but there are no libs or commands in it. ?  I
> think I'm in the weeds. here :)  

The redhat/rdma-core.spec produces 12 rpms:

ibacm-15-1.el7.centos.x86_64.rpm
iwpmd-15-1.el7.centos.x86_64.rpm
libibcm-15-1.el7.centos.x86_64.rpm
libibumad-15-1.el7.centos.x86_64.rpm
libibverbs-15-1.el7.centos.x86_64.rpm
libibverbs-utils-15-1.el7.centos.x86_64.rpm
librdmacm-15-1.el7.centos.x86_64.rpm
librdmacm-utils-15-1.el7.centos.x86_64.rpm
rdma-core-15-1.el7.centos.x86_64.rpm
rdma-core-debuginfo-15-1.el7.centos.x86_64.rpm
rdma-core-devel-15-1.el7.centos.x86_64.rpm
srp_daemon-15-1.el7.centos.x86_64.rpm

The rdma-core package in this system only contains the kernel boot
support.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
