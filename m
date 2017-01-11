From: Robert LeBlanc <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org>
Subject: How do I clear out a send/receive queue in the kernel?
Date: Wed, 11 Jan 2017 16:01:42 -0700
Message-ID: <CAANLjFr0fORQACPu=79hWTkKA8i1YRN0tbsbz1EcYBJTA5BkmA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

How would I go about discarding anything in the send or receive queue
without gracefully flushing it or destroying the queue pair in the
kernel? I have a feeling I have something stuck in the send queue
preventing ib_drain_qp from completing, so I need to try just clearing
it out.

Thanks


----------------
Robert LeBlanc
PGP Fingerprint 79A2 9CA4 6CC4 45DD A904  C70E E654 3BB2 FA62 B9F1
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
