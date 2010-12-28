From: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 0/24] various fixes for QIB driver
Date: Tue, 28 Dec 2010 10:26:50 -0500
Message-ID: <20101228152648.19960.84006.stgit@kop-dev-sles11-04.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The following patches (ordered first to last) are for various bug fixes found
during internal testing.

IB/qib: remove IB latency turnoff
IB/qib: add receive header queue size module parameters
IB/qib: add support for the new QME7362 card
IB/qib: add thresholds to VendorPortCounters PMA operation
IB/qib: generate completion callback on errors
IB/qib: set port physical state even if other fields are invalid
IB/qib: UD send with immediate Rx completion has wrong size
IB/qib: Handle transitions from ACTIVE_DEFERRED to ACTIVE better
IB/qib: Multi Florida HCA Hosts panic on reboot
IB/qib: fix context allocation with multiple HCAs
IB/qib: clear WAIT_SEND flags when setting QP to error state
IB/qib: New SERDES init routine and improvements to SI quality
IB/qib: Reset packet list after freeing
IB/qib: Add a few new SERDES tunings
IB/qib: Avoid duplicate writes to the rcv head register
IB/qib: interrupt mitigation fix
IB/qib: change rcv queue/qpn selection
IB/qib: adding fix missing from earlier patch
IB/qib: change qpn increment
IB/qib: RDMA lkey/rkey validation is inefficient for large MRs
IB/qib: Issue pre-emptive NAKs on eager buffer overflow
IB/qib: Un-necessary delayed completions on RC connection
IB/qib: Add a delay to allow SERDES to initialize
IB/qib: Improve SERDES tunning on QMH boards
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
