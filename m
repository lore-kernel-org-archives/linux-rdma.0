From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: srp warning
Date: Wed, 12 Jan 2011 15:40:16 -0700
Message-ID: <20110112224016.GA2155@obsidianresearch.com>
References: <adalj2q587i.fsf@cisco.com>
 <1294854748.15826.26.camel@lap75545.ornl.gov>
 <ada8vyq57bq.fsf@cisco.com>
 <1294861341.15826.38.camel@lap75545.ornl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1294861341.15826.38.camel-FqX9LgGZnHWDB2HL1qBt2PIbXMQ5te18@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Cc: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Jan 12, 2011 at 02:42:21PM -0500, David Dillow wrote:
> On Wed, 2011-01-12 at 13:02 -0500, Roland Dreier wrote:
> > > Out of curiosity, what version are you using? I've been using 4.4.5 and
> >  > 4.5.1.
> > 
> > $ gcc --version
> > gcc (Ubuntu/Linaro 4.4.4-14ubuntu5) 4.4.5
> > 
> > (on x86-64).  Not sure what changed because I don't think I saw it
> > before either.
> 
> Could you send the contents of drivers/infiniband/ulp/srp/.ib_srp.o.cmd
> from a build showing the warning? And probably the .config as well -- I
> suspect we're using different flags as even gcc 4.1.2 seems to be happy
> for me.

I've noticed that version of gcc giving bogus uninitialized variable
warnings where prior and later gccs don't. I haven't investigated but
it wouldn't surprise me if it was an Ubuntu patch that causes it...

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
