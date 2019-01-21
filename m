From: Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH v5] coding-style: Clarify the expectations around bool
Date: Sun, 20 Jan 2019 19:08:00 -0700
Message-ID: <20190120190800.64814cd4@lwn.net>
References: <20190118225047.GH4759@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190118225047.GH4759@ziepe.ca>
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Joe Perches <joe@perches.com>, Gal Pressman <galpress@amazon.com>, Bart Van Assche <bvanassche@acm.org>, Stephen Warren <swarren@wwwdotorg.org>, Tariq Toukan <tariqt@mellanox.com>, xavier.huwei@huawei.com, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, Doug Ledford <dledford@redhat.com>, Stephen Warren <swarren@nvidia.com>, Christoph Hellwig <hch@lst.de>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Fri, 18 Jan 2019 15:50:47 -0700
Jason Gunthorpe <jgg@ziepe.ca> wrote:

> There has been some confusion since checkpatch started warning about bool
> use in structures, and people have been avoiding using it.
> 
> Many people feel there is still a legitimate place for bool in structures,
> so provide some guidance on bool usage derived from the entire thread that
> spawned the checkpatch warning.
> 
> Link: https://lkml.kernel.org/r/CA+55aFwVZk1OfB9T2v014PTAKFhtVan_Zj2dOjnCy3x6E4UJfA@mail.gmail.com
> Signed-off-by: Joe Perches <joe@perches.com>
> Acked-by: Joe Perches <joe@perches.com>
> Reviewed-by: Bart Van Assche <bvanassche@acm.org>
> Acked-by: Jani Nikula <jani.nikula@intel.com>
> Reviewed-by: Joey Pabalinas <joeypabalinas@gmail.com>
> Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>

So this seems ready; I've applied it.  

Thanks,

jon
