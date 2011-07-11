From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 0/3] opensm: fixing unused-but-set warnings in compilation
Date: Mon, 11 Jul 2011 20:45:18 +0300
Message-ID: <20110711174518.GB2084@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Latest GCC 4.6 include -Wunused-* flags as part of the -Wall flag, causing
many warnings during OpenSM compilation.

This patch series tries to clean these warnings.
Where possible, unused variables were just deleted.
In other cases where some variables are used only when specific compilation
flags are used (DEBUG, VENDOR_RMPP_SUPPORT, etc') this variables marked as
__attribute__((unused)) meaning that the variable is meant to be possibly
unused.

More info:
http://gcc.gnu.org/onlinedocs/gcc/Warning-Options.html
http://gcc.gnu.org/onlinedocs/gcc-4.6.1/gcc/Variable-Attributes.html#Variable-Attributes


-- Alex
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
