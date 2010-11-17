From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 2/3] ibacm: fix issuing SA query after recording address
Date: Tue, 16 Nov 2010 16:12:56 -0800
Message-ID: <CF9C39F99A89134C9CF9C4CCB68B8DDF25B86168C5@orsmsx501.amr.corp.intel.com>
References: <CF9C39F99A89134C9CF9C4CCB68B8DDF25B86168B9@orsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CF9C39F99A89134C9CF9C4CCB68B8DDF25B86168B9-osO9UTpF0USkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

ACM has two ways that it can complete address resolution.  The
first is to receive a response to an address resolution query.
The second is to receive a multicast message carrying an address
resolution request.  In the second case, the address request
may be between two other nodes.

When this occurs, ACM will record the address information of
the source of the multicast message.  However, it's possible
for ACM to be in the process of trying to resolve that address.
After it records the address, it must see if there's an
outstanding request against that address, so that it can kick
off route resolution.

This fixes an issue where ACM will hang resolving addresses
found during scale-up testing.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 src/acm.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/src/acm.c b/src/acm.c
index 404d2b5..77194ff 100644
--- a/src/acm.c
+++ b/src/acm.c
@@ -1027,7 +1027,7 @@ acm_process_addr_req(struct acm_ep *ep, struct ibv_wc *wc, struct acm_mad *mad)
 			status = acm_record_acm_route(ep, dest);
 			break;
 		}
-		if (addr_index >= 0) {
+		if (addr_index >= 0 || !DListEmpty(&dest->req_queue)) {
 			status = acm_resolve_path(ep, dest, acm_resolve_sa_resp);
 			if (status)
 				break;


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
