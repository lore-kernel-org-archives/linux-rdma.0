From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH v1 libmlx4 0/7] Completion timestamping
Date: Tue, 27 Oct 2015 19:08:50 +0200
Message-ID: <1445965737-14187-1-git-send-email-matanb@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Yishai,

This series adds support for completion timestamp. In order to
support this feature, several extended verbs were implemented
(as instructed in libibverbs).

ibv_query_device_ex was extended to support reading the
hca_core_clock and timestamp mask. The same verb was extended
with vendor dependant data which is used in order to map the
HCA's free running clock register.
When libmlx4 initializes, it tried to mmap this free running
clock register. This mapping is used in order to implement
ibv_query_values_ex efficiently.

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

Thanks,
Matan

Changes from v0:
* Changed patch-set to correct prefix.

Matan Barak (7):
  Add support for extended version of ibv_query_device
  Add support for ibv_create_cq_ex
  Implement ibv_poll_cq_ex extension verb
  Add timestmap support to extended poll_cq verb
  Add support for ibv_query_values_ex
  Add support for different poll_one_ex functions
  Optimize ibv_poll_cq_ex for common scenarios

 configure.ac   |  17 ++
 src/cq.c       | 512 +++++++++++++++++++++++++++++++++++++++++++++++++++++----
 src/mlx4-abi.h |  25 +++
 src/mlx4.c     |  39 +++++
 src/mlx4.h     |  64 +++++++-
 src/verbs.c    | 219 +++++++++++++++++++++---
 6 files changed, 823 insertions(+), 53 deletions(-)

-- 
2.1.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
