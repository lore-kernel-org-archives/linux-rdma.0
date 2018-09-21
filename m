From: Jason Gunthorpe <jgg@mellanox.com>
Subject: Re: [PATCH rdma-next 0/4] mlx5 vport loopback
Date: Fri, 21 Sep 2018 13:40:17 -0600
Message-ID: <20180921194017.GF30219@mellanox.com>
References: <20180917103049.18235-1-leon@kernel.org>
 <4d9969b9424642dc4c50ca698c57c41654f7006a.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4d9969b9424642dc4c50ca698c57c41654f7006a.camel@redhat.com>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: Leon Romanovsky <leon@kernel.org>, Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Mark Bloch <markb@mellanox.com>, Yishai Hadas <yishaih@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Sep 21, 2018 at 03:14:36PM -0400, Doug Ledford wrote:
> On Mon, 2018-09-17 at 13:30 +0300, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro@mellanox.com>
> > 
> > Hi,
> > 
> > This is short series from Mark which extends handling of loopback
> > traffic. Originally mlx5 IB dynamically enabled/disabled both unicast
> > and multicast based on number of users. However RAW ethernet QPs need
> > more granular access.
> > 
> > Thanks
> > 
> > Mark Bloch (4):
> >   net/mlx5: Rename incorrect naming in IFC file
> >   RDMA/mlx5: Refactor transport domain bookkeeping logic
> >   RDMA/mlx5: Allow creating RAW ethernet QP with loopback support
> >   RDMA/mlx5: Enable vport loopback when user context or QP mandate
> 
> I've reviewed this series and I'm OK with it, but the first patch is for
> net/mlx5.  How are you expecting the series to be applied?  Are you
> wanting me or Jason to take the entire series, or does the first patch
> need to go through the mlx5 tree and get picked up by Dave and us, and
> then we take the rest?  This is unclear to me...

Saeed or Leon will apply the net/mlx5 patches when netdev and RDMA
approves the series, such as with the above approval.

Our job is to take the branch from

  git://git.kernel.org/pub/scm/linux/kernel/git/mellanox/linux.git mellanox/mlx5-next

So it is a two step process where it is approved on the mailing list
then Saeed/Leon will respond with the branch commits.

Depending on need I've been doing either a 'series merge' which looks
like this:

commit 8193abb6a8171c775503acd041eb957cc7e9e7f4
Merge: c1dfc0114c901b 25bb36e75d7d62
Author: Jason Gunthorpe <jgg@mellanox.com>
Date:   Wed Jul 4 13:19:46 2018 -0600

    Merge branch 'mlx5-dump-fill-mkey' into rdma.git for-next
    
    For dependencies, branch based on 'mellanox/mlx5-next' of
    git://git.kernel.org/pub/scm/linux/kernel/git/mellanox/linux.git
    
    Pull Dump and fill MKEY from Leon Romanovsky:
    
    ====================
    MLX5 IB HCA offers the memory key, dump_fill_mkey to increase performance,
    when used in a send or receive operations.
    
    It is used to force local HCA operations to skip the PCI bus access, while
    keeping track of the processed length in the ibv_sge handling.
    
    In this three patch series, we expose various bits in our HW spec
    file (mlx5_ifc.h), move unneeded for mlx5_core FW command and export such
    memory key to user space thought our mlx5-abi header file.
    ====================
    
    Botched auto-merge in mlx5_ib_alloc_ucontext() resolved by hand.
    
    * branch 'mlx5-dump-fill-mkey':
      IB/mlx5: Expose dump and fill memory key
      net/mlx5: Add hardware definitions for dump_fill_mkey
      net/mlx5: Limit scope of dump_fill_mkey function
      net/mlx5: Rate limit errors in command interface
    
    Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>

Which preserves the cover letter, so I prefer it.

 This only works if the RDMA patches have no dependency on the latest
RDMA tree.

The Mellanox branch may have additional patches beyond the series in
question, this just means they have progressed on the netdev side, I
usually trim them out of the 'git merge --log' section for greater
clarity.

Otherwise, merge the Mellanox branch with the right commit IDs and
then apply the RDMA patches, such as here:

commit eda98779f7d318cf96f030bbc5b23f034b69b80a
Merge: 4fca037783512c 664000b6bb4352
Author: Jason Gunthorpe <jgg@mellanox.com>
Date:   Tue Jul 24 13:10:23 2018 -0600

    Merge branch 'mellanox/mlx5-next' into rdma.git for-next
    
    From git://git.kernel.org/pub/scm/linux/kernel/git/mellanox/linux.git
    
    This is required to resolve dependencies of the next series of RDMA
    patches.
    
    * branch 'mellanox/mlx5-next':
      net/mlx5: Add support for flow table destination number
      net/mlx5: Add forward compatible support for the FTE match data
      net/mlx5: Fix tristate and description for MLX5 module
      net/mlx5: Better return types for CQE API
      net/mlx5: Use ERR_CAST() instead of coding it
      net/mlx5: Add missing SET_DRIVER_VERSION command translation
      net/mlx5: Add XRQ commands definitions
      net/mlx5: Add core support for double vlan push/pop steering action
      net/mlx5: Expose MPEGC (Management PCIe General Configuration) structures
      net/mlx5: FW tracer, add hardware structures
      net/mlx5: fix uaccess beyond "count" in debugfs read/write handlers
    
    Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>

It is up to Saeed to sync this branch with netdev.

Neither RDMA or netdev should apply patches marked for net/mlx5 - they
must go through the shared branch to avoid conflicts.

Jason
