From: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH RFC 2/2] RDMA/nldev: provide detailed CM_ID information
Date: Mon, 5 Feb 2018 13:36:08 -0700
Message-ID: <20180205203608.GJ11446@mellanox.com>
References: <cover.1517418595.git.swise@opengridcomputing.com>
 <531889e6a24f7919dec71734c91298d266aa9721.1517418595.git.swise@opengridcomputing.com>
 <20180201084944.GH2055@mtr-leonro.local>
 <00ce01d39b76$bd374ac0$37a5e040$@opengridcomputing.com>
 <20180204150553.GH27780@mtr-leonro.local>
 <015301d39e96$9f5e0b60$de1a2220$@opengridcomputing.com>
 <20180205200020.GH11446@mellanox.com>
 <026201d39ebf$d1f087a0$75d196e0$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <026201d39ebf$d1f087a0$75d196e0$@opengridcomputing.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: 'Leon Romanovsky' <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Feb 05, 2018 at 02:28:02PM -0600, Steve Wise wrote:
> > On Mon, Feb 05, 2018 at 09:33:07AM -0600, Steve Wise wrote:
> > 
> > > Perhaps we add a device-unique (or globally unique) identifier as part
> of
> > > the restrack struct and use that for GET/SET?
> > 
> > What use is an ID if the user can't associate that with something
> > meaningful?
> 
> It uniquely identifies the widget you want to GET or SET.  Ideally, having
> it be something meaningful is nice, but if we want to support GET/SET on
> various single objects, we need identifiers.  And assigning them as part of
> restrack would do the trick.  
> 
> However, I don't see GET/SET being useful for QP, CQ, PD, CM_ID, nor MR
> resources.  Just DUMP.  I do see perhaps devices and links having GET/SET.
> For instance setting up stuff for RXE and SIW soft devices. 

Well exactly.. I don't expect GET/SET for restrack objects..

> > For userspace, a tuple of the filehandle and existing the per-file
> > handle # would make some sense as a unique ID, but userspace is going
> > to have a pointer not necessarily the handle number :(
> 
> I'm not following you here.  Who does filehandle/handle# pertain to rdmatool
> fetching objects via netlnk and possibly setting them?  

It is the other side of the question - when rdmatool presents me an
object how do I figure out what it is in 'my world' as userspace.

Like a PD for instance.. If I have two in a process how do I know
which is which compared to a dump?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
