From: Christoph Hellwig <hch@infradead.org>
Subject: Re: srp state in current mainline
Date: Sun, 22 Nov 2015 06:32:15 -0800
Message-ID: <20151122143215.GA14667@infradead.org>
References: <20151110171509.GA27781@infradead.org>
 <20151122135343.GA11703@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20151122135343.GA11703@infradead.org>
Sender: target-devel-owner@vger.kernel.org
To: Sagi Grimberg <sagig@dev.mellanox.co.il>, Bart Van Assche <bart.vanassche@sandisk.com>
Cc: linux-rdma@vger.kernel.org, target-devel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Sun, Nov 22, 2015 at 05:53:43AM -0800, Christoph Hellwig wrote:
> To me this sounds like another argument to just allocate one FR
> per request and don't allow non-contiguous SGLs.
> 
> Also note that 4.4-rc  prefer_fr=y register_always=n
> !register_always still blows up badly with XFS and ext4 due to
> data integrity errors.

A little instrumention revealed that the corrupted buffers are
correlated to the 'gap' case in ib_sg_to_pages.  I haven't found
anything obvious yet, but ading this line to srp_slave_configure:

	blk_queue_virt_boundary(q, target->srp_host->srp_dev->mr_page_size - 1);

and thus avoiding the gap cases makes xfstests pass fine for me, with or
without the register_always parameter.
