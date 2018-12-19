From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH V2] net/mlx4: Get rid of page operation after
 dma_alloc_coherent
Date: Wed, 19 Dec 2018 08:25:30 +0100
Message-ID: <20181219072530.GA27733@lst.de>
References: <20181218190622.13046-1-swarren@wwwdotorg.org> <20181218205649.GA17958@lst.de> <5196b89a-0de5-a53e-95c6-6381b4ed0982@wwwdotorg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5196b89a-0de5-a53e-95c6-6381b4ed0982@wwwdotorg.org>
Sender: netdev-owner@vger.kernel.org
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Christoph Hellwig <hch@lst.de>, Tariq Toukan <tariqt@mellanox.com>, xavier.huwei@huawei.com, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, Stephen Warren <swarren@nvidia.com>
List-Id: linux-rdma@vger.kernel.org

On Tue, Dec 18, 2018 at 05:12:41PM -0700, Stephen Warren wrote:
> On 12/18/18 1:56 PM, Christoph Hellwig wrote:
>> This goes in the right direction, but I think we need to stop
>> abusing the scatterlist for the coherent mapping entirely.  Something
>> like the patch below (based on yours):
>
> Oh, it was simple to get rid of the sg list usage than I thought; I'd 
> assume it would be touched in a bunch of other files.
>
> I had to make the additions shown below to get the adapter to get the 
> driver to probe without errors, but with these changes, ibping, ib_read_bw, 
> and ib_write_bw all work both directions:

I think the new coherent flag should probably use a bool instead of int,
even despite the fact that the old one still uses bool.

It might also be worth checking if we need the per-chunk and per-table
coherent flags, or if the per-chunk one is enough.

Otherwise this looks fine, feel free to resend it under your name as
you did the original patch and all the analysis and testing.
