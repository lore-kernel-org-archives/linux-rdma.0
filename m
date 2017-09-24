From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: crash in 4.14-rc1 with IPoIB
Date: Sun, 24 Sep 2017 14:30:21 -0600
Message-ID: <20170924203021.GC31652@obsidianresearch.com>
References: <20170920095339.zhfymeyfbhiyepz5@linux-x5ow.site>
 <20170920163237.GD536@obsidianresearch.com>
 <1506101272.5172.11.camel@redhat.com>
 <20170922194834.GA26479@obsidianresearch.com>
 <1506114386.120853.2.camel@redhat.com>
 <20170922211727.GA2348@obsidianresearch.com>
 <1506120161.120853.10.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1506120161.120853.10.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Johannes Thumshirn <jthumshirn-l3A5Bk7waGM@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Thomas Bogendoerfer <tbogendoerfer-l3A5Bk7waGM@public.gmane.org>, Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Sep 22, 2017 at 06:42:41PM -0400, Doug Ledford wrote:

> But if that still doesn't resolve their problem, a quick check of the
> mailing list contents isn't out of the question either.  In that case,
> they would have found the solution to their problem.  But, when you get
> right down to it, only one person reported it in addition to the

Well, this has happened twice in recent memory that several people
came to the list hitting something that already had a posted fix. The
port-number issue had more comments, I think we were up to 4? IIRC
Laurance spent a long time bisecting it even.. So I'm not sure 'check
the list' is working.

I view it as a really good sign, it means that people are finally
testing upstream, not just waiting for OFED to test!

Based on the LPC comments the people doing QA can do a better job with
a some process help.

> compensated in their own testing, or (the more likely I think), most
> people don't start testing -rcs until after -rc2.  Which is why I try
> to set -rc2 as a milestone for several purposes.  For getting in the

Hrm, people need to test rc1 :|

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
