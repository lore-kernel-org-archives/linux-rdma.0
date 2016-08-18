From: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH perftest 00/23] coverity/clang fixups
Date: Thu, 18 Aug 2016 13:31:55 -0400
Message-ID: <1471541538-20270-1-git-send-email-jarod@redhat.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Gil Rockah <gilr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

I previously sent a patch to only send_lat to fix some memory leaks
reported by coverity, but there were a few issues in it, and then I
found that I'd overlooked similar coverity warnings for almost every
other tool as well. Overall, perftest-3.0-3.1 was reporting around
55 defects in coverity. After this patchset, coverity only reports
7 defects, all of which are in the category of just warnings, and
the code is fine as-is. (It warns about using weak crypto, which I
don't think is worth worrying about in test apps, and about possible
scalar taint when reading from /proc/cpuinfo, which isn't a random
input file so little risk there, and something about a result always
being 0 using the INSERTF macro for certain values, which is fine).

I've quickly regression-tested my local perftest tree after all
these changes on a pair of ConnectX-4 (mlx5) hosts in our lab, and
everything works the same as before the patches.

Jarod Wilson (23):
  send_lat: fix assorted memory leaks on error paths
  perftest_resources: print error received for debug convenience
  send_bw: fix assorted memory leaks on error paths
  atomic_bw: fix assorted memory leaks on error paths
  atomic_lat: fix assorted memory leaks on error paths
  raw_ethernet_send_lat: fix assorted memory leaks on error paths
  read_bw: fix assorted memory leaks on error paths
  read_lat: fix assorted memory leaks on error paths
  write_bw: fix assorted memory leaks on error paths
  write_lat: fix assorted memory leaks on error paths
  raw_ethernet_resources: fix possible NULL math
  perftest_communication: fix gid_index2 copy-pasta
  perftest_communication: don't leak addrinfo
  perftest_communication: fix ibv_create_ah failure check
  perftest_communication: fix overflow w/size_of_cur=4
  perftest: check for NULL fgets() returns
  perftest_parameters: remove dead code in printf
  perftest_resources: do 64-bit math setting tarr_size
  perftest_resources: make sure num_of_qps is never 0
  raw_ethernet_send_lat: prevent possible destroy on uninit val
  perftest_communication: check for error calling setsockopt()
  multicast_resources: use strncpy() to prevent overflow possibility
  perftest: replace 0/1 with SUCCESS/FAILURE

 src/atomic_bw.c              |  55 ++++++++------
 src/atomic_lat.c             |  52 +++++++------
 src/multicast_resources.c    |   2 +-
 src/perftest_communication.c | 173 ++++++++++++++++++++++---------------------
 src/perftest_parameters.c    |  53 ++++++-------
 src/perftest_resources.c     | 129 +++++++++++++++++---------------
 src/raw_ethernet_resources.c |  15 ++--
 src/raw_ethernet_send_bw.c   |  26 +++----
 src/raw_ethernet_send_lat.c  |  65 +++++++++-------
 src/read_bw.c                |  76 +++++++++++--------
 src/read_lat.c               |  55 ++++++++------
 src/send_bw.c                | 118 ++++++++++++++++-------------
 src/send_lat.c               |  89 +++++++++++++---------
 src/write_bw.c               |  81 +++++++++++---------
 src/write_lat.c              |  38 ++++++----
 15 files changed, 578 insertions(+), 449 deletions(-)

CC: Gil Rockah <gilr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
