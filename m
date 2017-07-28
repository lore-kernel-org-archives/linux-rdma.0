From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH v2 rdma-core 0/6] Common udev/systemd based module auto loading
Date: Fri, 28 Jul 2017 08:54:42 -0500
Message-ID: <001e01d307a9$10387800$30a96800$@opengridcomputing.com>
References: <1501194685-9447-1-git-send-email-jgunthorpe@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1501194685-9447-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Jason Gunthorpe' <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, 'Leon Romanovsky' <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, 'Doug Ledford' <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, 'Ram Amrani' <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, 'Ira Weiny' <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Benjamin Drung' <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, 'Jarod Wilson' <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> 
> Here is the next revision of the systemd module autoloading approach.
> 
> All the comments have been collected and a few other things addressed.
> 

It would be great to have a change list from the previous version.

> Notably, at least on debian, when rdma-core is installed for the first time it
> activates the new udev rules and moduels autoload immediately, no reboot
> required. Not sure about RH's policies, so leaving this to them to copy if
> desired.
> 
> There have been positive test results now for rxe, mlx4 (IB), qedr and cxgb4
> on Debian derived.

My cxgb4 testing was on the RHEL7.3 distro.

Steve.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
