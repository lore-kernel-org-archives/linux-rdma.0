From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: Further thoughts on uAPI
Date: Thu, 21 Apr 2016 14:35:45 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373AB0442B5@ORSMSX109.amr.corp.intel.com>
References: <20160420012526.GA25508@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A82373AB044043@ORSMSX109.amr.corp.intel.com>
 <20160421140347.GI26951@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160421140347.GI26951-2ukJVAZIZ/Y@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, OFVWG <ofvwg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> > > The kernel common code side is pretty straightforward, just a bunch of
> > > tables of function pointers, templates and idrs for each object_type.
> >
> > This is the part where the intent and implementation are not clear to
> me.
> 
> The implementation and expected behavior will be easily achieved by the
> following pseudo code:
> 
> .. ioctl call
> .... pre rdma core hook
> ---- rdma core code
> ---- post rdma core hook

Pre/post hooks are not the same behavior.  The difference is that the driver registers with the ioctl interface directly and is not required to hook into a specific kernel interface.  It's not hooking a core ioctl, it's exposing its own. 

> Why do you need to mark commands as legacy?

Because we're talking about a new ioctl/command format.  I would kill them entirely, but I want to make the path forward as smooth as possible.  A driver should not be forced to change the kernel core interfaces to export some HW capability to user space.  That's the problem we're trying to solve, and I think it's an architectural problem inherent in the RDMA stack, not a maintainer issue as some believe.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
