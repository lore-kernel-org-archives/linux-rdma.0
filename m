From: Mike Heinz <michael.heinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] Infiniband-Diags: ibping server sends responses even after
 the client has terminated
Date: Wed, 8 Feb 2012 08:34:47 -0600
Message-ID: <4C2744E8AD2982428C5BFE523DF8CDCB5CD5AD8E20@MNEXMB1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "weiny2-i2BcT+NCU+M@public.gmane.org" <weiny2-i2BcT+NCU+M@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is OFED bug 1974, it's been open for a couple of years now. Ira, I think you're the ib-diags guy now, right?

In any case, it's a trivial issue: ibping -S treats receive errors as if they were valid incoming MAD packets and tries to send responses to them. The fix is easy, just check the status field of the received umad structure:

Index: ibping.c
===================================================================
RCS file: /cvs/vendor/OFA/Ofed/infiniband-diags/src/src/ibping.c,v
retrieving revision 1.34
diff -u -d -w -r1.34 ibping.c
--- ibping.c    7 Feb 2012 17:29:12 -0000       1.34
+++ ibping.c    8 Feb 2012 14:24:39 -0000
@@ -83,7 +83,7 @@
        DEBUG("starting to serve...");

        while ((umad = mad_receive_via(0, -1, srcport))) {
-
+               if (umad_status(umad) == 0) {
                mad = umad_get_mad(umad);
                data = (char *)mad + IB_VENDOR_RANGE2_DATA_OFFS;

@@ -94,6 +94,7 @@
                if (mad_respond_via(umad, 0, 0, srcport) < 0)
                        DEBUG("respond failed");

+               }
                mad_free(umad);
        }

===================================================================

This message and any attached documents contain information from QLogic Corporation or its wholly-owned subsidiaries that may be confidential. If you are not the intended recipient, you may not read, copy, distribute, or use this information. If you have received this transmission in error, please notify the sender immediately by reply e-mail and then delete this message.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
