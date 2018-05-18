From: Jason Gunthorpe <jgg@mellanox.com>
Subject: Re: [pull request][for-next 00/15] Mellanox, mlx5 core and netdev
 updates 2018-05-17
Date: Fri, 18 May 2018 11:21:25 -0600
Message-ID: <20180518172125.GA15625@mellanox.com>
References: <20180518012258.26968-1-saeedm@mellanox.com>
 <20180518.130351.456975805564832525.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180518.130351.456975805564832525.davem@davemloft.net>
Sender: netdev-owner@vger.kernel.org
To: David Miller <davem@davemloft.net>
Cc: saeedm@mellanox.com, dledford@redhat.com, leonro@mellanox.com, ogerlitz@mellanox.com, netdev@vger.kernel.org, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Fri, May 18, 2018 at 01:03:51PM -0400, David Miller wrote:
> From: Saeed Mahameed <saeedm@mellanox.com>
> Date: Thu, 17 May 2018 18:22:43 -0700
> 
> > Below you can find two pull requests,
> > 
> > 1. mlx5 core updates to be shared for both netdev and RDMA, (patches 1..9)
> >  which is based on the last mlx5-next pull request
> >  
> > The following changes since commit a8408f4e6db775e245f20edf12b13fd58cc03a1c:
> > 
> >   net/mlx5: fix spelling mistake: "modfiy" -> "modify" (2018-05-04 12:11:51 -0700)
> > 
> > are available in the Git repository at:
> > 
> >   git://git.kernel.org/pub/scm/linux/kernel/git/mellanox/linux.git tags/mlx5-updates-2018-05-17
> > 
> > for you to fetch changes up to 10ff5359f883412728ba816046ee3a696625ca02:
> > 
> >   net/mlx5e: Explicitly set source e-switch in offloaded TC rules (2018-05-17 14:17:35 -0700)
> > 
> > 2. mlx5e netdev updates only for net-next branch (patches 10..15) based on net-next
> > and the above pull request.
> > 
> > The following changes since commit 538e2de104cfb4ef1acb35af42427bff42adbe4d:
> > 
> >   Merge branch 'net-Allow-more-drivers-with-COMPILE_TEST' (2018-05-17 17:11:07 -0400)
> > 
> > are available in the Git repository at:
> > 
> >   git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5e-updates-2018-05-17
> > 
> > for you to fetch changes up to a228060a7c9ab88597eeac131e4578595d5d46ae:
> > 
> >   net/mlx5e: Add HW vport counters to representor ethtool stats (2018-05-17 17:48:54 -0700)
> > 
> > Dave, for your convenience you can either pull 1. and then 2. or pull 2.
> > directly.
> 
> Looks good.
> 
> I pulled 1 then I pulled 2.  That seemed to work well.  Particularly
> it allowed me to capture the two different merge commit messages one
> by one.

Does this double up the merge commit though? I see this in Saeed's
tags/mlx5e-updates-2018-05-17 ?

commit 260ab7042e24ccd4407985c6e775e39d064fab2b
Merge: 538e2de104cfb4 10ff5359f88341
Author: Saeed Mahameed <saeedm@mellanox.com>
Date:   Thu May 17 17:47:09 2018 -0700

    Merge tag 'mlx5-updates-2018-05-17' of git://git.kernel.org/pub/scm/linux/kernel/git/mellanox/linux
    
    mlx5-updates-2018-05-17
    
    mlx5 core dirver updates for both net-next and rdma-next branches.
    
    From Christophe JAILLET, first three patches to use kvfree where needed.
    
    From: Or Gerlitz <ogerlitz@mellanox.com>
    
    Next six patches from Roi and Co adds support for merged
    sriov e-switch which comes to serve cases where both PFs, VFs set
    on them and both uplinks are to be used in single v-switch SW model.
    When merged e-switch is supported, the per-port e-switch is logically
    merged into one e-switch that spans both physical ports and all the VFs.
    
    This model allows to offload TC eswitch rules between VFs belonging
    to different PFs (and hence have different eswitch affinity), it also
    sets the some of the foundations needed for uplink LAG support.
    
    Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>

And this in your tree:

commit 3888ea4e2f1fb2f61e5418adf4b8332107ac0c8f
Merge: 2c47a65b7009eb 10ff5359f88341
Author: David S. Miller <davem@davemloft.net>
Date:   Fri May 18 13:00:08 2018 -0400

    Merge tag 'mlx5-updates-2018-05-17' of git://git.kernel.org/pub/scm/linux/kernel/git/mellanox/linux
    
    Saeed Mahameed says:
    
    ====================
    mlx5-updates-2018-05-17
    
    mlx5 core dirver updates for both net-next and rdma-next branches.
    
    From Christophe JAILLET, first three patche to use kvfree where needed.
    
    From: Or Gerlitz <ogerlitz@mellanox.com>
    
    Next six patches from Roi and Co adds support for merged
    sriov e-switch which comes to serve cases where both PFs, VFs set
    on them and both uplinks are to be used in single v-switch SW model.
    When merged e-switch is supported, the per-port e-switch is logically
    merged into one e-switch that spans both physical ports and all the VFs.
    
    This model allows to offload TC eswitch rules between VFs belonging
    to different PFs (and hence have different eswitch affinity), it also
    sets the some of the foundations needed for uplink LAG support.
    ====================
    
    Signed-off-by: David S. Miller <davem@davemloft.net>

I think the trouble is the Saeed needs to merge the 'core' stuff to
create the non-core patches for netdev (just like we want to do for
rdma)

So maybe netdev should take the #2 pull request and rdma should
take number #1?

This seems to be working OK from RDMA's side, we have much less netdev
stuff in our tree now which seems good!

Thanks,
Jason
