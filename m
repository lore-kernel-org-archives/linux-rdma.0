From: Albert Strasheim <fullung-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: ibv_modify_qp to IBV_QPS_ERR returns EAGAIN
Date: Tue, 28 Aug 2012 17:01:55 +0200
Message-ID: <CALfB72A42UaUpxu+s_Cnr2P77CBN2=+bys-vBxF5W94bah5cVA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hello all

I was wondering if anyone could shed some light about what kind
conditions might cause ibv_modify_qp to IBV_QPS_ERR to return EAGAIN?

The error occurred on a QP that probably already had some work
completions for requests that failed. I've only seen it happen once in
about 3 months, so reproducing is quite hard.

Thanks.

Regards

Albert
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
