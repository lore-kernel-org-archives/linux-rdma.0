From: Devesh Sharma <Devesh.Sharma-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org>
Subject: RE: [for-next 1/2] xprtrdma: take reference of rdma provider module
Date: Mon, 21 Jul 2014 11:48:10 +0000
Message-ID: <a6345162-863d-447c-b7c2-059ced190a13@CMEXHTCAS1.ad.emulex.com>
References: <1405605697-11583-1-git-send-email-devesh.sharma@emulex.com>
 <3e39e90f-7095-4eb9-a844-516672a355ad@CMEXHTCAS2.ad.emulex.com>
 <53C7E546.3080008@opengridcomputing.com>
 <1828884A29C6694DAF28B7E6B8A823739933FCA3@ORSMSX109.amr.corp.intel.com>
 <53C81CB7.2030000@oracle.com>
 <006d01cfa1f2$65d020d0$31706270$@opengridcomputing.com>
 <1828884A29C6694DAF28B7E6B8A823739933FDEA@ORSMSX109.amr.corp.intel.com>
  <008301cfa1fa$f231f550$d695dff0$@opengridcomputing.com>
 <DF7CE85B-288D-4CC2-AD51-B326D5F1EE1A@oracle.com>
 <008c01cfa201$f1eecda0$d5cc68e0$@opengridcomputing.com>
 <EE7902D3F51F404C82415C4803930ACD3FE1482F@CMEXMB1.ad.emulex.com>
 <002401cfa28c$11feb4e0$35fc1ea0$@opengridcomputing.com>
 <53C94199.4050601@oracle.com>
 <EE7902D3F51F404C82415C4803930ACD3FE1C7B7@CMEXMB1.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <EE7902D3F51F404C82415C4803930ACD3FE1C7B7-DWYeeINJQrxExQ8dmkPuX0M9+F4ksjoh@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Devesh Sharma <Devesh.Sharma-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org>, Shirley Ma <shirley.ma-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, 'Chuck Lever' <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: "'Hefty, Sean'" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Roland Dreier' <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

In rpcrdma_ep_connect():

write_lock(&ia->ri_qplock);
                old = ia->ri_id;
                ia->ri_id = id;
                write_unlock(&ia->ri_qplock);

                rdma_destroy_qp(old);
                rdma_destroy_id(old);  =============> Cm -id is destroyed here.


If following code fails in rpcrdma_ep_connect():
id = rpcrdma_create_id(xprt, ia,
                                (struct sockaddr *)&xprt->rx_data.addr);
                if (IS_ERR(id)) {
                        rc = -EHOSTUNREACH;
                        goto out;
                }

it leaves old cm-id still alive. This will always fail if Device is removed abruptly.

In rdma_resolve_addr()/rdma_destroy_id() cm_dev is referenced/de-referenced here (cma.c):

static int cma_acquire_dev(struct rdma_id_private *id_priv,
                           struct rdma_id_private *listen_id_priv) {
.
.
if (!ret)
                cma_attach_to_dev(id_priv, cma_dev);
}

static void cma_release_dev(struct rdma_id_private *id_priv)
{
        mutex_lock(&lock);
        list_del(&id_priv->list);
        cma_deref_dev(id_priv->cma_dev);
.
.
}

Since as per design of nfs-rdma at-least previously known good cm-id always remains live utill
another good cm-id is created, cma_dev->refcount never becomes 0 upon device removal .
Thus blocking the rmmod <vendor driver> forever.

-Regards
 Devesh

> -----Original Message-----
> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-
> owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Devesh Sharma
> Sent: Monday, July 21, 2014 11:42 AM
> To: Shirley Ma; Steve Wise; 'Chuck Lever'
> Cc: 'Hefty, Sean'; 'Roland Dreier'; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Subject: RE: [for-next 1/2] xprtrdma: take reference of rdma provider
> module
> 
> Shirley,
> 
> Once rmmod is issued, the connection corresponding to the active mount is
> destroyed and all the associated resources Are freed. As per the processing
> logic of DEVICE-REMOVAL event, nfs-rdma wakes-up all the  waiters, This
> results into Re-establishment efforts, since the device is not present any
> more, rdma_resolve_address() fails with CM resolution Error. This loop
> continues forever.
> 
> I am yet to find out which part of ocrdma is blocked. I am putting some debug
> messages to find it out. I will get back to The group with an update.
> 
> -Regards
>  Devesh
> 
> > -----Original Message-----
> > From: Shirley Ma [mailto:shirley.ma-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org]
> > Sent: Friday, July 18, 2014 9:18 PM
> > To: Steve Wise; Devesh Sharma; 'Chuck Lever'
> > Cc: 'Hefty, Sean'; 'Roland Dreier'; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > Subject: Re: [for-next 1/2] xprtrdma: take reference of rdma provider
> > module
> >
> >
> > On 07/18/2014 06:27 AM, Steve Wise wrote:
> > >>>> We can't really deal with a CM_DEVICE_REMOVE event while there
> > >>>> are active NFS mounts.
> > >>>>
> > >>>> System shutdown ordering should guarantee (one would hope) that
> > NFS
> > >>>> mount points are unmounted before the RDMA/IB core
> infrastructure
> > >>>> is torn down. Ordering shouldn't matter as long all NFS activity
> > >>>> has ceased before the CM tries to remove the device.
> > >>>>
> > >>>> So if something is hanging up the CM, there's something xprtrdma
> > >>>> is not cleaning up properly.
> > >>>>
> > >>>
> > >>>
> > >>> Devesh, how are you reproducing this?  Are you just rmmod'ing the
> > >>> ocrdma module while there are active mounts?
> > >>
> > >> Yes, I am issuing rmmod while there is an active mount. In my case
> > >> rmmod ocrdma remains blocked forever.
> > Where is it blocked?
> >
> > >> Off-the-course of this discussion: Is there a reasoning behind not
> > >> using
> > >> ib_register_client()/ib_unregister_client() framework?
> > >
> > > I think the idea is that you don't need to use it if you are
> > > transport-independent and use the rdmacm...
> > >
> > >
> > >
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-rdma"
> > > in the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org More
> > majordomo
> > > info at  http://vger.kernel.org/majordomo-info.html
> > >
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in the
> body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org More majordomo info at
> http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
