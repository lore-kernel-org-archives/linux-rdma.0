From: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 0/7] various fixes for QIB driver
Date: Thu, 17 Jun 2010 16:13:38 -0700
Message-ID: <20100617231338.8006.18131.stgit@chromite.mv.qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The following patches are for various bug fixes.
I'm not sure what counts as a regression for code that is newly introduced.
I'm hoping that all except #2 can be made for 2.6.35 whereas
#2 can wait for 2.6.36 since it is actually a feature.

IB/qib: avoid a rare 7322 chip problem by not marking VL15 bufs as WC
IB/qib: allow PSM to select from multiple port assignment algorithms
IB/qib: mask hardware error during link reset
IB/qib: clear eager buffer memory for each new process
IB/qib: clear 6120 hardware error register
IB/qib: update 7322 serdes tables
IB/qib: completion queue callback needs to be single threaded
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
