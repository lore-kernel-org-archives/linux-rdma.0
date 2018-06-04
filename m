From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH rdma-next v3 00/14] Verbs flow counters support
Date: Mon, 4 Jun 2018 08:53:54 -0600
Message-ID: <20180604145354.GA12777@ziepe.ca>
References: <20180531134341.18441-1-leon@kernel.org>
 <20180601211149.GA24028@ziepe.ca>
 <20180602050419.GH2843@mtr-leonro.mtl.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180602050419.GH2843@mtr-leonro.mtl.com>
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>
Cc: Doug Ledford <dledford@redhat.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Boris Pismenny <borisp@mellanox.com>, Matan Barak <matanb@mellanox.com>, "Michael J . Ruhl" <michael.j.ruhl@intel.com>, Or Gerlitz <ogerlitz@mellanox.com>, Raed Salem <raeds@mellanox.com>, Yishai Hadas <yishaih@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Sat, Jun 02, 2018 at 08:04:19AM +0300, Leon Romanovsky wrote:
> On Fri, Jun 01, 2018 at 03:11:49PM -0600, Jason Gunthorpe wrote:
> > On Thu, May 31, 2018 at 04:43:27PM +0300, Leon Romanovsky wrote:
> > > From: Leon Romanovsky <leonro@mellanox.com>
> > >
> > > Changelog:
> > > v2->v3:
> > >  * Change function mlx5_fc_query signature to hide the details of
> > >    internal core driver struct mlx5_fc
> > >  * Add commen to data[] field at struct mlx5_ib_flow_counters_data (mlx5-abi.h)
> > >  * Use array of struct mlx5_ib_flow_counters_desc to clarify the output
> > > v1->v2:
> > >  * Removed conversion from struct mlx5_fc* to void*
> > >  * Fixed one place with double space in it
> > >  * Balanced release of hardware handler in case of counters allocation failure
> > >  * Added Tested-by
> > >  * Minimize time spent holding mutex lock
> > >  * Fixed deadlock caused by nested lock in error path
> > >  * Protect from handler pointer derefence in the error paths
> >
> > Okay,
> >
> > Acked-by: Jason Gunthorpe <jgg@mellanox.com>
> >
> > I've revised some of the commit messages, fixed the two bad
> > check-patch warnings, and fixed the patch ordering..
> >
> > https://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git/log/?h=wip/jgg-counters
> >
> > Please send a PR with the mlx-core bits and above commits.
> 
> Hi,
> 
> I applied two mlx5-next commits to the relevant tree:
> https://git.kernel.org/pub/scm/linux/kernel/git/mellanox/linux.git/commit/?h=mlx5-next&id=930821e39d0a5f91ed58fea1692afe04f0fe0e1f
> https://git.kernel.org/pub/scm/linux/kernel/git/mellanox/linux.git/commit/?h=mlx5-next&id=5f9bf63ae80c4d0e5e986b6c1280bf8174978545
> 
> In first commit, I dropped the words "as used to be", per-Saeed's request.
> 
> The proper signed tag for whole the series is: verbs_flow_counters
> git://git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma.git tags/verbs_flow_counters

Okay pulled, thanks

Jason
