From: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 05/13] Have cmake run man pages through text substitution
Date: Mon, 26 Sep 2016 06:30:21 +0000
Message-ID: <2807E5FD2F6FDA4886F6618EAC48510E24EEBF1A@CRSMSX101.amr.corp.intel.com>
References: <1474658228-5390-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <1474658228-5390-6-git-send-email-jgunthorpe@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A82373AB08E9D8@ORSMSX109.amr.corp.intel.com>
 <20160923213819.GC8490@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160923213819.GC8490-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> 
> On Fri, Sep 23, 2016 at 09:23:42PM +0000, Hefty, Sean wrote:
> > > rsocket.7 had an errant text substitution that never worked, it is a
> > > good idea to have the man pages use the correct paths, so let us
> > > have cmake run them through.
> > >
> > > Any man page ending in '.in' will be substituted automatically.
> > >
> > > Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
> >
> > Acked-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> >
> > FWIW, I'm in favor of replacing the man pages with markdown and then
> > generating the man pages from that.  I volunteer someone else to do
> > that work.
> 
> I concur, and someone else should do the work ..
> 
> We could begin by requiring all new man pages to be in markdown format.
> Do you do this in libfabric? What conversion tool do you like?
> 
> I've used rst for this in the past with reasonable results..

Infiniband-diags uses rst through rst2man.  But if I had to do it over I would probably do it different.  rst2man is not always installed and has caused build issues for some people.  Whatever tool we use I would recommend it be something common.  I'm not too familiar with markdown.  Is this really common now?

Ira

> 
> Jason
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in the
> body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org More majordomo info at
> http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
