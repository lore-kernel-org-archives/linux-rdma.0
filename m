From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH V3] net/mlx4: Get rid of page operation after
 dma_alloc_coherent
Date: Thu, 20 Dec 2018 18:44:48 +0100
Message-ID: <20181220174448.GA21149@lst.de>
References: <20181219182031.8675-1-swarren@wwwdotorg.org> <20181220174318.GA21404@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181220174318.GA21404@ziepe.ca>
Sender: netdev-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Stephen Warren <swarren@wwwdotorg.org>, Tariq Toukan <tariqt@mellanox.com>, xavier.huwei@huawei.com, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, Doug Ledford <dledford@redhat.com>, Christoph Hellwig <hch@lst.de>, Stephen Warren <swarren@nvidia.com>
List-Id: linux-rdma@vger.kernel.org

On Thu, Dec 20, 2018 at 10:43:18AM -0700, Jason Gunthorpe wrote:
> >   - chunk->coherent is an int not a bool since checkpatch complains about
> >     using bool in structs; see https://lkml.org/lkml/2017/11/21/384.
> 
> :( bool is much more readable and there is no performance concern in
> this struct. I think checkpatch is overzealous here.

Yes.  Nevermind that this for bool vs bitfield.  A int is worse in
every respect in the criteria used in that mail.
