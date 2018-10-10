From: John Hubbard <jhubbard@nvidia.com>
Subject: Re: [PATCH v5 2/3] mm: introduce put_user_page*(), placeholder
 versions
Date: Wed, 10 Oct 2018 11:35:51 -0700
Message-ID: <75681b69-2db6-bc46-efe3-48d029c9ec22@nvidia.com>
References: <20181010041134.14096-1-jhubbard@nvidia.com>
 <20181010041134.14096-3-jhubbard@nvidia.com>
 <20181010080326.GB11507@quack2.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181010080326.GB11507@quack2.suse.cz>
Content-Language: en-US-large
Sender: linux-kernel-owner@vger.kernel.org
To: Jan Kara <jack@suse.cz>, john.hubbard@gmail.com
Cc: Matthew Wilcox <willy@infradead.org>, Michal Hocko <mhocko@kernel.org>, Christopher Lameter <cl@linux.com>, Jason Gunthorpe <jgg@ziepe.ca>, Dan Williams <dan.j.williams@intel.com>, linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>, linux-rdma <linux-rdma@vger.kernel.org>, linux-fsdevel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>, Jerome Glisse <jglisse@redhat.com>, Christoph Hellwig <hch@infradead.org>, Ralph Campbell <rcampbell@nvidia.com>
List-Id: linux-rdma@vger.kernel.org

On 10/10/18 1:03 AM, Jan Kara wrote:
> On Tue 09-10-18 21:11:33, john.hubbard@gmail.com wrote:
>> +/*
>> + * put_user_pages() - for each page in the @pages array, release the page
>> + * using put_user_page().
>> + *
>> + * Please see the put_user_page() documentation for details.
>> + *
>> + * This is just like put_user_pages_dirty(), except that it invokes
>> + * set_page_dirty_lock(), instead of set_page_dirty().
> 
> This paragraph should be deleted. Other than that the patch looks good.
> 

Good catch. Fixed locally, and it will go up with the next spin.

thanks,
-- 
John Hubbard
NVIDIA
