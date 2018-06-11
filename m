From: Jason Gunthorpe <jgg@mellanox.com>
Subject: Re: [PATCH 2/2] IB/mad: Use IDR for agent IDs
Date: Sun, 10 Jun 2018 22:42:03 -0600
Message-ID: <20180611044203.GA32562@mellanox.com>
References: <20180608174218.32455-1-willy@infradead.org>
 <20180608174218.32455-3-willy@infradead.org>
 <20180610063028.GH12407@mtr-leonro.mtl.com>
 <20180610104305.GA9284@bombadil.infradead.org>
 <20180610122505.GM12407@mtr-leonro.mtl.com>
 <20180610203027.GF5560@mellanox.com>
 <20180611043425.GA21382@mtr-leonro.mtl.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180611043425.GA21382@mtr-leonro.mtl.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>
Cc: Matthew Wilcox <willy@infradead.org>, hans.westgaard.ry@oracle.com, Doug Ledford <dledford@redhat.com>, Matthew Wilcox <mawilcox@microsoft.com>, linux-rdma@vger.kernel.org, =?utf-8?B?SMOla29u?= Bugge <haakon.bugge@oracle.com>, Parav Pandit <parav@mellanox.com>, Jack Morgenstein <jackm@dev.mellanox.co.il>, Pravin Shedge <pravin.shedge4linux@gmail.com>, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Jun 11, 2018 at 07:34:25AM +0300, Leon Romanovsky wrote:
> On Sun, Jun 10, 2018 at 02:30:27PM -0600, Jason Gunthorpe wrote:
> > On Sun, Jun 10, 2018 at 03:25:05PM +0300, Leon Romanovsky wrote:
> > > On Sun, Jun 10, 2018 at 03:43:05AM -0700, Matthew Wilcox wrote:
> > > > On Sun, Jun 10, 2018 at 09:30:28AM +0300, Leon Romanovsky wrote:
> > > > > 1. IBTA spec doesn't talk at all about the size of TransactionID, more
> > > > > on that in section "13.4.6.4 TRANSACTION ID USAGE", the specification
> > > > > says: "The contents of the TransactionID (TID) field are implementation-
> > > > > dependent. So let's don't call it mlx4 bug.
> > > >
> > > > I was loosely paraphrasing the original bug report; suggested rewording
> > > > of the comments gratefully accepted.
> > >
> > > Just replace "mlx4 bug" with something like "to comply with mlx4
> > > implementation".
> >
> > Well, it is a bug. Blindly replacing the upper 8 bits of the TID in a
> > driver without accommodation from the core is totally, bonkers wrong.
> 
> I provided cite from spec that says that TID can be whatever you want as
> long as you success to do it unique.

Er, the spec has nothing to do with this. In Linux the TID is made
unique because the core code provides 32 bits that are unique and the
user provides another 32 bits that are unique. The driver cannot
change any of those bits without risking non-uniquenes, which is
exactly the bug mlx4 created when it stepped outside its bounds and
improperly overrode bits in the TID for its own internal use.

Jason
