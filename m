From: Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Subject: Re: [PATCH 407/493] infiniband: remove use of __devexit
Date: Mon, 19 Nov 2012 15:00:06 -0800
Message-ID: <20121119230006.GA2523@kroah.com>
References: <1353349642-3677-1-git-send-email-wfp5p@virginia.edu>
 <1353349642-3677-407-git-send-email-wfp5p@virginia.edu>
 <20121119200921.GD1556@obsidianresearch.com>
 <20121119201938.GA5614@kroah.com>
 <20121119214922.GA5636@obsidianresearch.com>
 <20121119220632.GA1946@kroah.com>
 <20121119224845.GB5636@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20121119224845.GB5636-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Bill Pemberton <wfp5p-4Ng6DfrEGID2fBVCVOL8/A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Nov 19, 2012 at 03:48:45PM -0700, Jason Gunthorpe wrote:
> On Mon, Nov 19, 2012 at 02:06:32PM -0800, Greg KH wrote:
> 
> > > 5k isn't a lot, but in the context of 'I have to figure out how to
> > > trim ~1MB off the 3.6 kernel to run it in our smallest hardware' it is
> > > the wrong direction :(
> > 
> > It is only 0.138% in the "wrong" direction.  Seriously, that's a very
> > tiny percentage here, for an option that people _always_ get wrong, and
> > almost no system does not need.  The number of bugs we have had in this
> > area is huge, and by fixing this option like this, it takes them all
> > away.
> 
> Sure, it isn't a lot. I don't have any idea about problems
> CONFIG_HOTPLUG causes, but it seems alot of work has gone into making
> this option over the years (the patch to remove it is huge), is there
> no other way to get what you want?

The patch overall, is only 7kb or so.  It's the fact that it is just
removing the __dev* markings all over the tree that makes it so "big".
The big change is just in a very few places in the kernel core that
actually do something different depending on CONFIG_HOTPLUG or not.

I could just leave things alone, with CONFIG_HOTPLUG always enabled, but
then people will continue to blindly use the __dev* markings, getting it
wrong at times, but never realizing that they don't do anything anymore.

Because they don't do anything anymore, the right thing to do is just
remove them, which is what Bill's patches do.

Hope this helps explain things better.

thanks,

greg k-h
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
