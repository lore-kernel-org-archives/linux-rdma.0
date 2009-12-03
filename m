From: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 0/51] updated patches for adding QIB driver
Date: Thu, 03 Dec 2009 11:03:05 -0800
Message-ID: <20091203190305.29507.58158.stgit@chromite.mv.qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The following emails are in response to Rolands comments.
Since the patches are for whole files, its hard to see what
has changed but I describe it below.

A reminder that these depend on the patch I sent earlier which
introduces ib_sysfs_create_port_files() into the ib_core.

---

Changed the Makefile line-by-line to multi-line list of .o files and
removed the -D flags.

Removed qib_trace.[ch]. Debug messages use printk similar to ib_ipath.

Fixed compiles when CONFIG_PCI_MSI is not defined.

Removed #ifdefs and backport code for AER.

Reduced the size of the chip register definition files.

Changed global function names which conflict with ib_ipath to
be prefixed with qib_ (requires ib_ipath and ib_qib to be compiled
into the kernel instead of as separate modules).
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
