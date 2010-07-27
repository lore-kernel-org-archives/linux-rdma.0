From: Or Gerlitz <ogerlitz-hKgKHo2Ms0FWk0Htik3J/w@public.gmane.org>
Subject: Re: CMA handler status code
Date: Tue, 27 Jul 2010 09:48:14 +0300
Message-ID: <4C4E812E.1090505@Voltaire.com>
References: <AANLkTik2eOWELUAwjL+tfjMb28L3OjWB57iMyvDpOWDm@mail.gmail.com> <4C4E7F5E.6070306@Voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4C4E7F5E.6070306-hKgKHo2Ms0FWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Eldad Zinger <eldadz-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

> For user space, I would add a comment in the man pages

[PATCH] librdmacm/man: document status field semantics for rejected event

document status being the IB reject reason for RDMA_CM_EVENT_REJECTED event

Signed-off-by: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>

diff --git a/man/rdma_get_cm_event.3 b/man/rdma_get_cm_event.3
index 79bf606..91317c4 100644
--- a/man/rdma_get_cm_event.3
+++ b/man/rdma_get_cm_event.3
@@ -126,7 +126,8 @@ Generated on the active side to notify the user that the remote server is
 not reachable or unable to respond to a connection request.
 .IP RDMA_CM_EVENT_REJECTED
 Indicates that a connection request or response was rejected by the remote
-end point.
+end point. Under Infiniband, the event status field contains the reject reason
+as provided by the IB CM.
 .IP RDMA_CM_EVENT_ESTABLISHED
 Indicates that a connection has been established with the remote end point.
 .IP RDMA_CM_EVENT_DISCONNECTED
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
