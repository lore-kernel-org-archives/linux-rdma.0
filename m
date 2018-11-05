From: John Hubbard <jhubbard@nvidia.com>
Subject: Re: [PATCH v4 2/3] mm: introduce put_user_page*(), placeholder
 versions
Date: Sun, 4 Nov 2018 23:25:31 -0800
Message-ID: <4f47f3d4-1b00-e534-309c-7fb044337040@nvidia.com>
References: <20181008211623.30796-1-jhubbard@nvidia.com>
 <20181008211623.30796-3-jhubbard@nvidia.com>
 <20181008171442.d3b3a1ea07d56c26d813a11e@linux-foundation.org>
 <5198a797-fa34-c859-ff9d-568834a85a83@nvidia.com>
 <20181010164541.ec4bf53f5a9e4ba6e5b52a21@linux-foundation.org>
 <20181011084929.GB8418@quack2.suse.cz> <20181011132013.GA5968@ziepe.ca>
 <97e89e08-5b94-240a-56e9-ece2b91f6dbc@nvidia.com>
 <b9899626-9033-348b-6f07-dc90bcd8a468@nvidia.com>
 <20181018101951.GO23493@quack2.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181018101951.GO23493@quack2.suse.cz>
Content-Language: en-US-large
Sender: linux-kernel-owner@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Andrew Morton <akpm@linux-foundation.org>, john.hubbard@gmail.com, Matthew Wilcox <willy@infradead.org>, Michal Hocko <mhocko@kernel.org>, Christopher Lameter <cl@linux.com>, Dan Williams <dan.j.williams@intel.com>, linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>, linux-rdma <linux-rdma@vger.kernel.org>, linux-fsdevel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>, Jerome Glisse <jglisse@redhat.com>, Christoph Hellwig <hch@infradead.org>, Ralph Campbell <rcampbell@nvidia.com>
List-Id: linux-rdma@vger.kernel.org

On 10/18/18 3:19 AM, Jan Kara wrote:
> On Thu 11-10-18 20:53:34, John Hubbard wrote:
>> On 10/11/18 6:23 PM, John Hubbard wrote:
>>> On 10/11/18 6:20 AM, Jason Gunthorpe wrote:
>>>> On Thu, Oct 11, 2018 at 10:49:29AM +0200, Jan Kara wrote:
[...]
> Well, put_page() cannot assert page is not dma-pinned as someone can still
> to get_page(), put_page() on dma-pinned page and that must not barf. But
> put_page() could assert that if the page is pinned, refcount is >=
> pincount. That will detect leaked pin references relatively quickly.
> 

That assertion is definitely a life saver. I've been attempting a combination
of finishing up more call site conversions, and runtime testing, and this
lights up the missing conversions pretty nicely.

As I mentioned in another thread just now, I'll send out an updated RFC this week,
so that people can look through it well before the LPC (next week).

thanks,
-- 
John Hubbard
NVIDIA
