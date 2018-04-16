From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH] IB: make INFINIBAND_ADDR_TRANS configurable
Date: Mon, 16 Apr 2018 08:51:53 -0600
Message-ID: <20180416145153.GA23029@ziepe.ca>
References: <20180413070644.11974-1-gthelen@google.com>
 <20180415120636.GA10759@infradead.org>
 <CAHH2K0ZKqDt2OS1RN7i6qqc=VyPfhzC5sfSSb4ktDdtZnzAhCA@mail.gmail.com>
 <20180416085620.GA30363@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180416085620.GA30363@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Greg Thelen <gthelen@google.com>, Doug Ledford <dledford@redhat.com>, linux-rdma@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, Tarick Bedeir <tarick@google.com>
List-Id: linux-rdma@vger.kernel.org

On Mon, Apr 16, 2018 at 01:56:20AM -0700, Christoph Hellwig wrote:
> On Mon, Apr 16, 2018 at 04:02:12AM +0000, Greg Thelen wrote:
> > I think I've identified the set of options which use
> > INFINIBAND_ADDR_TRANS without a kconfig depends:
> > * CIFS_SMB_DIRECT
> > * INFINIBAND_SRPT
> > * NVME_RDMA
> > * NVME_TARGET_RDMA
> > 
> > I have patches for the above, but need to finish the commit logs.  Let me
> > know if they'll be nacked and I'll just patch my kernel and forget
> > upstreaming.
> 
> I think those are what is needed.  But better do a full cycle through
> the build bot first..

Yes, you have to post the full series and have the build bots say it
is clean, collect acks from the various maintainers and then we can
apply the whole thing through RDMA..

I n't want to apply kconfig changes piecemeal, we just get bug reports
from build bots that way.

Jason
