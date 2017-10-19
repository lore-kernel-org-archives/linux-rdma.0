From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-next 00/16] Flow counters support
Date: Thu, 19 Oct 2017 17:41:42 +0300
Message-ID: <1508424118-27205-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, raeds-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Doug,

This series from Raed introduces an API to read via the verbs interface hardware
counters for a specific IB Flow object.

The above enables a user space application to read the real time information on
its various Flow Steering objects and take run time decisions accordingly.

The first 8 patches of the series introduce the generic interface for using
counters then there are 2 patches which enable the flow steering counters on
top of the API.

The last 6 patches are the mlx5 driver implementation of the counters verbs.

We may add in the future on top of the API an option to read also QP, WQ and
other objects' counters. 

The series follows an RFC [1] which introduced the motivation, the expected
usage and the API.

More specifically,
A generic interface with the following functionality is presented:
- An option to know per device how many counter sets it exposes by using some
  extension of the ib_query_device_ex() verb. (i.e. max_counter_sets).
- Per counter set there is an API to get its metadata by using a new verb named
   ib_describe_counter_set(), it gets a counter set id in range of 
   [0,max_counter_sets - 1] and return the counter set information.
   Some of the metadata is IB generic (e.g. counter set type, num counters in the set, etc.)
   while other is some specific driver information (e.g. counters names).
- Introduce counter set object named 'ib_counter_set' and its create/destroy
  verbs. Post a successful creation the counter_set object can  be attached to
  an IB object based on its type. (e.g. Flow, QP, etc.) 
- Introduce the ib_query_counter_set() verb, it enables the user to read the
  hardware counters which are associated with the counter set.
- Introduce a new steering specification from type count 
  (i.e. ib_flow_spec_action_count) which gets a previously created counter_id.
  By creating a flow steering object with a counter, its counters can be read
  by the ib_query_counter_set() verb.

A detailed information on each API and its properties appear in the commit logs
and in the relevant H file.

[1] RFC - https://www.spinics.net/lists/linux-rdma/msg47355.html

Yishai

Boris Pismenny (1):
  IB/mlx5: Pass mlx5_flow_act struct instead of multiple arguments

Raed Salem (15):
  IB/core: Expose max_counter_sets capability
  IB/uverbs: Expose max_counter_sets capability
  IB/core: Introduce counter set describe verb
  IB/uverbs: Add describe counter set support
  IB/core: Introduce counter set object and its create/destroy verbs
  IB/uverbs: Add create/destroy counter set support
  IB/core: Introduce counter set query verb
  IB/uverbs: Add query counter set support
  IB/core: Add support for flow counter set
  IB/uverbs: Add support for flow counter set
  net/mlx5: Export flow counter related API
  net/mlx5: Expand mlx5_fc_query_cached to return absolute counters
    values
  IB/mlx5: Add counter set operations
  IB/mlx5: Add flow counter set support
  IB/mlx5: Expose max_counter_sets capability

 drivers/infiniband/core/uverbs.h                   |   5 +
 drivers/infiniband/core/uverbs_cmd.c               | 314 ++++++++++++++++++
 drivers/infiniband/core/uverbs_main.c              |   4 +
 drivers/infiniband/core/uverbs_std_types.c         |  15 +-
 drivers/infiniband/core/verbs.c                    |  91 +++++-
 drivers/infiniband/hw/mlx5/main.c                  | 364 +++++++++++++++++++--
 drivers/infiniband/hw/mlx5/mlx5_ib.h               |  31 ++
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    |   6 +-
 drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c   |   1 +
 drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.h   |   2 -
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.h  |  23 --
 .../net/ethernet/mellanox/mlx5/core/fs_counters.c  |  17 +-
 include/linux/mlx5/fs.h                            |  31 +-
 include/rdma/ib_verbs.h                            |  74 +++++
 include/rdma/uverbs_std_types.h                    |   1 +
 include/uapi/rdma/ib_user_ioctl_verbs.h            |   1 +
 include/uapi/rdma/ib_user_verbs.h                  |  75 ++++-
 include/uapi/rdma/mlx5-abi.h                       |  16 +
 18 files changed, 1016 insertions(+), 55 deletions(-)

-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
