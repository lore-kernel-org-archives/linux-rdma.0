From: "Michael J. Ruhl" <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2 2/2] ibacm: Incorrect list used for subnet list causes a
 segfault
Date: Mon, 16 Oct 2017 10:24:40 -0400
Message-ID: <20171016142426.12814.13095.stgit@phlsvslse11.ph.intel.com>
References: <20171016142303.12814.97296.stgit@phlsvslse11.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171016142303.12814.97296.stgit-K+u1se/DcYrLESAwzcoQNrvm/XP+8Wra@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Michael J. Ruhl <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Setting the provider keyword in the ibacm_opts.cfg file to something
other than 'default' will cause ibacm to segfault on startup:

ibacm[32739]: segfault at 302e40 ip 000000000040432d
sp 00007ffe4039e1c0 error 4 in ibacm[400000+c000]

To re-produce the segfault, change the provider keyword in
ibacm_opts.cfg from:

provider ibacmp default

to:

provider ibacmp 0xFE80000000000000

When adding subnets to a provider subnet list, the incorrect list is
used.  The list used is the provider_list (list of all providers)
rather than the (specific) provider subnet list.

This corrupts the provider_list, and causes ibacm to crash with the
above segfault.

Use the correct list when adding subnet information to a provider.

Fixes: 26e05f8304a506 ("ibacm: use ccan/list.h")
Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Michael J. Ruhl <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
v1 -> v2
   * Remove reference to library commit.
---
 ibacm/src/acm.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/ibacm/src/acm.c b/ibacm/src/acm.c
index 1ccef94..a67001d 100644
--- a/ibacm/src/acm.c
+++ b/ibacm/src/acm.c
@@ -2587,8 +2587,8 @@ static void acm_load_prov_config(void)
 					return;
 				}
 				subnet->subnet_prefix = htobe64(prefix);
-				list_add_after(&provider_list, &prov->entry,
-						&subnet->entry);
+				list_add_tail(&prov->subnet_list,
+					      &subnet->entry);
 			}
 		}
 	}

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
