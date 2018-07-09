From: John Hubbard <jhubbard@nvidia.com>
Subject: Re: [PATCH 1/2] mm: introduce put_user_page(), placeholder version
Date: Mon, 9 Jul 2018 11:48:44 -0700
Message-ID: <cf746031-b8c7-95de-79cf-b8e5381367c6@nvidia.com>
References: <20180709080554.21931-2-jhubbard@nvidia.com>
 <201807091833.xMr1iYDX%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <201807091833.xMr1iYDX%fengguang.wu@intel.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: kbuild test robot <lkp@intel.com>, john.hubbard@gmail.com
Cc: kbuild-all@01.org, Matthew Wilcox <willy@infradead.org>, Michal Hocko <mhocko@kernel.org>, Christopher Lameter <cl@linux.com>, Jason Gunthorpe <jgg@ziepe.ca>, Dan Williams <dan.j.williams@intel.com>, Jan Kara <jack@suse.cz>, Al Viro <viro@zeniv.linux.org.uk>, linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>, linux-rdma <linux-rdma@vger.kernel.org>, linux-fsdevel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On 07/09/2018 03:08 AM, kbuild test robot wrote:
> Hi John,
> 
> Thank you for the patch! Yet something to improve:
> 
> [auto build test ERROR on linus/master]
...
> 
>>> drivers/platform//goldfish/goldfish_pipe.c:334:13: error: conflicting types for 'release_user_pages'
>     static void release_user_pages(struct page **pages, int pages_count,
>                 ^~~~~~~~~~~~~~~~~~

Yes. Patches #1 and #2 need to be combined here. I'll do that in the next version, which will probably include several of the easier put_user_page() conversions, as well.

thanks,
-- 
John Hubbard
NVIDIA
