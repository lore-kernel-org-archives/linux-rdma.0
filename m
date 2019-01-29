From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH 3/6] drivers/IB,qib: do not use mmap_sem
Date: Tue, 29 Jan 2019 16:19:03 -0700
Message-ID: <20190129231903.GA5352@ziepe.ca>
References: <20190121174220.10583-1-dave@stgolabs.net>
 <20190121174220.10583-4-dave@stgolabs.net>
 <20190128233140.GA12530@ziepe.ca>
 <20190129044607.GL25106@ziepe.ca>
 <20190129185005.GC10129@iweiny-DESK2.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190129185005.GC10129@iweiny-DESK2.sc.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ira Weiny <ira.weiny@intel.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>, akpm@linux-foundation.org, dledford@redhat.com, jack@suse.de, linux-rdma@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, dennis.dalessandro@intel.com, mike.marciniszyn@intel.com, Davidlohr Bueso <dbueso@suse.de>
List-Id: linux-rdma@vger.kernel.org

On Tue, Jan 29, 2019 at 10:50:05AM -0800, Ira Weiny wrote:
> > .. and I'm looking at some of the other conversions here.. *most
> > likely* any caller that is manipulating rlimit for get_user_pages
> > should really be calling get_user_pages_longterm, so they should not
> > be converted to use _fast?
> 
> Is this a question?  I'm not sure I understand the meaning here?

More an invitation to disprove the statement

Jason
