From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 11/13] srp_daemon: Add the debian initscripts as an option
Date: Wed, 28 Sep 2016 15:13:04 -0600
Message-ID: <20160928211304.GA3395@obsidianresearch.com>
References: <1474658228-5390-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <1474658228-5390-12-git-send-email-jgunthorpe@obsidianresearch.com>
 <57EC0B75.3000101@redhat.com>
 <20160928184708.GA31472@obsidianresearch.com>
 <57EC120F.7070506@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <57EC120F.7070506-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Sep 28, 2016 at 02:55:11PM -0400, Doug Ledford wrote:

> I'm in favor of providing a good, reliable, correct set of startup files
> for each of the major distro flavors.

Okay, how about a initscripts/{debian,centos6,suse..} directory tree,
and centralize all the initscripts there? Some one who understands
this can then try and eventually make sense of the duplication?

> > We are short unit files, could you
> >    contribute yours?
> 
> Absolutely.  I'd like to basically import the entire redhat rdma package
> into this, but it will take a little sorting things out to get all of
> the files and such in the right place.  And that's a precursor to our
> srpd unit file as it lists a specific dependency on the rdma unit file.

Yeah, that rdma unit file and udev integration really needs to be
upstream and in all distros if we are going to have any hope of having
upstream unit files...

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
