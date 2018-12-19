From: Stephen Warren <swarren@wwwdotorg.org>
Subject: Re: [PATCH V2] net/mlx4: Get rid of page operation after
 dma_alloc_coherent
Date: Wed, 19 Dec 2018 10:31:39 -0700
Message-ID: <3ac7e3b4-8f5c-096d-2423-738997da1844@wwwdotorg.org>
References: <20181218190622.13046-1-swarren@wwwdotorg.org>
 <20181218205649.GA17958@lst.de>
 <5196b89a-0de5-a53e-95c6-6381b4ed0982@wwwdotorg.org>
 <20181219072530.GA27733@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181219072530.GA27733@lst.de>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Tariq Toukan <tariqt@mellanox.com>, xavier.huwei@huawei.com, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, Stephen Warren <swarren@nvidia.com>
List-Id: linux-rdma@vger.kernel.org

On 12/19/18 12:25 AM, Christoph Hellwig wrote:
> On Tue, Dec 18, 2018 at 05:12:41PM -0700, Stephen Warren wrote:
>> On 12/18/18 1:56 PM, Christoph Hellwig wrote:
>>> This goes in the right direction, but I think we need to stop
>>> abusing the scatterlist for the coherent mapping entirely.  Something
>>> like the patch below (based on yours):
>>
>> Oh, it was simple to get rid of the sg list usage than I thought; I'd
>> assume it would be touched in a bunch of other files.
>>
>> I had to make the additions shown below to get the adapter to get the
>> driver to probe without errors, but with these changes, ibping, ib_read_bw,
>> and ib_write_bw all work both directions:
> 
> I think the new coherent flag should probably use a bool instead of int,
> even despite the fact that the old one still uses bool.
> 
> It might also be worth checking if we need the per-chunk and per-table
> coherent flags, or if the per-chunk one is enough.

So we need to store the value in the table, because the table is created 
first without any chunks, so we can't store the coherent flag in any 
chunk, and the coherent flag is a property of the table at that time.

We also need to store it per chunk because part of the code acts on 
chunks without knowledge of which table they're part of, so can't access 
the per-table coherent flag.

Instead of duplicating the coherent flag into each chunk, I could 
instead add a pointer from the chunk to the table, so the code could 
read chunk->table->coherent. That would avoid duplication at least, even 
if it does add more pointer chasing. I'm not sure if one way is better 
than the other?

> Otherwise this looks fine, feel free to resend it under your name as
> you did the original patch and all the analysis and testing.

Thanks.
