From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: Re: [PATCH RFC] Documentation/infiniband: Add docs for rdma-helpers
Date: Wed, 13 May 2015 09:59:15 -0600
Message-ID: <20150513155915.GB16941@obsidianresearch.com>
References: <1431523472-10888-1-git-send-email-yun.wang@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1431523472-10888-1-git-send-email-yun.wang@profitbricks.com>
Sender: linux-doc-owner@vger.kernel.org
To: Michael Wang <yun.wang@profitbricks.com>
Cc: Roland Dreier <roland@kernel.org>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal@dev.mellanox.co.il>, Doug Ledford <dledford@redhat.com>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, Or Gerlitz <ogerlitz@mellanox.com>, Ira Weiny <ira.weiny@intel.com>
List-Id: linux-rdma@vger.kernel.org

On Wed, May 13, 2015 at 03:24:32PM +0200, Michael Wang wrote:
> This is the following patch for:
>   https://lkml.org/lkml/2015/5/5/417
> which try to document the settled rdma_cap_XX().
> 
> Highlights:
>   There could be many missing/mistakes/misunderstanding, please don't
>   be hesitate to point out the issues, any suggestions to improve or
>   complete the description are very welcomed ;-)

I'd rather see this in the kdoc for each function.

Thanks,
Jason
