From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 0/9] mlx4 changes in virtual GID management
Date: Sun, 29 Mar 2015 16:51:24 +0300
Message-ID: <1427637093-6711-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Under the existing implementation for virtual GIDs, if the SM is not 
reachable or incurs a delayed response, or if the VF is probed into a
VM before their GUID is registered with the SM, there exists a window 
in time in which the VF sees an incorrect GID, i.e., not the GID that 
was intended by the admin. This results in exposing a temporal identity 
to the VF.

Moreover, a subsequent change in the alias GID causes a spec-incompliant
change to the VF identity. Some guest operating systems, such as Windows,
cannot tolerate such changes.

This series solves above problem by exposing the admin desired value instead 
of the value that was approved by the SM. As long as the SM doesn't approve 
the GID, the VF would see its link as down.

In addition, we request GIDs from the SM on demand, i.e., when a VF actually
needs them, and release them when the GIDs are no longer in use. In cloud
environments, this is useful for GID migrations, in which a GID is assigned to
a VF on the destination HCA, while the VF on the source HCA is shut down (but
the GID was not administratively released).

For reasons of compatibility, an explicit admin request to set/change a GUID
entry is done immediately, regardless of whether the VF is active or not. This
allows administrators to change the GUID without the need to unbind/bind the VF.

In addition, the existing implementation doesn't support a persistency
mechanism to retry a GUID request when the SM has rejected it for any reason.
The PF driver shall keep trying to acquire the specified GUID indefinitely by
utilizing an exponential back off scheme, this should be managed per GUID and
be aligned with other incoming admin requests.

This ability needed especially for the on-demand GUID feature. In this case, we
must manage the GUID's status per entry and handle cases that some entries are
temporarily rejected.

The first patch adds the persistency support and is pre-requisites for the
series.  Further patches make the change to use the admin VF behavior as
described above.

Finally, the default mode is changed to be HOST assigned instead of SM
assigned. This is the expected operational mode, because it doesn't depend on
SM availability as described above.

Yishai and Or.

Yishai Hadas (9):
  IB/mlx4: Alias GUID adding persistency support
  net/mlx4_core: Manage alias GUID per VF
  net/mlx4_core: Set initial admin GUIDs for VFs
  IB/mlx4: Manage admin alias GUID upon admin request
  IB/mlx4: Change init flow to request alias GUIDs for active VFs
  IB/mlx4: Request alias GUID on demand
  net/mlx4_core: Raise slave shutdown event upon FLR
  net/mlx4_core: Return the admin alias GUID upon host view request
  IB/mlx4: Change alias guids default to be host assigned

 drivers/infiniband/hw/mlx4/alias_GUID.c   |  468 +++++++++++++++++++++--------
 drivers/infiniband/hw/mlx4/main.c         |   26 ++-
 drivers/infiniband/hw/mlx4/mlx4_ib.h      |   14 +-
 drivers/infiniband/hw/mlx4/sysfs.c        |   44 +--
 drivers/net/ethernet/mellanox/mlx4/cmd.c  |   42 ++-
 drivers/net/ethernet/mellanox/mlx4/eq.c   |    2 +
 drivers/net/ethernet/mellanox/mlx4/main.c |   39 +++
 drivers/net/ethernet/mellanox/mlx4/mlx4.h |    1 +
 include/linux/mlx4/device.h               |    4 +
 9 files changed, 459 insertions(+), 181 deletions(-)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
