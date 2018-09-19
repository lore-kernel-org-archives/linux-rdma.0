From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH rdma-next 00/24] Extend DEVX functionality
Date: Wed, 19 Sep 2018 12:17:01 -0600
Message-ID: <20180919181701.GP11367@ziepe.ca>
References: <20180917110418.18937-1-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180917110418.18937-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>
Cc: Doug Ledford <dledford@redhat.com>, Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Yishai Hadas <yishaih@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Sep 17, 2018 at 02:03:53PM +0300, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@mellanox.com>
> 
> From Yishai,
> 
> This series comes to enable the DEVX functionality in some wider scope,
> specifically,
> - It enables using kernel objects that were created by the verbs
>   API in the DEVX flow.
> - It enables white list commands without DEVX user context.
> - It enables the IB link layer under CAP_NET_RAW capabilities.
> - It exposes the PRM handles for RAW QP (i.e. TIRN, TISN, RQN, SQN)
>   to be used later on directly by the DEVX interface.
> 
> In General,
> Each object that is created/destroyed/modified via verbs will be stamped
> with a UID based on its user context. This is already done for DEVX objects
> commands.
> 
> This will enable the firmware to enforce the usage of kernel objects
> from the DEVX flow by validating that the same UID is used and the resources are
> really related to the same user.
> 
> For example in case a CQ was created with verbs it will be stamped with
> UID and once will be pointed by a DEVX create QP command the firmware will
> validate that the input CQN really belongs to the UID which issues the create QP
> command.
> 
> As of the above, all the PRM objects (except of the public ones which
> are managed by the kernel e.g. FLOW, etc.) will have a UID upon their
> create/modify/destroy commands. The detection of UMEM / physical
> addressed in the relevant commands will be done by firmware according to a 'umem
> valid bit' as the UID may be used in both cases.
> 
> The series also enables white list commands which don't require a
> specific DEVX context, instead of this a device UID is used so that
> the firmware will mask un-privileged functionality. The IB link layer
> is also enabled once CAP_NET_RAW permission exists.
> 
> To enable using the RAW QP underlay objects (e.g. TIRN, RQN, etc.) later
> on by DEVX commands the UHW output for this case was extended to return this
> data when a DEVX context is used.
> 
> Thanks
>
> Leon Romanovsky (1):
>   net/mlx5: Update mlx5_ifc with DEVX UID bits
> 
> Yishai Hadas (24):
>   net/mlx5: Set uid as part of CQ commands
>   net/mlx5: Set uid as part of QP commands
>   net/mlx5: Set uid as part of RQ commands
>   net/mlx5: Set uid as part of SQ commands
>   net/mlx5: Set uid as part of SRQ commands
>   net/mlx5: Set uid as part of DCT commands
>   IB/mlx5: Set uid as part of CQ creation
>   IB/mlx5: Set uid as part of QP creation
>   IB/mlx5: Set uid as part of RQ commands
>   IB/mlx5: Set uid as part of SQ commands
>   IB/mlx5: Set uid as part of TIR commands
>   IB/mlx5: Set uid as part of TIS commands
>   IB/mlx5: Set uid as part of RQT commands
>   IB/mlx5: Set uid as part of PD commands
>   IB/mlx5: Set uid as part of TD commands
>   IB/mlx5: Set uid as part of SRQ commands
>   IB/mlx5: Set uid as part of DCT commands
>   IB/mlx5: Set uid as part of XRCD commands
>   IB/mlx5: Set uid as part of MCG commands

This is really too many patches.. They are small and not too hard to
review, but it is well beyond the guideline.

And I'm not totally happy with the extensive use of ucontext in the IB
portions, it is problematic looking into the future, and uboject is
really not supposed to be used in the drivers.

The driver needs to store the uid in the PD (copied from the ucontext
that created it) and use that in all the dependent places, not use
pd->uobject->ucontext->devx_uid or some other convoluted way to get
to it. 

The ucontext variable should only be used when creating the PD, CQ and
devx objects.

This detail becomes quite important, for instance, if we get to the
'shared pd' that has been talked about at conference. In this case
when the 'receiver' of the 'shared pd' creates a child object, like a
MR, the MR must be stamped with the devx_uid of the PD (ie the
originating context's devx_uid), not the dev_uid of its local ufile!

If we do that, then the series can be split, so long as pd->devx_uid ==
0 until the entire series is applied. uid tagging is an all-or-nothing
thing, as partial tagging will break verbs. So breaking it up also
makes it more bi-section safe.

Something like these patches:

>   net/mlx5: Update mlx5_ifc with DEVX UID bits
>   net/mlx5: Set uid as part of CQ commands
>   net/mlx5: Set uid as part of QP commands
>   net/mlx5: Set uid as part of RQ commands
>   net/mlx5: Set uid as part of SQ commands
>   net/mlx5: Set uid as part of SRQ commands
>   net/mlx5: Set uid as part of DCT commands
>   IB/mlx5: Set uid as part of PD commands
>   IB/mlx5: Set uid as part of QP creation
>   IB/mlx5: Set uid as part of RQ commands
>   IB/mlx5: Set uid as part of SQ commands
>   IB/mlx5: Set uid as part of SRQ commands
>   IB/mlx5: Set uid as part of DCT commands

(13 patches)

Followed by the rest of the IB uid patches

Followed by a patch to make pd->uid != 0 along with these:

>   IB/mlx5: Set uid as part of CQ creation
>   IB/mlx5: Set valid umem bit on DEVX
>   IB/mlx5: Expose RAW QP device handles to user space
>   IB/mlx5: Manage device uid for DEVX white list commands
>   IB/mlx5: Enable DEVX white list commands
>   IB/mlx5: Enable DEVX on IB

Jason
