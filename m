From: Bernard Metzler <BMT-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>
Subject: Re: [PATCH 05/14] SIWv3: User Interface: siw_ae.c, siw_verbs.c, siw_user.h, siw_verbs.h
Date: Sat, 23 Jul 2011 10:09:09 +0200
Message-ID: <OF9C85749A.DC74D49B-ONC12578D6.002C7550-C12578D6.002CC954@ch.ibm.com>
References: <1311360458-15187-1-git-send-email-bmt@zurich.ibm.com> <4E29C7DD.4050409@systemfabricworks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4E29C7DD.4050409-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: frank zago <fzago-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

six minutes to find the first issue! that scary ;)

let me set it to NULL at the very beginning of
the function.



Frank,
many thanks.

Bernard.

linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org wrote on 07/22/2011 08:56:29 PM:

> frank zago <fzago-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org> 
> Sent by: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> 
> 07/22/2011 08:56 PM
> 
> To
> 
> Bernard Metzler <bmt-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>
> 
> cc
> 
> linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> 
> Subject
> 
> Re: [PATCH 05/14] SIWv3: User Interface: siw_ae.c, siw_verbs.c, 
> siw_user.h, siw_verbs.h
> 
> On 07/22/2011 01:47 PM, Bernard Metzler wrote:
> > +int siw_post_receive(struct ib_qp *ofa_qp, struct ib_recv_wr *wr,
> > +           struct ib_recv_wr **bad_wr)
> > +{
> > +   struct siw_wqe   *wqe = NULL;
> > +   struct siw_qp   *qp = siw_qp_ofa2siw(ofa_qp);
> > +   unsigned long   flags;
> > +   int rv = 0;
> > +
> > +   dprint(DBG_WR|DBG_TX, "(QP%d): state=%d\n", QP_ID(qp),
> > +      qp->attrs.state);
> > +
> > +   if (qp->srq)
> > +      return -EOPNOTSUPP; /* what else from errno.h? */
> 
> bad_wr is not set.
> 
> > +   /*
> > +    * Try to acquire QP state lock. Must be non-blocking
> > +    * to accommodate kernel clients needs.
> > +    */
> > +   if (!down_read_trylock(&qp->state_lock)) {
> > +      *bad_wr = wr;
> > +      return -ENOTCONN;
> > +   }
> > +
> > +   if (qp->attrs.state > SIW_QP_STATE_RTS) {
> > +      up_read(&qp->state_lock);
> > +      dprint(DBG_ON, " (QP%d): state=%d\n", QP_ID(qp),
> > +         qp->attrs.state);
> > +      return -EINVAL;
> 
> ditto.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
