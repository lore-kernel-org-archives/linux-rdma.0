From: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Problem with XRC userspace
Date: Mon, 15 Feb 2010 14:56:56 +0200
Message-ID: <201002151456.56696.jackm@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org
Cc: rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org, Tziporet Koren <tziporet-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, changquing.tang-VXdhtT5mjnY@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Roland,

The issue in these e-mails I am  forwarding is still a real problem.

If I put the XRC srq fields after the pthread_cond_t, the RHEL4/5 incompatibility kicks in, in a big way.
If I put them before the pthread_cond_t, we still have a problem with "events_completed", as indicated
by Gleb Nabokov of Voltaire, not to mention requiring all apps using libibverbs to recompile
(no backwards libibverbs binary compatibility).

(Note that this bug still exists, without the XRC changes, both for  struct ibv_qp  and   struct ibv_qp  
    -- see __ibv_ack_async_event() in libibverbs/src/device.c :
        case IBV_EVENT_QP_FATAL:
        case IBV_EVENT_QP_REQ_ERR:
        case IBV_EVENT_QP_ACCESS_ERR:
        case IBV_EVENT_COMM_EST:
        case IBV_EVENT_SQ_DRAINED:
        case IBV_EVENT_PATH_MIG:
        case IBV_EVENT_PATH_MIG_ERR:
        case IBV_EVENT_QP_LAST_WQE_REACHED:
        {
                struct ibv_qp *qp = event->element.qp;

                pthread_mutex_lock(&qp->mutex);
===>            ++qp->events_completed;
                pthread_cond_signal(&qp->cond);
                pthread_mutex_unlock(&qp->mutex);

                return;
        }

        case IBV_EVENT_SRQ_ERR:
        case IBV_EVENT_SRQ_LIMIT_REACHED:
        {
                struct ibv_srq *srq = event->element.srq;

                pthread_mutex_lock(&srq->mutex);
===>            ++srq->events_completed;
                pthread_cond_signal(&srq->cond);
                pthread_mutex_unlock(&srq->mutex);

                return;


In the OFED distribution, since it is installed as a set of packages, we simply moved the mutex and cond fields
to the end of the structures involved (as a userspace fix).  What on earth can we do for the mainstream
( see below -- "Yikes...")?

any ideas? Another "compat" layer, and incrementing the ABI version maybe?

-Jack

----------  Forwarded Message  ----------

Subject: [ofa-general] Another XRC binary compatable issue for different pthread version.
Date: Sunday 17 February 2008 20:31
From: "Tang, Changqing" <changquing.tang-VXdhtT5mjnY@public.gmane.org>
To: "general-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <general-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>


HI:
        Here is the ibv_srq structure:

struct ibv_srq {
        struct ibv_context     *context;
        void                   *srq_context;
        struct ibv_pd          *pd;
        uint32_t                handle;

        pthread_mutex_t         mutex;
        pthread_cond_t          cond;
        uint32_t                events_completed;

        uint32_t                xrc_srq_num;
        struct ibv_xrc_domain  *xrc_domain;
        struct ibv_cq          *xrc_cq;
};

On redhat 5 system, since it has a new pthread version, 'pthread_cond_t' is larger
than on redhat 4 system.

So if I compile the code on redhat 5 system, it won't run on redhat 4 system, and
vice versa.


--CQ
_______________________________________________
general mailing list
general-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
http://lists.openfabrics.org/cgi-bin/mailman/listinfo/general

To unsubscribe, please visit http://openib.org/mailman/listinfo/openib-general


-------------------------------------------------------


----------  Forwarded Message  ----------

Subject: RE: [ofa-general] Another XRC binary compatable issue for	different pthread version.
Date: Monday 18 February 2008 17:29
From: "Tang, Changqing" <changquing.tang-VXdhtT5mjnY@public.gmane.org>
To: Gleb Natapov <glebn-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, "general-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <general-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>


Any application code access events_completed field ?  HP-MPI does not.

If no user code access 'mutex' 'cond' and 'events_completed', I suggest to
put the XRC fields in the middle of this structure.


--CQ


> -----Original Message-----
> From: Gleb Natapov [mailto:glebn-smomgflXvOZWk0Htik3J/w@public.gmane.org]
> Sent: Monday, February 18, 2008 9:21 AM
> To: Tang, Changqing
> Cc: Roland Dreier; general-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
> Subject: Re: [ofa-general] Another XRC binary compatable
> issue for different pthread version.
>
> On Mon, Feb 18, 2008 at 03:15:01PM +0000, Tang, Changqing wrote:
> >
> > Without using XRC fields, everything seems to work OK.
> >
> It's only seems so. Access to events_completed should be also
> problematic.
>
> > --CQ
> >
> >
> > > -----Original Message-----
> > > From: Roland Dreier [mailto:rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org]
> > > Sent: Monday, February 18, 2008 7:24 AM
> > > To: Tang, Changqing
> > > Cc: general-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
> > > Subject: Re: [ofa-general] Another XRC binary compatable
> issue for
> > > different pthread version.
> > >
> > >  >         Here is the ibv_srq structure:
> > >  >
> > >  > struct ibv_srq {
> > >  ...
> > >  >         pthread_cond_t          cond;
> > >
> > >  > On redhat 5 system, since it has a new pthread version,
> > > 'pthread_cond_t' is larger  > than on redhat 4 system.
> > >
> > > Yikes... I don't see any way to handle this without breaking the
> > > libibverbs ABI for all existing binaries, since we have to move
> > > pthread_cond_t out of all exposed structures....
> > >
> > > Any ideas??
> > >
> > >  - R.
> > >
> > _______________________________________________
> > general mailing list
> > general-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
> > http://lists.openfabrics.org/cgi-bin/mailman/listinfo/general
> >
> > To unsubscribe, please visit
> > http://openib.org/mailman/listinfo/openib-general
>
> --
>                         Gleb.
>
_______________________________________________
general mailing list
general-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
http://lists.openfabrics.org/cgi-bin/mailman/listinfo/general

To unsubscribe, please visit http://openib.org/mailman/listinfo/openib-general


-------------------------------------------------------
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
