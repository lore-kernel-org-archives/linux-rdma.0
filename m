From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH] iser-target: Fix possible use-after-free in connection
 establishment error
Date: Fri, 12 Jan 2018 21:46:05 -0800
Message-ID: <1515822365.24576.100.camel@haakon3.daterainc.com>
References: <20171126133104.22710-1-sagi@grimberg.me>
         <3676820c-544e-8ced-859a-ade8e6a0ef53@grimberg.me>
         <BN3PR07MB25782C93E50A7A0C55A110B4F83B0@BN3PR07MB2578.namprd07.prod.outlook.com>
         <eda02d71-cf33-2333-223a-0d6eeabb8185@grimberg.me>
         <e11259b7-5add-bf87-73d4-49483c90bf73@mellanox.com>
         <20180109171718.GC4518@ziepe.ca> <1515621286.3403.172.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1515621286.3403.172.camel@redhat.com>
Sender: target-devel-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Max Gurtovoy <maxg@mellanox.com>, Sagi Grimberg <sagi@grimberg.me>, "Amrani, Ram" <Ram.Amrani@cavium.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, target-devel <target-devel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, 2018-01-10 at 16:54 -0500, Doug Ledford wrote:
> On Tue, 2018-01-09 at 10:17 -0700, Jason Gunthorpe wrote:
> > On Tue, Jan 09, 2018 at 07:04:16PM +0200, Max Gurtovoy wrote:
> > > hi Guys,
> > > did we forget taking this fix to mainline/stable or we found another
> > > solution ?
> > 
> > I thought it was going to NAB's tree.. My mistake, I put it back into
> > patchworks and it will get into for-next
> 
> In fairness, the email thread said exactly that.  But, it never got
> picked up by NAB.  And being that it's in our tree and calling an rdma-
> core function, it can easily enough go through our tree, so I applied it
> to for-rc.

Thanks Sagi + Ram, and Doug for picking this up.

Per the earlier discussion, it looks like this needs a stable CC,
right..?  As Sagi mentioned, it's not clear if this is a regression vs.
generic RDMA READ/WRITE API logic, or a day one issue.

So how about adding a 4.7+ stable tag, to match commit a060b5629..?
