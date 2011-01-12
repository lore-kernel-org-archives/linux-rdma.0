From: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Subject: Re: srp warning
Date: Wed, 12 Jan 2011 17:44:18 -0500
Message-ID: <1294872258.15826.51.camel@lap75545.ornl.gov>
References: <adalj2q587i.fsf@cisco.com>
 <1294854748.15826.26.camel@lap75545.ornl.gov> <ada8vyq57bq.fsf@cisco.com>
 <1294861341.15826.38.camel@lap75545.ornl.gov>
 <20110112224016.GA2155@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-reply-to: <20110112224016.GA2155-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, 2011-01-12 at 17:40 -0500, Jason Gunthorpe wrote:
> On Wed, Jan 12, 2011 at 02:42:21PM -0500, David Dillow wrote:
> > On Wed, 2011-01-12 at 13:02 -0500, Roland Dreier wrote:
> > > > Out of curiosity, what version are you using? I've been using 4.4.5 and
> > >  > 4.5.1.
> > > 
> > > $ gcc --version
> > > gcc (Ubuntu/Linaro 4.4.4-14ubuntu5) 4.4.5

> I've noticed that version of gcc giving bogus uninitialized variable
> warnings where prior and later gccs don't. I haven't investigated but
> it wouldn't surprise me if it was an Ubuntu patch that causes it...

I get it on Fedora 14's 4.5.1 with -Os as well, so I suspect something
is broken upstream with that option, though it is possible they are
carrying the same/similar patch.
-- 
Dave Dillow
National Center for Computational Science
Oak Ridge National Laboratory
(865) 241-6602 office


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
