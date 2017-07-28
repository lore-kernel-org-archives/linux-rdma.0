From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH v2 rdma-core 0/6] Common udev/systemd based module auto
 loading
Date: Fri, 28 Jul 2017 10:11:02 -0600
Message-ID: <20170728161102.GA24226@obsidianresearch.com>
References: <1501194685-9447-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <001e01d307a9$10387800$30a96800$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <001e01d307a9$10387800$30a96800$@opengridcomputing.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, 'Leon Romanovsky' <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, 'Doug Ledford' <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, 'Ram Amrani' <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, 'Ira Weiny' <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Benjamin Drung' <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, 'Jarod Wilson' <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Jul 28, 2017 at 08:54:42AM -0500, Steve Wise wrote:
> > Here is the next revision of the systemd module autoloading approach.
> > 
> > All the comments have been collected and a few other things addressed.
> 
> It would be great to have a change list from the previous version.

Heh, it is getting hard, this started out as a little four patch
series and somehow expanded into about a 40 patch monster.

Broadly
 - Add udevadm trigger's to the post install
 - Udev ID_RDMA_ROCE triggers for rxe
 - Various documentation improvements
 - Packaging fixes (eg ./rdma-core.spec works)
 - Fixing ID_RDMA_OPA for hif1verbs

> > There have been positive test results now for rxe, mlx4 (IB), qedr and cxgb4
> > on Debian derived.
> 
> My cxgb4 testing was on the RHEL7.3 distro.

Right, I was tring to say my testing was on Debian

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
