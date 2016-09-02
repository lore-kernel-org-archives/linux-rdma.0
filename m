From: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v1] IB/ipoib: Report SG feature regardless of HW UD CSUM capability
Date: Thu, 1 Sep 2016 21:10:22 -0400
Message-ID: <20160902011021.GB23742@phlsvsds.ph.intel.com>
References: <1468827648-17275-1-git-send-email-yuval.shaia@oracle.com> <20160718171921.GA3193@obsidianresearch.com> <20160719125556.GA14768@yuval-lap.uk.oracle.com> <20160719193453.GA28288@obsidianresearch.com> <20160719200231.GC6129@yuval-lap.uk.oracle.com> <20160719201113.GC28288@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160719201113.GC28288-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Jul 19, 2016 at 02:11:13PM -0600, Jason Gunthorpe wrote:
> On Tue, Jul 19, 2016 at 11:02:32PM +0300, Yuval Shaia wrote:
> 
> > ok, i see the point but as Leon Romanovsky mentioned - this is not an issue
> > with the patch itself, right? i.e. the original code relays on the fact
> > that HW supports UD-CSUM and did not checked QP's sg limit (we even do not
> > have any QP at this stage yet).
> 
> ud-csum was only supported by one IB vendor and that vendor supports
> SG.
> 
> You are changing things to enable SG on hardware that has never had SG
> enabled, so you need to make sure it works right..

My thoughts exactly.
Ira

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
