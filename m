From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] librdmacm: document event status field
Date: Thu, 29 Jul 2010 14:37:57 -0700
Message-ID: <CF9C39F99A89134C9CF9C4CCB68B8DDF25A927290C@orsmsx501.amr.corp.intel.com>
References: <AANLkTik2eOWELUAwjL+tfjMb28L3OjWB57iMyvDpOWDm@mail.gmail.com>
 <CF9C39F99A89134C9CF9C4CCB68B8DDF25A8D7FBFB@orsmsx501.amr.corp.intel.com>
 <4C5121D7.7070604@Voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4C5121D7.7070604-hKgKHo2Ms0FWk0Htik3J/w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-hKgKHo2Ms0FWk0Htik3J/w@public.gmane.org>, Eldad Zinger <eldadz-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Clarify the value returned in the event status field.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 man/rdma_get_cm_event.3 |   14 +++++++++++---
 1 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/man/rdma_get_cm_event.3 b/man/rdma_get_cm_event.3
index 2ea1b56..b0c4970 100644
--- a/man/rdma_get_cm_event.3
+++ b/man/rdma_get_cm_event.3
@@ -41,7 +41,10 @@ Specifies the type of communication event which occurred.  See EVENT TYPES
 below.
 .IP "status" 12
 Returns any asynchronous error information associated with an event.  The
-status is zero unless the corresponding operation failed.
+status is zero if the operation was successful, otherwise the status value
+is non-zero and is either set to an errno or a transport specific value.
+For details on transport specific status values, see the event type information
+below.
 .IP "param" 12
 Provides additional details based on the type of event.  Users should
 select the conn or ud subfields based on the rdma_port_space of the
@@ -126,10 +129,15 @@ Indicates that an error has occurred trying to establish or a connection.
 May be generated on the active or passive side of a connection.
 .IP RDMA_CM_EVENT_UNREACHABLE
 Generated on the active side to notify the user that the remote server is
-not reachable or unable to respond to a connection request.
+not reachable or unable to respond to a connection request.  If this event
+is generated in response to a UD QP resolution request over InfiniBand,
+the event status field will contain an errno, if negative, or the status
+result carried in the IB CM SIDR REP message.
 .IP RDMA_CM_EVENT_REJECTED
 Indicates that a connection request or response was rejected by the remote
-end point.
+end point.  The event status field will contain the transport specific
+reject reason if available.  Under InfiniBand, this is the reject reason
+carried in the IB CM REJ message.
 .IP RDMA_CM_EVENT_ESTABLISHED
 Indicates that a connection has been established with the remote end point.
 .IP RDMA_CM_EVENT_DISCONNECTED


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
