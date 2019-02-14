From: "Steve Wise" <swise@opengridcomputing.com>
Subject: RE: [rdma-rc PATCH 2/2] iw_cxgb4: cq/qp mask depends on bar2 pages in a host page
Date: Thu, 14 Feb 2019 11:54:16 -0600
Message-ID: <019501d4c48e$4de3ec90$e9abc5b0$@opengridcomputing.com>
References: <20190214121054.11693-1-rajur@chelsio.com> <20190214121054.11693-3-rajur@chelsio.com> <20190214154127.GD1725@mellanox.com> <20190214172801.GA12408@chelsio.com>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190214172801.GA12408@chelsio.com>
Content-Language: en-us
Sender: netdev-owner@vger.kernel.org
To: 'Raju Rangoju' <rajur@chelsio.com>, 'Jason Gunthorpe' <jgg@mellanox.com>
Cc: davem@davemloft.net, linux-rdma@vger.kernel.org, netdev@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org



> -----Original Message-----
> From: linux-rdma-owner@vger.kernel.org <linux-rdma-
> owner@vger.kernel.org> On Behalf Of Raju Rangoju
> Sent: Thursday, February 14, 2019 11:28 AM
> To: Jason Gunthorpe <jgg@mellanox.com>
> Cc: davem@davemloft.net; linux-rdma@vger.kernel.org;
> netdev@vger.kernel.org; swise@opengridcomputing.com
> Subject: Re: [rdma-rc PATCH 2/2] iw_cxgb4: cq/qp mask depends on bar2
> pages in a host page
> 
> On Thursday, February 02/14/19, 2019 at 15:41:34 +0000, Jason Gunthorpe
> wrote:
> > On Thu, Feb 14, 2019 at 05:40:54PM +0530, Raju Rangoju wrote:
> > > Adjust the cq/qp mask based on no.of bar2 pages in a host page.
> > >
> > > For user-mode rdma, the granularity of the BAR2 memory mapped
> > > to a user rdma process during queue allocation must be based
> > > on the host page size. The lld attributes udb_density and
> > > ucq_density are used to figure out how many sge contexts are
> > > in a bar2 page. So the rdev->qpmask and rdev->cqmask in
> > > iw_cxgb4 need to now be adjusted based on how many sge bar2
> > > pages are in a host page.
> >
> > Why is this rc? Do certain arches fail to work or something?
> >
> 
> Yes, this series fixes a regression that was introduced by commit
> 2391b0030e (v5.0-rc1~129^2~272)
> 
> > Jason

Rdma over cxgb4 on arches with a non-4K page size are busted w/o this fix.
That was the motivation for -rc.
