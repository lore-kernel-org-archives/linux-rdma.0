From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH] iser-target: Fix possible use-after-free in connection
 establishment error
Date: Sat, 13 Jan 2018 11:08:41 -0700
Message-ID: <20180113180841.GB32353@ziepe.ca>
References: <20171126133104.22710-1-sagi@grimberg.me>
 <3676820c-544e-8ced-859a-ade8e6a0ef53@grimberg.me>
 <BN3PR07MB25782C93E50A7A0C55A110B4F83B0@BN3PR07MB2578.namprd07.prod.outlook.com>
 <eda02d71-cf33-2333-223a-0d6eeabb8185@grimberg.me>
 <e11259b7-5add-bf87-73d4-49483c90bf73@mellanox.com>
 <20180109171718.GC4518@ziepe.ca>
 <1515621286.3403.172.camel@redhat.com>
 <1515822365.24576.100.camel@haakon3.daterainc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1515822365.24576.100.camel@haakon3.daterainc.com>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Doug Ledford <dledford@redhat.com>, Max Gurtovoy <maxg@mellanox.com>, Sagi Grimberg <sagi@grimberg.me>, "Amrani, Ram" <Ram.Amrani@cavium.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, target-devel <target-devel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Jan 12, 2018 at 09:46:05PM -0800, Nicholas A. Bellinger wrote:
> On Wed, 2018-01-10 at 16:54 -0500, Doug Ledford wrote:
> > On Tue, 2018-01-09 at 10:17 -0700, Jason Gunthorpe wrote:
> > > On Tue, Jan 09, 2018 at 07:04:16PM +0200, Max Gurtovoy wrote:
> > > > hi Guys,
> > > > did we forget taking this fix to mainline/stable or we found another
> > > > solution ?
> > > 
> > > I thought it was going to NAB's tree.. My mistake, I put it back into
> > > patchworks and it will get into for-next
> > 
> > In fairness, the email thread said exactly that.  But, it never got
> > picked up by NAB.  And being that it's in our tree and calling an rdma-
> > core function, it can easily enough go through our tree, so I applied it
> > to for-rc.
> 
> Thanks Sagi + Ram, and Doug for picking this up.
> 
> Per the earlier discussion, it looks like this needs a stable CC,
> right..?  As Sagi mentioned, it's not clear if this is a regression vs.
> generic RDMA READ/WRITE API logic, or a day one issue.
> 
> So how about adding a 4.7+ stable tag, to match commit a060b5629..?

That can be done:

Fixes: a060b5629ab0 ("IB/core: generic RDMA READ/WRITE API")
Cc: <stable@vger.kernel.org> # 4.7+
Reported-by: Amrani, Ram <Ram.Amrani@cavium.com>
Signed-off-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Doug Ledford <dledford@redhat.com>

Doug: I took your wip/dl-for-rc branch, revised the commit message and
pushed it to for-rc.

Jason
