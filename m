From: Christoph Hellwig <hch@infradead.org>
Subject: Re: srp state in current mainline
Date: Sun, 22 Nov 2015 05:53:43 -0800
Message-ID: <20151122135343.GA11703@infradead.org>
References: <20151110171509.GA27781@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20151110171509.GA27781@infradead.org>
Sender: target-devel-owner@vger.kernel.org
To: Sagi Grimberg <sagig@dev.mellanox.co.il>, Bart Van Assche <bart.vanassche@sandisk.com>
Cc: linux-rdma@vger.kernel.org, target-devel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

So I had some time to go back and look at the 4.3 failures.  They
fail when srp_fr_pool_get called from srp_map_idb through
srp_map_finish_fr fails with -ENOMEM, and go away with
register_always=N.  Looks like the additional FR for the indirect
buffer isn't accounted anywhere.

To me this sounds like another argument to just allocate one FR
per request and don't allow non-contiguous SGLs.

Also note that 4.4-rc  prefer_fr=y register_always=n
!register_always still blows up badly with XFS and ext4 due to
data integrity errors.
