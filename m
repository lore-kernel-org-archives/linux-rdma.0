From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: Re: [PATCH 0/7] IB/hfi1: Remove write() and use ioctl() for user
 access
Date: Fri, 15 Apr 2016 17:37:32 -0600
Message-ID: <20160415233732.GB25662@obsidianresearch.com>
References: <20160414153727.6387.96381.stgit@scvm10.sc.intel.com>
 <20160414164550.GC6247@obsidianresearch.com>
 <20160414174830.GA11641@rhel.sc.intel.com>
 <20160415040126.GB10689@leon.nu>
 <20160415161754.GA21549@rhel>
 <20160415173035.GC10689@leon.nu>
 <20160415173401.GA10868@infradead.org>
 <20160415212328.GF10689@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160415212328.GF10689@leon.nu>
Sender: linux-kernel-owner@vger.kernel.org
To: Leon Romanovsky <leon@leon.nu>
Cc: Christoph Hellwig <hch@infradead.org>, Ira Weiny <ira.weiny@intel.com>, Dennis Dalessandro <dennis.dalessandro@intel.com>, dledford@redhat.com, linux-rdma@vger.kernel.org, linux-fsdevel@vger.kernel.org, torvalds@linux-foundation.org, viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Sat, Apr 16, 2016 at 12:23:28AM +0300, Leon Romanovsky wrote:

> Intel as usual decided to do it in their way and the result is presented
> on this mailing list.

Dennis was pretty clear he was going to send the patches to address
Al's concern, which he has done.

I was also pretty clear I was looking to get rid of the char dev :)

Not seeing a problem here.

Jason
