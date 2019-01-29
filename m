From: Davidlohr Bueso <dave@stgolabs.net>
Subject: Re: [PATCH 3/6] drivers/IB,qib: do not use mmap_sem
Date: Tue, 29 Jan 2019 06:14:45 -0800
Message-ID: <20190129141445.kch4jxr2ps62ohcw@linux-r8p5>
References: <20190121174220.10583-1-dave@stgolabs.net>
 <20190121174220.10583-4-dave@stgolabs.net>
 <20190128233140.GA12530@ziepe.ca>
 <20190129044607.GL25106@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190129044607.GL25106@ziepe.ca>
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: akpm@linux-foundation.org, dledford@redhat.com, jack@suse.de, ira.weiny@intel.com, linux-rdma@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, dennis.dalessandro@intel.com, mike.marciniszyn@intel.com, Davidlohr Bueso <dbueso@suse.de>
List-Id: linux-rdma@vger.kernel.org

On Mon, 28 Jan 2019, Jason Gunthorpe wrote:

>.. and I'm looking at some of the other conversions here.. *most
>likely* any caller that is manipulating rlimit for get_user_pages
>should really be calling get_user_pages_longterm, so they should not
>be converted to use _fast?

Yeah this was something that crossed my mind could come up when I
first sent the series. I'll send a v3 where I leave the gup() calls
alone for rdma drivers; and we can at least convert the mmap_sem to
reader.

Thanks,
Davidlohr
