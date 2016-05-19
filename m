From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH libibverbs 0/3] Scatter FCS support
Date: Thu, 19 May 2016 15:52:46 +0300
Message-ID: <1463662369-18395-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Doug,

This series from Majd adds 'Scatter FCS support' for libibverbs.
You already accepted the kernel part for coming kernel 4.7.

The series was tested successfully with mlx5 driver (lib, kernel)
and can be accessed also from my openfabrics GIT at:
git://openfabrics.org/~yishaih/libibverbs.git
branch: fcs

It exists also on top of V2 timestamp series
that we just sent, for that the 'for-upstream' branch should
be used.

Thanks,
Yishai

Frame Check Sequence(FCS) is an error detecting code that terminates an
Ethernet frame. When using Raw Ethernet, users sometimes want to
validate the FCS themselves, and therefore it should be scattered to the
receive buffers.

This series adds the above support.

The user can control scattering the FCS using Queue-Pair(QP) creation flag
called IBV_QP_CREATE_SCATTER_FCS.

Also, to report this new device capability, we had to add a new device
capability flags in the uverbs response called device_cap_flags_ex, since all
the current device_cap_flags are occupied.

device_cap_flags_ex 0-31 bits are identical to the legacy device_cap_flags, and
the upper 32 bits (32-63 bits) report new extended device capabilities.

Devices that support scattering the FCS should report it in device_cap_flags_ex
using IBV_DEVICE_RAW_SCATTER_FCS.


Majd Dibbiny (3):
  Extend devinfo verbosity mode
  Add extended device capability flags
  Add SCATTER_FCS QP create flag

 examples/devinfo.c            | 96 +++++++++++++++++++++++++++++++++++++++++++
 include/infiniband/kern-abi.h |  2 +
 include/infiniband/verbs.h    |  8 ++++
 man/ibv_query_device_ex.3     |  1 +
 src/cmd.c                     | 13 +++++-
 5 files changed, 119 insertions(+), 1 deletion(-)

-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
