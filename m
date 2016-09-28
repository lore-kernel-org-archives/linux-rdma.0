From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 11/13] srp_daemon: Add the debian initscripts as an option
Date: Wed, 28 Sep 2016 12:47:08 -0600
Message-ID: <20160928184708.GA31472@obsidianresearch.com>
References: <1474658228-5390-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <1474658228-5390-12-git-send-email-jgunthorpe@obsidianresearch.com>
 <57EC0B75.3000101@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <57EC0B75.3000101-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Sep 28, 2016 at 02:27:01PM -0400, Doug Ledford wrote:
> On 9/23/16 3:17 PM, Jason Gunthorpe wrote:
> > Necessary to reproduce the Debian packaging.
> > 
> > Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
> >  CMakeLists.txt                       |  3 ++
> >  srp_daemon/srp_daemon/CMakeLists.txt | 29 ++++++++----
> >  srp_daemon/srptools.default          | 14 ++++++
> >  srp_daemon/srptools.init             | 89 ++++++++++++++++++++++++++++++++++++
> 
> Would it be best to have directories for related install files for a
> specific OS?  For instance, srp_daemon/debian/ and srp_daemon/redhat/?
> It's not that I expect to put a redhat init script for srpd in place,
> but the script for debian is likely to not work properly on redhat, so
> having it in an OS directory would at least make that clear.

To be clear, there is already an initscript that (perhaps?) is for
RedHat - but it isn't even close to the Debian version. So this patch
introduces two scripts for srp_dameon, which I hated doing..

I'll drop this patch from the series and we can go ahead with the
other patches in the series.

For now I'll put the initscript in the Debian packaging patch and we
can think about what to do later. I think it can be moved to the
debian/ directory as well.

Going forward I think we need to make some decisions..

1) Do we want to do something with the initscripts so distros can use
   them? Is that even possible? I think Debian uses the bundled
   acm initscript, didn't look at suse.

   Is Debian the only major distro that still ships init scripts?
   Does FC/RH exclusively ship systemd unit files now?

   Maybe we should delete the initscripts entirely.

2) I'd like to support cross-distro systemd unit files upstream.
   Is that feasible? We are short unit files, could you
   contribute yours?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
