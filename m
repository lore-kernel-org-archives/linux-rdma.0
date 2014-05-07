From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: Announcing IBM Platform MPI 9.1.2.1 FixPack
Date: Wed, 7 May 2014 05:00:24 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373992F9213@ORSMSX109.amr.corp.intel.com>
References: <OF4A39F4F6.9B304440-ON86257CD0.006F96D1-86257CD0.00703B71@us.ibm.com>
 <1828884A29C6694DAF28B7E6B8A82373992F8E3E@ORSMSX109.amr.corp.intel.com>
 <OF33DE6020.C2F63AB6-ON86257CD1.000D2DD2-86257CD1.000D9C90@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <OF33DE6020.C2F63AB6-ON86257CD1.000D2DD2-86257CD1.000D9C90-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Solt <dsolt-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> Yes, the delay seems to be coming here:
> 
>         err = hpmp_rdmacm->rdma_connect(id, NULL);
>         if (err) {
>                 hpmp_printf("rdma_connect() failed");
>                 return NULL;
>         }
> t1 = MPI_Wtime();
> 
> retry3:
>         err =
> hpmp_rdmacm->rdma_get_cm_event(hpmp_rdmacm->connect_cm_channel, &event);
>         if (err) {
>                 if (errno == EINTR) goto retry3;
>                 hpmp_printf("rdma_get_cm_event() failed");
>                 return NULL;
>         }
> 
>         if (event->event != RDMA_CM_EVENT_ESTABLISHED) {
>                 hpmp_printf("rdma_get_cm_event() unexpected event (%d vs
> %d)"
>                                 "while connecting to %d\n",
>                                 event->event, RDMA_CM_EVENT_ESTABLISHED,
>                                 port);
>                 return NULL;
>         }
> 
> t2 =  MPI_Wtime();
> fprintf(stderr, "CONNECTION ESTABLISHED ON CONNECT %lf\n", t2-t1);
>         hpmp_rdmacm->rdma_ack_cm_event(event);
> 
> 
> 
> I get output such as:
> 
> [ 1] CONNECTION ESTABLISHED ON CONNECT 0.001447
> [ 9] CONNECTION ESTABLISHED ON CONNECT 6.145778
> [ 6] CONNECTION ESTABLISHED ON CONNECT 5.233660
> [ 0] CONNECTION ESTABLISHED ON CONNECT 0.001343
> [ 6] CONNECTION ESTABLISHED ON CONNECT 0.001155
> [ 7] CONNECTION ESTABLISHED ON CONNECT 4.517944
> [11] CONNECTION ESTABLISHED ON CONNECT 0.001445
> [ 3] CONNECTION ESTABLISHED ON CONNECT 0.001558
> [ 7] CONNECTION ESTABLISHED ON CONNECT 0.001627
> [ 5] CONNECTION ESTABLISHED ON CONNECT 6.145470
> [ 2] CONNECTION ESTABLISHED ON CONNECT 5.657639
> [ 9] CONNECTION ESTABLISHED ON CONNECT 0.001602
> [10] CONNECTION ESTABLISHED ON CONNECT 6.188743
> [ 1] CONNECTION ESTABLISHED ON CONNECT 0.001500
> [ 6] CONNECTION ESTABLISHED ON CONNECT 0.001061
> [ 1] CONNECTION ESTABLISHED ON CONNECT 0.001183
> [11] CONNECTION ESTABLISHED ON CONNECT 0.001213
> [ 5] CONNECTION ESTABLISHED ON CONNECT 0.210666

What version of Linux is this running?  Is the remote side responding to the connection request in a timely manner?  The connect call cannot complete until the remote side accepts the connection.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
