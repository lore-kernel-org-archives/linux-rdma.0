From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [for-next 1/2] xprtrdma: take reference of rdma provider module
Date: Mon, 21 Jul 2014 10:03:45 -0500
Message-ID: <005701cfa4f4$f7a64c00$e6f2e400$@opengridcomputing.com>
References: <1405605697-11583-1-git-send-email-devesh.sharma@emulex.com> <3e39e90f-7095-4eb9-a844-516672a355ad@CMEXHTCAS2.ad.emulex.com> <53C7E546.3080008@opengridcomputing.com> <1828884A29C6694DAF28B7E6B8A823739933FCA3@ORSMSX109.amr.corp.intel.com> <53C81CB7.2030000@oracle.com> <006d01cfa1f2$65d020d0$31706270$@opengridcomputing.com> <1828884A29C6694DAF28B7E6B8A823739933FDEA@ORSMSX109.amr.corp.intel.com> <008301cfa1fa$f231f550$d695dff0$@opengridcomputing.com> <DF7CE85B-288D-4CC2-AD51-B326D5F1EE1A@oracle.com> <008c01cfa201$f1eecda0$d5cc68e0$@opengridcomputing.com> <EE7902D3F51F404C82415C4803930ACD3FE1482F@CMEXMB1.ad.emulex.com> <002401cfa28c$11feb4e0$35fc1ea0$@opengridcomputing.com> <53C94199.4050601@oracle.com> <EE7902D3F51F404C82415C4803930ACD3FE1C7B7@CMEXMB1.ad.emulex.com> <a6345162-863d
 -447c-b7c2-059ced190a13@CMEXHTCAS1.ad.emulex.com> <27ACE237-161A-4CA5-AA5C-6349CC4118E3@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <27ACE237-161A-4CA5-AA5C-6349CC4118E3-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Chuck Lever' <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, 'Devesh Sharma' <Devesh.Sharma-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org>
Cc: 'Shirley Ma' <shirley.ma-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "'Hefty, Sean'" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Roland Dreier' <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



> -----Original Message-----
> From: Chuck Lever [mailto:chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org]
> Sent: Monday, July 21, 2014 9:54 AM
> To: Devesh Sharma
> Cc: Shirley Ma; Steve Wise; Hefty, Sean; Roland Dreier; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Subject: Re: [for-next 1/2] xprtrdma: take reference of rdma provider module
> 
> Hi Devesh-
> 
> Thanks for drilling into this further.
> 
> On Jul 21, 2014, at 7:48 AM, Devesh Sharma <Devesh.Sharma-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org> wrote:
> 
> > In rpcrdma_ep_connect():
> >
> > write_lock(&ia->ri_qplock);
> >                old = ia->ri_id;
> >                ia->ri_id = id;
> >                write_unlock(&ia->ri_qplock);
> >
> >                rdma_destroy_qp(old);
> >                rdma_destroy_id(old);  =============> Cm -id is destroyed here.
> >
> >
> > If following code fails in rpcrdma_ep_connect():
> > id = rpcrdma_create_id(xprt, ia,
> >                                (struct sockaddr *)&xprt->rx_data.addr);
> >                if (IS_ERR(id)) {
> >                        rc = -EHOSTUNREACH;
> >                        goto out;
> >                }
> >
> > it leaves old cm-id still alive. This will always fail if Device is removed abruptly.
> 
> For CM_EVENT_DEVICE_REMOVAL, rpcrdma_conn_upcall() sets ep->rep_connected
> to -ENODEV.
> 
> Then:
> 
>  929 int
>  930 rpcrdma_ep_connect(struct rpcrdma_ep *ep, struct rpcrdma_ia *ia)
>  931 {
>  932         struct rdma_cm_id *id, *old;
>  933         int rc = 0;
>  934         int retry_count = 0;
>  935
>  936         if (ep->rep_connected != 0) {
>  937                 struct rpcrdma_xprt *xprt;
>  938 retry:
>  939                 dprintk("RPC:       %s: reconnecting...\n", __func__);
> 
> ep->rep_connected is probably -ENODEV after a device removal. It would be
> possible for the connect worker to destroy everything associated with this
> connection in that case to ensure the underlying object reference counts
> are cleared.
> 
> The immediate danger is that if there are pending RPCs, they could exit while
> qp/cm_id are NULL, triggering a panic in rpcrdma_deregister_frmr_external().
> Checking for NULL pointers inside the ri_qplock would prevent that.
> 
> However, NFS mounts via this adapter will hang indefinitely after all
> transports are torn down and the adapter is gone. The only thing that can be
> done is something drastic like "echo b > /proc/sysrq_trigger" on the client.
> 
> Thus, IMO hot-plugging or passive fail-over are the only scenarios where
> this makes sense. If we have an immediate problem here, is it a problem with
> system shutdown ordering that can be addressed in some other way?
> 
> Until that support is in place, obviously I would prefer that the removal of
> the underlying driver be prevented while there are NFS mounts in place. I
> think that's what NFS users have come to expect.
> 
> In other words, don't allow device removal until we have support for device
> insertion :-)
> 
> 


If we fix the above problems on provider unload, shouldn't the mount recover if the
provider module is subsequently loaded?  Or another provider configured such that
rdma_resolve_addr/route() then picks an active device?



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
