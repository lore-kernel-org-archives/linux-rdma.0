From: John Hubbard <jhubbard@nvidia.com>
Subject: Re: [PATCH 1/6] mm: get_user_pages: consolidate error handling
Date: Fri, 12 Oct 2018 15:45:05 -0700
Message-ID: <090e5019-b1b9-fdc5-73a1-902164400fe2@nvidia.com>
References: <20181012060014.10242-1-jhubbard@nvidia.com>
 <20181012060014.10242-2-jhubbard@nvidia.com> <20181012063034.GI8537@350D>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181012063034.GI8537@350D>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Balbir Singh <bsingharora@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>, Michal Hocko <mhocko@kernel.org>, Christopher Lameter <cl@linux.com>, Jason Gunthorpe <jgg@ziepe.ca>, Dan Williams <dan.j.williams@intel.com>, Jan Kara <jack@suse.cz>, linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, linux-rdma <linux-rdma@vger.kernel.org>, linux-fsdevel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On 10/11/18 11:30 PM, Balbir Singh wrote:
> On Thu, Oct 11, 2018 at 11:00:09PM -0700, john.hubbard@gmail.com wrote:
>> From: John Hubbard <jhubbard@nvidia.com>
>>
>> An upcoming patch requires a way to operate on each page that
>> any of the get_user_pages_*() variants returns.
>>
>> In preparation for that, consolidate the error handling for
>> __get_user_pages(). This provides a single location (the "out:" label)
>> for operating on the collected set of pages that are about to be returned.
>>
>> As long every use of the "ret" variable is being edited, rename
>> "ret" --> "err", so that its name matches its true role.
>> This also gets rid of two shadowed variable declarations, as a
>> tiny beneficial a side effect.
>>
>> Reviewed-by: Jan Kara <jack@suse.cz>
>> Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
>> Signed-off-by: John Hubbard <jhubbard@nvidia.com>
>> ---
> 
> Looks good, might not be needed but
> Reviewed-by: Balbir Singh <bsingharora@gmail.com>
> 

Thanks for the review, very good to have another set of eyes on
this one.

-- 
thanks,
John Hubbard
NVIDIA
