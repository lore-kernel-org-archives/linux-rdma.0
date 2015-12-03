From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH libmlx5 V1 0/6] Completion timestamping
Date: Thu,  3 Dec 2015 18:02:45 +0200
Message-ID: <1449158571-26228-1-git-send-email-matanb@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Eli,

This series adds support for completion timestamp. In order to
support this feature, several extended verbs were implemented
(as instructed in libibverbs).

ibv_query_device_ex was extended to support reading the
hca_core_clock and timestamp mask.

The init_context verb vendor specific data was changed so
it'll conform to the verbs extensions form. This is done in
order to easily extend the response data for passing the page
offset of the free running clock register. This is mandatory
for mapping this register to the user space. This mapping
is done when libmlx5 initializes.

In order to support CQ completion timestmap reporting, we implement
ibv_create_cq_ex verb. This verb is used both for creating a CQ
which supports timestamp and in order to state which fields should
be returned via WC. Returning this data is done via implementing
ibv_poll_cq_ex. We query the CQ requested wc_flags for every field
the user has requested and populate it according to the carried
network operation and WC status.

Last but not least, ibv_poll_cq_ex was optimized in order to eliminate
the if statements and or operations for common combinations of wc
fields. This is done by inlining and using a custom poll_one_ex
function for these fields.

This series depends on '[PATCH libibverbs 0/5] Completion timestamping'
and is rebased above '[PATCH libmlx5 v1 0/5] Support CQE

Thanks,
Matan

Changes from V0:
 * Use mlx5_init_context in order to pass hca_core_clock_offset.

Matan Barak (6):
  Add ibv_poll_cq_ex support
  Add timestmap support for ibv_poll_cq_ex
  Add ibv_create_cq_ex support
  Add ibv_query_values support
  Optimize poll_cq
  Add always_inline check

 configure.ac   |  17 +
 src/cq.c       | 959 ++++++++++++++++++++++++++++++++++++++++++++++++---------
 src/mlx5-abi.h |  10 +-
 src/mlx5.c     |  43 +++
 src/mlx5.h     |  42 ++-
 src/verbs.c    | 115 ++++++-
 6 files changed, 1037 insertions(+), 149 deletions(-)

-- 
2.1.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
