From: Dennis Dalessandro <dennis.dalessandro@intel.com>
Subject: Re: [PATCH v3 0/3] get_user_pages*() and RDMA: first steps
Date: Mon, 8 Oct 2018 11:50:50 -0400
Message-ID: <8973680e-4391-48cf-e979-1e9a10be0968@intel.com>
References: <20181006024949.20691-1-jhubbard@nvidia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181006024949.20691-1-jhubbard@nvidia.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: john.hubbard@gmail.com, Matthew Wilcox <willy@infradead.org>, Michal Hocko <mhocko@kernel.org>, Christopher Lameter <cl@linux.com>, Jason Gunthorpe <jgg@ziepe.ca>, Dan Williams <dan.j.williams@intel.com>, Jan Kara <jack@suse.cz>
Cc: linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>, linux-rdma <linux-rdma@vger.kernel.org>, linux-fsdevel@vger.kernel.org, John Hubbard <jhubbard@nvidia.com>, Al Viro <viro@zeniv.linux.org.uk>, Jerome Glisse <jglisse@redhat.com>, Christoph Hellwig <hch@infradead.org>, Ralph Campbell <rcampbell@nvidia.com>
List-Id: linux-rdma@vger.kernel.org

On 10/5/2018 10:49 PM, john.hubbard@gmail.com wrote:
> From: John Hubbard <jhubbard@nvidia.com>
> 
> Changes since v2:
> 
> -- Absorbed more dirty page handling logic into the put_user_page*(), and
>     handled some page releasing loops in infiniband more thoroughly, as per
>     Jason Gunthorpe's feedback.
> 
> -- Fixed a bug in the put_user_pages*() routines' loops (thanks to
>     Ralph Campbell for spotting it).
> 
> Changes since v1:
> 
> -- Renamed release_user_pages*() to put_user_pages*(), from Jan's feedback.
> 
> -- Removed the goldfish.c changes, and instead, only included a single
>     user (infiniband) of the new functions. That is because goldfish.c no
>     longer has a name collision (it has a release_user_pages() routine), and
>     also because infiniband exercises both the put_user_page() and
>     put_user_pages*() paths.
> 
> -- Updated links to discussions and plans, so as to be sure to include
>     bounce buffers, thanks to Jerome's feedback.
> 
> Also:
> 
> -- Dennis, thanks for your earlier review, and I have not yet added your
>     Reviewed-by tag, because this revision changes the things that you had
>     previously reviewed, thus potentially requiring another look.

This spin looks fine to me.

Reviewed-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
