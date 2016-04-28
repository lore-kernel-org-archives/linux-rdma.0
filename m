From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH] IB/iser: fix max_sectors calculation
Date: Thu, 28 Apr 2016 10:28:02 -0600
Message-ID: <20160428162802.GA29690@obsidianresearch.com>
References: <1461013588-8825-1-git-send-email-hch@lst.de>
 <CAJ3xEMh1kd_tXVrS73j46ns5syrw2WDTovqVpP0snbLru_fbQw@mail.gmail.com>
 <20160428075508.GA18285@lst.de>
 <CAJ3xEMj-HX=dRe8zew3VDZ6X_oodzfxX8SwnROCh1T6cfVNTYg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAJ3xEMj-HX=dRe8zew3VDZ6X_oodzfxX8SwnROCh1T6cfVNTYg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Apr 28, 2016 at 01:51:21PM +0300, Or Gerlitz wrote:
> On Thu, Apr 28, 2016 at 10:55 AM, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org> wrote:
> > I haven't used that explicit language, but:  go fuck yourself, seriously.
> 
> Christoph, I wrote you on both cases this was a nit comment.
> 
> I understand now that you are not willing to accept nits as feedback on
> your fixes, and that you are really nervous on me, happens.

I wondered when this would finally blow up..

I would also prefer the nit picking on commit language to stop. It is
not a welcoming environment for new contributors, and it is a pain to
those who are doing the bulk of the work.

Get Doug to fix stuff up to match your preferences or let it go.

It is *really* not OK to ask Sagi to not ack such commits when the
code is OK. Sagi is doing a fine job.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
