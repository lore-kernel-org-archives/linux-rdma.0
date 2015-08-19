From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 1/3] IB/uverbs: reject invalid or unknown opcodes
Date: Wed, 19 Aug 2015 19:48:02 +0200
Message-ID: <20150819174802.GA13875@lst.de>
References: <1440002254-795-1-git-send-email-hch@lst.de> <1440002254-795-2-git-send-email-hch@lst.de> <20150819174614.GC22646@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150819174614.GC22646@obsidianresearch.com>
Sender: stable-owner@vger.kernel.org
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Christoph Hellwig <hch@lst.de>, Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Eli Cohen <eli@mellanox.com>, linux-rdma@vger.kernel.org, stable@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Aug 19, 2015 at 11:46:14AM -0600, Jason Gunthorpe wrote:
> Reviewed-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
> 
> AFAIK, this path is rarely (never?) actually used. I think all the
> drivers we have can post directly from userspace.

Oh, interesting.  Is there any chance to deprecate it?  Not having
to care for the uvers command would really help with some of the
upcoming changes I have in my mind.
