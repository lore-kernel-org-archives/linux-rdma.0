From: John Hubbard <jhubbard@nvidia.com>
Subject: Re: [PATCH 1/1] infiniband/mm: convert put_page() to put_user_page*()
Date: Thu, 23 May 2019 15:50:14 -0700
Message-ID: <050f56d0-1dda-036e-e508-3a7255ac7b59@nvidia.com>
References: <20190523072537.31940-1-jhubbard@nvidia.com>
 <20190523072537.31940-2-jhubbard@nvidia.com>
 <20190523172852.GA27175@iweiny-DESK2.sc.intel.com>
 <20190523173222.GH12145@mellanox.com>
 <fa6d7d7c-13a3-0586-6384-768ebb7f0561@nvidia.com>
 <20190523190423.GA19578@iweiny-DESK2.sc.intel.com>
 <0bd9859f-8eb0-9148-6209-08ae42665626@nvidia.com>
 <20190523223701.GA15048@iweiny-DESK2.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190523223701.GA15048@iweiny-DESK2.sc.intel.com>
Content-Language: en-US-large
Sender: linux-kernel-owner@vger.kernel.org
To: Ira Weiny <ira.weiny@intel.com>
Cc: Jason Gunthorpe <jgg@mellanox.com>, Andrew Morton <akpm@linux-foundation.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, Doug Ledford <dledford@redhat.com>, Mike Marciniszyn <mike.marciniszyn@intel.com>, Dennis Dalessandro <dennis.dalessandro@intel.com>, Christian Benvenuti <benve@cisco.com>, Jan Kara <jack@suse.cz>
List-Id: linux-rdma@vger.kernel.org

On 5/23/19 3:37 PM, Ira Weiny wrote:
[...] 
> I've dug in further and I see now that release_pages() implements (almost the
> same thing, see below) as put_page().
> 
> However, I think we need to be careful here because put_page_testzero() calls
> 
> 	page_ref_dec_and_test(page);
> 
> ... and after your changes it will need to call ...
> 
> 	page_ref_sub_return(page, GUP_PIN_COUNTING_BIAS);
> 
> ... on a GUP page:
> 
> So how do you propose calling release_pages() from within put_user_pages()?  Or
> were you thinking this would be temporary?

I was thinking of it as a temporary measure, only up until, but not including the
point where put_user_pages() becomes active. That is, the point when put_user_pages
starts decrementing GUP_PIN_COUNTING_BIAS, instead of just forwarding to put_page().

(For other readers, that's this patch:

    "mm/gup: debug tracking of get_user_pages() references"

...in https://github.com/johnhubbard/linux/tree/gup_dma_core )

> 
> That said, there are 2 differences I see between release_pages() and put_page()
> 
> 1) release_pages() will only work for a MEMORY_DEVICE_PUBLIC page and not all
>    devmem pages...
>    I think this is a bug, patch to follow shortly.
> 
> 2) release_pages() calls __ClearPageActive() while put_page() does not
> 
> I have no idea if the second difference is a bug or not.  But it smells of
> one...
> 
> It would be nice to know if the open coding of put_page is really a performance
> benefit or not.  It seems like an attempt to optimize the taking of the page
> data lock.
> 
> Does anyone have any information about the performance advantage here?
> 
> Given the changes above it seems like it would be a benefit to merge the 2 call
> paths more closely to make sure we do the right thing.
> 

Yes, it does. Maybe best to not do the temporary measure, then, while this stuff
gets improved. I'll look at your other patch...


thanks,
-- 
John Hubbard
NVIDIA
