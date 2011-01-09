From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: [PATCH 0/7] ib_srpt patches
Date: Sun, 9 Jan 2011 17:23:41 +0100
Message-ID: <201101091723.41399.bvanassche@acm.org>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The following patches apply on top of the ib_srpt source code as posted on
December 20, 2010:
1. Add the attribute hw_address to sysfs such that udev rules can be developed
   that allow to make the relationship between an SCST target name and a HCA
   node GUID persistent.
2. Convert I/O context state from an atomic variable to a spinlock-protected
   regular variable.
3. Make the RDMA channel state names more brief.
4. Introduce the function srpt_ch_qp_err().
5. Fix a bug in a session creation error path.
6. Convert the channel state from an atomic variable to a spinlock-protected
   regular variable.
7. Fix races related to session unregistration.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
