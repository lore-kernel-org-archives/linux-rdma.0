From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH rdma-core 0/5] Common systemd/udev based boot support
Date: Tue, 25 Jul 2017 11:27:50 -0500
Message-ID: <00e601d30562$f5a7dff0$e0f79fd0$@opengridcomputing.com>
References: <1500929067-1583-1-git-send-email-jgunthorpe@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1500929067-1583-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Jason Gunthorpe' <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, 'Leon Romanovsky' <notifications-9UaJU3cA/F/QT0dZR+AlfA@public.gmane.org>, 'Doug Ledford' <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, 'Ram Amrani' <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, 'Ira Weiny' <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Benjamin Drung' <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, 'Jarod Wilson' <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> I do not have nearly enough hardware to exhaustively test this, I have checked
> that the basic elements are working, but there is lots of room for little
> errors, particularly in module names and udev matching. It would be great of
> someone could try this on iwarp hardware and confirm all the autoloading works
> as expected.

Hey Jason,

Thanks for doing all this!  I'm testing with cxgb4 today.

I get these errors building the rpms using the spec file in your tree:

Checking for unpackaged file(s): /usr/lib/rpm/check-files
/root/rpmbuild/BUILDROOT/rdma-core-15-1.el7.x86_64
error: Installed (but unpackaged) file(s) found:
   /etc/rdma/modules/infiniband.conf
   /etc/rdma/modules/iwarp.conf
   /etc/rdma/modules/iwpmd.conf
   /etc/rdma/modules/opa.conf
   /etc/rdma/modules/rdma.conf
   /etc/rdma/modules/roce.conf
   /etc/rdma/modules/srp_daemon.conf


RPM build errors:
    Installed (but unpackaged) file(s) found:
   /etc/rdma/modules/infiniband.conf
   /etc/rdma/modules/iwarp.conf
   /etc/rdma/modules/iwpmd.conf
   /etc/rdma/modules/opa.conf
   /etc/rdma/modules/rdma.conf
   /etc/rdma/modules/roce.conf
   /etc/rdma/modules/srp_daemon.conf

Are these expected?


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
