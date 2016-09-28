From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 11/13] srp_daemon: Add the debian initscripts as an option
Date: Wed, 28 Sep 2016 15:01:37 -0600
Message-ID: <20160928210137.GB2533@obsidianresearch.com>
References: <1474658228-5390-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <1474658228-5390-12-git-send-email-jgunthorpe@obsidianresearch.com>
 <57EC0B75.3000101@redhat.com>
 <20160928184708.GA31472@obsidianresearch.com>
 <07810a28-9db1-6dca-0666-d811fe246b7e@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <07810a28-9db1-6dca-0666-d811fe246b7e-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Sep 28, 2016 at 01:18:51PM -0700, Bart Van Assche wrote:
> On 09/28/2016 11:47 AM, Jason Gunthorpe wrote:
> >To be clear, there is already an initscript that (perhaps?) is for
> >RedHat - but it isn't even close to the Debian version. So this patch
> >introduces two scripts for srp_dameon, which I hated doing..
> 
> The existing init script works reliably on multiple versions of RHEL, SLES,
> Fedora and openSuSE. It is not specific to Red Hat distro's. So I'm
> surprised that a separate initscript is needed for Debian?

I suspect not being distro specific is the entire problem, eg the
Debian initscript is using /etc/default/srptools to configure
how the daemon is launched and it uses the start-stop-daemon tool.

A good initscript should consistently follow the distro policies for
initscripts..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
