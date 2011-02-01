From: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2] IB/qib: add thresholds to VendorPortCounters PMA operation
Date: Tue, 01 Feb 2011 09:23:48 -0500
Message-ID: <20110201142348.9826.83896.stgit@kop-dev-sles11-04.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org, tom.elken-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org, hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org, todd.rimmer-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The patch has been reworked so that the fields used are no longer reserved.

The QLogic PMA has a vendor specific capability.  We are using the top
2 bits of the CapabilityMask2 to indicate the behavior is available.

By not setting the bit 2 in the CapabilityMask, we are indicating that
other PMA clients should ignore CapabilityMask2.

As such no other tools should be confused by our setting of the 2 bits
(because they should not look in CapabilityMask2 anyway).

We purposely do not set the PortXmitWait CapabilityMask bit, this
driver does not implement that capability.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
