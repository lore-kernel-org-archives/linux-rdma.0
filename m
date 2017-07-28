From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH rdma-core 0/5] Common systemd/udev based boot support
Date: Fri, 28 Jul 2017 11:08:36 -0500
Message-ID: <00af01d307bb$c508e690$4f1ab3b0$@opengridcomputing.com>
References: <1500929067-1583-1-git-send-email-jgunthorpe@obsidianresearch.com> <00e601d30562$f5a7dff0$e0f79fd0$@opengridcomputing.com> <20170725164004.GA20959@obsidianresearch.com> <011601d30576$c3ac38c0$4b04aa40$@opengridcomputing.com> <20170725213354.GE10905@obsidianresearch.com> <016901d30590$3eee9910$bccbcb30$@opengridcomputing.com> <20170725220210.GA15663@obsidianresearch.com> <009901d30618$2d957e30$88c07a90$@opengridcomputing.com> <20170726162419.GC20499@obsidianresearch.com> <000d01d307a8$9cc0d660$d6428320$@opengridcomputing.com> <20170728155842.GC9646@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170728155842.GC9646-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Jason Gunthorpe' <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, 'Doug Ledford' <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, 'Ram Amrani' <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, 'Ira Weiny' <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Benjamin Drung' <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, 'Jarod Wilson' <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, 'Chien Tin Tung' <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



> 
> On Fri, Jul 28, 2017 at 08:51:28AM -0500, Steve Wise wrote:
> 
> > Bringing down the NIC interfaces doesn't totally stop the adapter nor
destroy
> > the queues needed for RDMA.  It does bring the links down on the ethernet
> > interfaces though. So it behaves like I thought.   I tested this by running
an
> > rping, and while it was pushing rdma traffic, I did 'ifconfig ethX 0.0.0.0
down'
> > on the interface in use.  The data flow stopped (and the iWARP/TCP stack
started
> > retransmitting).  I then brought the link back up, and after a few seconds
the
> > rping traffic continued on.
> 
> So, why defer creating queues until the first ifup?
> 
> I can understand a nic driver that frees all memory when down (that is
> fairly common), but this arrangement seems really strange..

Maybe I'm mistaken about the need to wait for ifup to register the ULDs.  I do
see the same queues are actually available after cxgb4 loads and before an ifup.
So maybe I can change the uld activation to earlier.



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
