From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH rdma] net/mlx5: Fix XRC SRQ umem valid bits
Date: Tue, 6 Nov 2018 15:11:53 -0700
Message-ID: <20181106221153.GG30476@ziepe.ca>
References: <20181031102028.9142-1-leon@kernel.org>
 <cb4d41e3a24c667c5c4e0492d3d3b21a5a165919.camel@redhat.com>
 <20181106220206.GC30490@mellanox.com>
 <581ad7a59e00c7ee01a65940637df25ad826041c.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <581ad7a59e00c7ee01a65940637df25ad826041c.camel@redhat.com>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: Leon Romanovsky <leon@kernel.org>, Yishai Hadas <yishaih@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Artemy Kovalyov <artemyko@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>, Leon Romanovsky <leonro@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

On Tue, Nov 06, 2018 at 05:10:53PM -0500, Doug Ledford wrote:
> On Tue, 2018-11-06 at 22:02 +0000, Jason Gunthorpe wrote:
> > On Tue, Nov 06, 2018 at 04:31:08PM -0500, Doug Ledford wrote:
> > > On Wed, 2018-10-31 at 12:20 +0200, Leon Romanovsky wrote:
> > > > From: Yishai Hadas <yishaih@mellanox.com>
> > > > 
> > > > Adapt XRC SRQ to the latest HW specification with fixed definition
> > > > around umem valid bits. The previous definition relied on a bit which
> > > > was taken for other purposes in legacy FW.
> > > > 
> > > > Fixes: bd37197554eb ("net/mlx5: Update mlx5_ifc with DEVX UID bits")
> > > > Signed-off-by: Yishai Hadas <yishaih@mellanox.com>
> > > > Reviewed-by: Artemy Kovalyov <artemyko@mellanox.com>
> > > > Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
> > > > Hi Doug, Jason
> > > > 
> > > > This commit fixes code sent in this merge window, so I'm not marking it
> > > > with any rdma-rc/rdma-next. It will be better to be sent during this merge
> > > > window if you have extra pull request to issue, or as a -rc material, if
> > > > not.
> > > > 
> > > > BTW, we didn't combine reserved fields, because our convention is to align such
> > > > fields to 32 bits for better readability.
> > > > 
> > > > Thanks
> > > 
> > > This looks fine.  Let me know when it's in the mlx5-next tree to pull.
> > 
> > It needs to go to -rc... 
> > 
> > This needs a mlx5-rc branch for this I guess?
> 
> I don't think so.  As long as it's the first commit in mlx5-next, and
> mlx5-next is 4.20-rc1 based, then pulling this commit into the -rc tree
> will only pull the single commit.  Then when we pull into for-next for
> the first time, we will get this in for-next too.  That seems best to
> me.

That works too, if Leon is fast :)

Jason
