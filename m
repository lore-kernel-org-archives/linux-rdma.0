From: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v6 12/16] IB/pvrdma: Add Queue Pair support
Date: Fri, 2 Dec 2016 20:48:51 +0530
Message-ID: <dafabbe5-db7a-be94-3845-e4da838acf63@vmware.com>
References: <cover.1475458407.git.aditr@vmware.com>
 <6a643e92376856394d45638d80a90619d3abac37.1475458407.git.aditr@vmware.com>
 <20161121155141.GA11371@yuval-lap>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161121155141.GA11371@yuval-lap>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, pv-drivers-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org, jhansen-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org, asarwade-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org, georgezhang-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org, bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Nov 21, 2016 at 5:51:42PM +0200, Yuval Shaia wrote:
> On Sun, Oct 02, 2016 at 07:10:32PM -0700, Adit Ranadive wrote:
> > +
> > +	spin_lock_irqsave(&qp->sq.lock, flags);
> > +
> > +	index = pvrdma_idx(&qp->sq.ring->prod_tail, qp->sq.wqe_cnt);
> > +	for (nreq = 0; wr; nreq++, wr = wr->next) {
> 
> nreq is not in used so better remove it.

Thanks!
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
