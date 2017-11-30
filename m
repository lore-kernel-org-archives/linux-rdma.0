From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH rdma-core 0/3] Debian 15.1-1 changes
Date: Thu, 30 Nov 2017 11:58:22 -0700
Message-ID: <20171130185822.GE7754@ziepe.ca>
References: <20171130123940.25795-1-benjamin.drung@profitbricks.com>
 <20171130174750.GD7754@ziepe.ca>
 <1512066118.4246.2.camel@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1512066118.4246.2.camel-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Nov 30, 2017 at 07:21:58PM +0100, Benjamin Drung wrote:
> Am Donnerstag, den 30.11.2017, 10:47 -0700 schrieb Jason Gunthorpe:
> > On Thu, Nov 30, 2017 at 01:39:37PM +0100, Benjamin Drung wrote:
> > 
> > >   debian: Add m68k as non-coherent DMA architecture
> > >   debian: Mark libraries as Multi-Arch: same
> > 
> > As Leon says, shouldn't these go on the mainline branch also?
> 
> The complete patch set targets the master branch.

Oh, I see how you working this, I saw them already applied to the
debian branch and didn't quite get it :)

Looks fine to me

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
