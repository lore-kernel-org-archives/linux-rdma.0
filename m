From: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: mlx4_wq_overflow question
Date: Thu, 9 Feb 2012 00:45:46 +0200
Message-ID: <20120208224546.GA31369@mtldesk30>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Roland,

referring to the function below, I can't find a strong reason to check
again after acquiring the cq spinlock. Any idea?

static int mlx4_wq_overflow(struct mlx4_ib_wq *wq, int nreq, struct
ib_cq *ib_cq)
{
        unsigned cur;
        struct mlx4_ib_cq *cq;

        cur = wq->head - wq->tail;
        if (likely(cur + nreq < wq->max_post))
                return 0;

        cq = to_mcq(ib_cq);
        spin_lock(&cq->lock);
        cur = wq->head - wq->tail;
        spin_unlock(&cq->lock);

        return cur + nreq >= wq->max_post;
}
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
