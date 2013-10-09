From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 00/10] IB/core: more fixes for create_flow uverbs (for v3.12)
Date: Wed,  9 Oct 2013 23:12:42 +0200
Message-ID: <cover.1381351016.git.ydroneaud@opteya.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, Hadar Hen Zion <hadarh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi,

I've suggested reverting temporarily commit 22878db, 436f2ad, 400dbc9
for v3.12 in a previous message [1]. This proposition doesn't sound
acceptable for Or.

So I continue to improve them to be in a better shape for v3.12.

Please find some important changes against create_flow uverbs
implementation.

The most notable changes that should go to v3.12:
- structure renaming to match others uverbs public structs;
- changes usage of the flow_attr.size to not count the
  "extended command header" but to describe only the size
  of the flow specs following flow_attr;
- removed unneeded flow_spec structure that don't need to be
  exposed to userspace.
- ensure 64bits alignement (regarding patchset [2])

Others changes are mostly improving the uverbs function to protect
from malformed flow_spec. Those could be added later (v3.13)
but I haven't ordered the patches this way: all of this is a bit
developped in a hurry to catch v3.12.

Please review and tell me which patchset should go first
to rebase one on the other: this one, or the "improved infrastructure"
patchset[2].

Links:

[1]: http://marc.info/?i=0d695256ac989e7b1bcccd3a2bfafcbf-zgzEX58YAwA@public.gmane.org
     http://mid.gmane.org/0d695256ac989e7b1bcccd3a2bfafcbf-zgzEX58YAwA@public.gmane.org

[2]: http://marc.info/?i=cover.1381177342.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org
     http://mid.gmane.org/cover.1381177342.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org

Regards.

Yann Droneaud (10):
  IB/core: Rename 'flow' structs to match other uverbs structs
  IB/core: Makes uverbs flow structure using names more similar to verbs
    ones
  IB/core: Don't include command size in uverbs create_flow
  IB/core: Allocate memory only for flow_spec in create_flow uverbs
  IB/core: Remove checks for negative values in create_flow uverbs
  IB/core: Check against uverbs structure size while parsing flow_spec
  IB/core: Uses a common header for uverbs flow_specs
  IB/core: Use flow_spec common header in uverbs flow_spec conversion
    function
  IB/core: Remove ib_uverbs_flow_spec structure from userspace
  IB/core: Add proper bound checking in flow_spec uverbs conversion to
    verbs

 drivers/infiniband/core/uverbs.h     |  16 +++++
 drivers/infiniband/core/uverbs_cmd.c | 136 +++++++++++++++++++++--------------
 include/uapi/rdma/ib_user_verbs.h    |  69 ++++++++++--------
 3 files changed, 139 insertions(+), 82 deletions(-)

-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
