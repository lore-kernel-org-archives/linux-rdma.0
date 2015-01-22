From: floaterions <floaterions-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: librdmacm and experimental verbs
Date: Thu, 22 Jan 2015 17:17:50 +0000 (UTC)
Message-ID: <loom.20150122T180904-367@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hello all,

Since atomic operations in Connect-IB (with mlx5 driver) are not supported with
the standard library, I have to use experimental verbs (e.g. ibv_exp_create_qp
instead of ibv_create_qp when creating queue pairs).

Unfortunately my code is heavily based on librdmacm for creating the queue pairs
and transitioning them from INIT to RTR and RTS states. I was wondering if
librdmacm has any support for experimental verbs, perhaps in its newer versions?

- Erfan

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
