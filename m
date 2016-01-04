From: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] IB/mad: Ensure fairness in ib_mad_completion_handler
Date: Sun, 3 Jan 2016 22:10:03 -0500
Message-ID: <20160104031003.GA5630@phlsvsds.ph.intel.com>
References: <1449784350-30214-1-git-send-email-ira.weiny@intel.com> <20151229091730.GA8445@infradead.org> <56825797.5030008@dev.mellanox.co.il> <20151229174014.GA329@phlsvsds.ph.intel.com> <20151230110133.GA4859@infradead.org> <20151231020007.GB329@phlsvsds.ph.intel.com> <20160102170331.GC21479@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160102170331.GC21479-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sat, Jan 02, 2016 at 09:03:31AM -0800, Christoph Hellwig wrote:
> On Wed, Dec 30, 2015 at 09:00:07PM -0500, ira.weiny wrote:
> > On Wed, Dec 30, 2015 at 03:01:33AM -0800, Christoph Hellwig wrote:
> > > Hi Ira,
> > > 
> > > please take a look at the patches I've attached - they are just WIP
> > > that hasn't been tested as I'm on a vacation without access to my
> > > IB setup until New Year's Eve.
> > 
> > I have them on a branch.
> > 
> > I'll try and do some testing over the weekend.
> 
> FYI, you probably need this fix from Bart:
> 
> http://marc.info/?l=linux-kernel&m=145138288102008&w=2

For some reason I did not...

Ira

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
