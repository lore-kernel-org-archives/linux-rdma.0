From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH rdma-next 06/12] RDMA/uverbs: Don't overwrite NULL
 pointer with ZERO_SIZE_PTR
Date: Sun, 24 Jun 2018 13:57:51 -0600
Message-ID: <20180624195751.GM19151@ziepe.ca>
References: <20180624082353.16138-1-leon@kernel.org>
 <20180624082353.16138-7-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180624082353.16138-7-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>
Cc: Doug Ledford <dledford@redhat.com>, Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Hadar Hen Zion <hadarh@mellanox.com>, Matan Barak <matanb@mellanox.com>, Michael J Ruhl <michael.j.ruhl@intel.com>, Noa Osherovich <noaos@mellanox.com>, Raed Salem <raeds@mellanox.com>, Yishai Hadas <yishaih@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, Jun 24, 2018 at 11:23:47AM +0300, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@mellanox.com>
> 
> Number of specs is provided by user and in valid case can be equal to zero.
> Such argument causes to call to kcalloc() with zero-length request and in
> return the ZERO_SIZE_PTR is assigned. This pointer is different from NULL
> and makes various if (..) checks to success.

The one seems really weird. There is nothing wrong with ZERO_SIZE_PTR,
but this description and fix suggest that something did

ptr = kalloc(0);
ptr[0] = ...;

Which is not allowed of course. Doesn't this mean there is also a
missing range check someplace?

Jason
