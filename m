From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: [PATCH v2 0/2] Fix a use-after-free in ib_umad
Date: Tue, 13 May 2014 12:30:08 +0200
Message-ID: <5371F430.5010109@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Alex Chiang <achiang-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Changes compared to version 1 of this patch series:
* Folded the first patch into the second.
* Implemented Yann's suggestion to drop the test of "ret" in the
  non-error path of ib_umad_sm_open().
* Simplified the implementation of ib_umad_open() and ib_umad_sm_open()
  further.

This patch series consists of the following two patches:
0001-IB-umad-Fix-error-handling.patch
0002-IB-umad-Fix-a-use-after-free.patch
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
