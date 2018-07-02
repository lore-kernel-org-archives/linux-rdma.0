From: John Hubbard <jhubbard@nvidia.com>
Subject: Re: [PATCH v2 0/6] mm/fs: gup: don't unmap or drop filesystem buffers
Date: Sun, 1 Jul 2018 22:54:55 -0700
Message-ID: <011e8d10-1851-a4e2-991c-1f428317a963@nvidia.com>
References: <20180702005654.20369-1-jhubbard@nvidia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180702005654.20369-1-jhubbard@nvidia.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: john.hubbard@gmail.com, Matthew Wilcox <willy@infradead.org>, Michal Hocko <mhocko@kernel.org>, Christopher Lameter <cl@linux.com>, Jason Gunthorpe <jgg@ziepe.ca>, Dan Williams <dan.j.williams@intel.com>, Jan Kara <jack@suse.cz>
Cc: linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>, linux-rdma <linux-rdma@vger.kernel.org>, linux-fsdevel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On 07/01/2018 05:56 PM, john.hubbard@gmail.com wrote:
> From: John Hubbard <jhubbard@nvidia.com>
> 

There were some typos in patches #4 and #5, which I've fixed locally.
Let me know if anyone would like me to repost with those right away, otherwise
I'll wait for other review besides the kbuild test robot.

Meanwhile, for convenience, you can pull down the latest version of the
patchset from:

    git@github.com:johnhubbard/linux (branch: gup_dma_next)


thanks,
-- 
John Hubbard
NVIDIA
