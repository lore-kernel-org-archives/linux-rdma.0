From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH v2] RDMA/cma: Make CM response timeout and # CM retries
 configurable
Date: Thu, 13 Jun 2019 20:46:33 -0300
Message-ID: <20190613234633.GL22901@ziepe.ca>
References: <20190226075722.1692315-1-haakon.bugge@oracle.com>
 <174ccd37a9ffa05d0c7c03fe80ff7170a9270824.camel@redhat.com>
 <67B4F337-4C3A-4193-B1EF-42FD4765CBB7@oracle.com>
 <20190613172355.GF22901@ziepe.ca>
 <1D8E6B14-3336-42B3-B572-596DD2183D89@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1D8E6B14-3336-42B3-B572-596DD2183D89@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: =?utf-8?B?SMOla29u?= Bugge <haakon.bugge@oracle.com>
Cc: Doug Ledford <dledford@redhat.com>, Leon Romanovsky <leon@kernel.org>, Parav Pandit <parav@mellanox.com>, Steve Wise <swise@opengridcomputing.com>, OFED mailing list <linux-rdma@vger.kernel.org>, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Jun 13, 2019 at 07:39:24PM +0200, Håkon Bugge wrote:
> 
> 
> > On 13 Jun 2019, at 19:23, Jason Gunthorpe <jgg@ziepe.ca> wrote:
> > 
> > On Thu, Jun 13, 2019 at 06:58:30PM +0200, Håkon Bugge wrote:
> > 
> >> If you refer to the backlog parameter in rdma_listen(), I cannot see
> >> it being used at all for IB.
> >> 
> >> For CX-3, which is paravirtualized wrt. MAD packets, it is the proxy
> >> UD receive queue length for the PF driver that can be construed as a
> >> backlog. 
> > 
> > No, in IB you can drop UD packets if your RQ is full - so the proxy RQ
> > is really part of the overall RQ on QP1.
> > 
> > The backlog starts once packets are taken off the RQ and begin the
> > connection accept processing.
> 
> Do think we say the same thing. If, incoming REQ processing is
> severly delayed, the backlog is #entries in the QP1 receive queue in
> the PF. I can call rdma_listen() with a backlog of a zillion, but it
> will not help.

backlog and queue depth are different things, we shouldn't confuse
them together..

Jason
