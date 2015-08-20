From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 1/3] IB/uverbs: reject invalid or unknown opcodes
Date: Thu, 20 Aug 2015 11:22:55 +0200
Message-ID: <20150820092255.GA25447@lst.de>
References: <1440002254-795-1-git-send-email-hch@lst.de> <1440002254-795-2-git-send-email-hch@lst.de> <20150819174614.GC22646@obsidianresearch.com> <1828884A29C6694DAF28B7E6B8A82373A9027CDA@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373A9027CDA@ORSMSX109.amr.corp.intel.com>
Sender: stable-owner@vger.kernel.org
To: "Hefty, Sean" <sean.hefty@intel.com>
Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Christoph Hellwig <hch@lst.de>, Doug Ledford <dledford@redhat.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Eli Cohen <eli@mellanox.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Aug 19, 2015 at 07:50:23PM +0000, Hefty, Sean wrote:
> > AFAIK, this path is rarely (never?) actually used. I think all the
> > drivers we have can post directly from userspace.
> 
> I didn't think the ipath or qib drivers post from userspace.

Makes sense with their software IB stack.  Guess the idea to get rid
of this path is dead, would have been too nice..
