From: John Hubbard <jhubbard@nvidia.com>
Subject: Re: [PATCH 1/1] infiniband/mm: convert put_page() to put_user_page*()
Date: Thu, 23 May 2019 15:54:08 -0700
Message-ID: <6a18af65-7071-2531-d767-42ba74ad82c4@nvidia.com>
References: <20190523072537.31940-1-jhubbard@nvidia.com>
 <20190523072537.31940-2-jhubbard@nvidia.com>
 <20190523172852.GA27175@iweiny-DESK2.sc.intel.com>
 <20190523173222.GH12145@mellanox.com>
 <fa6d7d7c-13a3-0586-6384-768ebb7f0561@nvidia.com>
 <20190523190423.GA19578@iweiny-DESK2.sc.intel.com>
 <0bd9859f-8eb0-9148-6209-08ae42665626@nvidia.com>
 <20190523223701.GA15048@iweiny-DESK2.sc.intel.com>
 <050f56d0-1dda-036e-e508-3a7255ac7b59@nvidia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <050f56d0-1dda-036e-e508-3a7255ac7b59@nvidia.com>
Content-Language: en-US-large
Sender: linux-kernel-owner@vger.kernel.org
To: Ira Weiny <ira.weiny@intel.com>
Cc: Jason Gunthorpe <jgg@mellanox.com>, Andrew Morton <akpm@linux-foundation.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, Doug Ledford <dledford@redhat.com>, Mike Marciniszyn <mike.marciniszyn@intel.com>, Dennis Dalessandro <dennis.dalessandro@intel.com>, Christian Benvenuti <benve@cisco.com>, Jan Kara <jack@suse.cz>
List-Id: linux-rdma@vger.kernel.org

On 5/23/19 3:50 PM, John Hubbard wrote:
> [...] 
> I was thinking of it as a temporary measure, only up until, but not including the
> point where put_user_pages() becomes active. That is, the point when put_user_pages
> starts decrementing GUP_PIN_COUNTING_BIAS, instead of just forwarding to put_page().
> 
> (For other readers, that's this patch:
> 
>     "mm/gup: debug tracking of get_user_pages() references"
> 
> ...in https://github.com/johnhubbard/linux/tree/gup_dma_core )
> 

Arggh, correction, I meant this patch:

    "mm/gup: track gup-pinned pages"

...sorry for any confusion there.

thanks,
-- 
John Hubbard
NVIDIA
