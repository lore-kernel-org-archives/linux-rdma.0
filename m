From: Devesh Sharma <Devesh.Sharma-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org>
Subject: RE: [for-next 1/2] xprtrdma: take reference of rdma provider module
Date: Fri, 18 Jul 2014 05:05:19 +0000
Message-ID: <EE7902D3F51F404C82415C4803930ACD3FE1482F@CMEXMB1.ad.emulex.com>
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
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <008c01cfa201$f1eecda0$d5cc68e0$@opengridcomputing.com>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, 'Chuck Lever' <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: "'Hefty, Sean'" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Shirley Ma' <shirley.ma-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, 'Roland Dreier' <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> -----Original Message-----
> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-
> owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Steve Wise
> Sent: Friday, July 18, 2014 2:29 AM
> To: 'Chuck Lever'
> Cc: 'Hefty, Sean'; 'Shirley Ma'; Devesh Sharma; 'Roland Dreier'; linux-
> rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Subject: RE: [for-next 1/2] xprtrdma: take reference of rdma provider
> module
> 
> 
> 
> > -----Original Message-----
> > From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > [mailto:linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Chuck Lever
> > Sent: Thursday, July 17, 2014 3:42 PM
> > To: Steve Wise
> > Cc: Hefty, Sean; Shirley Ma; Devesh Sharma; Roland Dreier;
> > linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > Subject: Re: [for-next 1/2] xprtrdma: take reference of rdma provider
> > module
> >
> >
> > On Jul 17, 2014, at 4:08 PM, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
> wrote:
> >
> > >
> > >
> > >> -----Original Message-----
> > >> From: Steve Wise [mailto:swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org]
> > >> Sent: Thursday, July 17, 2014 2:56 PM
> > >> To: 'Hefty, Sean'; 'Shirley Ma'; 'Devesh Sharma'; 'Roland Dreier'
> > >> Cc: 'linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org'; 'chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org'
> > >> Subject: RE: [for-next 1/2] xprtrdma: take reference of rdma
> > >> provider module
> > >>
> > >>
> > >>
> > >>> -----Original Message-----
> > >>> From: Hefty, Sean [mailto:sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org]
> > >>> Sent: Thursday, July 17, 2014 2:50 PM
> > >>> To: Steve Wise; 'Shirley Ma'; 'Devesh Sharma'; 'Roland Dreier'
> > >>> Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org
> > >>> Subject: RE: [for-next 1/2] xprtrdma: take reference of rdma
> > >>> provider module
> > >>>
> > >>>>> So the rdma cm is expected to increase the driver reference
> > >>>>> count
> > >>>> (try_module_get) for
> > >>>>> each new cm id, then deference count (module_put) when cm id is
> > >>>> destroyed?
> > >>>>>
> > >>>>
> > >>>> No, I think he's saying the rdma-cm posts a
> > >>>> RDMA_CM_DEVICE_REMOVAL event to each application with
> rdmacm
> > >>>> objects allocated, and each application is expected to destroy
> > >>>> all the objects it has allocated before returning from the event
> > >>>> handler.
> > >>>
> > >>> This is almost correct.  The applications do not have to destroy
> > >>> all the objects
> that
> > > it has
> > >>> allocated before returning from their event handler.  E.g. an app
> > >>> can queue a work
> > > item
> > >>> that does the destruction.  The rdmacm will block in its ib_client
> > >>> remove handler
> > > until all
> > >>> relevant rdma_cm_id's have been destroyed.
> > >>>
> > >>
> > >> Thanks for the clarification.
> > >>
> > >
> > > And looking at xprtrdma, it does handle the DEVICE_REMOVAL event in
> > rpcrdma_conn_upcall().
> > > It sets ep->rep_connected to -ENODEV, wakes everybody up, and calls
> > rpcrdma_conn_func()
> > > for that endpoint, which schedules rep_connect_worker...  and I gave
> > > up following the
> > code
> > > path at this point... :)
> > >
> > > For this to all work correctly, it would need to destroy all the
> > > QPs, MRs, CQs, etc
> for
> > > that device _before_ destroying the rdma cm ids.  Otherwise the
> > > provider module could
> > be
> > > unloaded too soon.
> >
> > We can't really deal with a CM_DEVICE_REMOVE event while there are
> > active NFS mounts.
> >
> > System shutdown ordering should guarantee (one would hope) that NFS
> > mount points are unmounted before the RDMA/IB core infrastructure is
> > torn down. Ordering shouldn't matter as long all NFS activity has
> > ceased before the CM tries to remove the device.
> >
> > So if something is hanging up the CM, there's something xprtrdma is
> > not cleaning up properly.
> >
> 
> 
> Devesh, how are you reproducing this?  Are you just rmmod'ing the ocrdma
> module while there are active mounts?

Yes, I am issuing rmmod while there is an active mount. In my case rmmod ocrdma remains blocked forever.
Off-the-course of this discussion: Is there a reasoning behind not using ib_register_client()/ib_unregister_client() framework?
> 
> 
> 
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in the
> body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org More majordomo info at
> http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
