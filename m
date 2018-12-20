From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH V3] net/mlx4: Get rid of page operation after
 dma_alloc_coherent
Date: Thu, 20 Dec 2018 09:49:05 -0800
Message-ID: <1545328145.185366.500.camel@acm.org>
References: <20181219182031.8675-1-swarren@wwwdotorg.org>
         <20181220174318.GA21404@ziepe.ca> <20181220174448.GA21149@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-7"
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181220174448.GA21149@lst.de>
Sender: netdev-owner@vger.kernel.org
To: Joe Perches <joe@perches.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>, Tariq Toukan <tariqt@mellanox.com>, xavier.huwei@huawei.com, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, Doug Ledford <dledford@redhat.com>, Stephen Warren <swarren@nvidia.com>, Christoph Hellwig <hch@lst.de>, Jason Gunthorpe <jgg@ziepe.ca>
List-Id: linux-rdma@vger.kernel.org

On Thu, 2018-12-20 at 18:44 +-0100, Christoph Hellwig wrote:
+AD4 On Thu, Dec 20, 2018 at 10:43:18AM -0700, Jason Gunthorpe wrote:
+AD4 +AD4 +AD4   - chunk-+AD4-coherent is an int not a bool since checkpatch complains about
+AD4 +AD4 +AD4     using bool in structs+ADs see https://lkml.org/lkml/2017/11/21/384.
+AD4 +AD4 
+AD4 +AD4 :( bool is much more readable and there is no performance concern in
+AD4 +AD4 this struct. I think checkpatch is overzealous here.
+AD4 
+AD4 Yes.  Nevermind that this for bool vs bitfield.  A int is worse in
+AD4 every respect in the criteria used in that mail.

(+-Joe Perches)

Hi Joe,

This is the second time that I see that the checkpatch complaint about using
bool in a structure leads kernel contributors to a bad decision. Please consider
removing that warning from checkpatch.

Thanks,

Bart.
