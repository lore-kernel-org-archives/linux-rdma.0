From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: WARNING: bad unlock balance in ucma_event_handler
Date: Tue, 11 Jun 2019 14:57:49 -0300
Message-ID: <20190611175749.GA29375@ziepe.ca>
References: <000000000000af6530056e863794@google.com>
 <20180613170543.GB30019@ziepe.ca>
 <20190610184853.GG63833@gmail.com>
 <20190610194732.GH18468@ziepe.ca>
 <20190610204523.GK63833@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190610204523.GK63833@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Eric Biggers <ebiggers@kernel.org>
Cc: syzbot <syzbot+e5579222b6a3edd96522@syzkaller.appspotmail.com>, dasaratharaman.chandramouli@intel.com, dledford@redhat.com, leon@kernel.org, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, parav@mellanox.com, roland@purestorage.com, sean.hefty@intel.com, syzkaller-bugs@googlegroups.com
List-Id: linux-rdma@vger.kernel.org

On Mon, Jun 10, 2019 at 01:45:24PM -0700, Eric Biggers wrote:
> On Mon, Jun 10, 2019 at 04:47:32PM -0300, Jason Gunthorpe wrote:
> > 
> > There are many unfixed syzkaller bugs in rdma_cm, so I'm not surprised
> > it is still happening..
> > 
> > Nobody has stepped forward to work on this code, and it is not a
> > simple mess to understand, let alone try to fix.
> > 
> 
> But people still use it, right?  Do they not care that it's spewing syzbot
> reports?  Are they depending on the kernel to provide any security properties?

Yes, it should be fixed.

Jason
