From: David Solt <dsolt-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: RE: Announcing IBM Platform MPI 9.1.2.1 FixPack
Date: Tue, 6 May 2014 21:28:45 -0500
Message-ID: <OF33DE6020.C2F63AB6-ON86257CD1.000D2DD2-86257CD1.000D9C90@us.ibm.com>
References: <OF4A39F4F6.9B304440-ON86257CD0.006F96D1-86257CD0.00703B71@us.ibm.com> <1828884A29C6694DAF28B7E6B8A82373992F8E3E@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373992F8E3E-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Yes, the delay seems to be coming here:

        err = hpmp_rdmacm->rdma_connect(id, NULL);
        if (err) {
                hpmp_printf("rdma_connect() failed");
                return NULL;
        }
t1 = MPI_Wtime();

retry3:
        err = 
hpmp_rdmacm->rdma_get_cm_event(hpmp_rdmacm->connect_cm_channel, &event);
        if (err) {
                if (errno == EINTR) goto retry3;
                hpmp_printf("rdma_get_cm_event() failed");
                return NULL;
        }

        if (event->event != RDMA_CM_EVENT_ESTABLISHED) {
                hpmp_printf("rdma_get_cm_event() unexpected event (%d vs 
%d)"
                                "while connecting to %d\n",
                                event->event, RDMA_CM_EVENT_ESTABLISHED,
                                port);
                return NULL;
        }

t2 =  MPI_Wtime();
fprintf(stderr, "CONNECTION ESTABLISHED ON CONNECT %lf\n", t2-t1);
        hpmp_rdmacm->rdma_ack_cm_event(event);



I get output such as:

[ 1] CONNECTION ESTABLISHED ON CONNECT 0.001447
[ 9] CONNECTION ESTABLISHED ON CONNECT 6.145778
[ 6] CONNECTION ESTABLISHED ON CONNECT 5.233660
[ 0] CONNECTION ESTABLISHED ON CONNECT 0.001343
[ 6] CONNECTION ESTABLISHED ON CONNECT 0.001155
[ 7] CONNECTION ESTABLISHED ON CONNECT 4.517944
[11] CONNECTION ESTABLISHED ON CONNECT 0.001445
[ 3] CONNECTION ESTABLISHED ON CONNECT 0.001558
[ 7] CONNECTION ESTABLISHED ON CONNECT 0.001627
[ 5] CONNECTION ESTABLISHED ON CONNECT 6.145470
[ 2] CONNECTION ESTABLISHED ON CONNECT 5.657639
[ 9] CONNECTION ESTABLISHED ON CONNECT 0.001602
[10] CONNECTION ESTABLISHED ON CONNECT 6.188743
[ 1] CONNECTION ESTABLISHED ON CONNECT 0.001500
[ 6] CONNECTION ESTABLISHED ON CONNECT 0.001061
[ 1] CONNECTION ESTABLISHED ON CONNECT 0.001183
[11] CONNECTION ESTABLISHED ON CONNECT 0.001213
[ 5] CONNECTION ESTABLISHED ON CONNECT 0.210666









From:   "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
To:     David Solt/Dallas/IBM@IBMUS, 
Cc:     "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Date:   05/06/2014 03:48 PM
Subject:        RE: Announcing IBM Platform MPI 9.1.2.1 FixPack



> I am trying to add rdmacm support to Platform MPI.   I noticed that the
> performance on our test cluster was very poor for creating connections.
> For 12 processes on 12 hosts to create n^^2 connections takes about 12
> seconds.   I also discovered that if I create some TCP sockets and use
> those to ensure that only one process at a time is calling 
rdmacm_connect
> to any target at a time, that the performance changes dramatically and
> that I can then connected the 12 processes very quickly (didn't measure
> exactly, but similar to our old rdma code).    The order in which I am
> connecting processes avoids flooding a single target with many
> rdmacm_connects at once, but it is difficult to avoid the case where 2
> processes call dmacm_connect to the same target at roughly the same time
> except when using my extra TCP socket connections.   I haven't played 
with
> MPICH code yet to see if they have the same issue, but will try that 
next.
> 
> 
> Our test cluster is a bit old:
> 
> 09:00.0 InfiniBand: Mellanox Technologies MT26428 [ConnectX VPI PCIe 2.0
> 5GT/s - IB QDR / 10GigE] (rev b0)
> 
> Is this a known problem?  Are you aware of any issues that would shed 
some
> light on this?

This is the first I've heard of slow connect times.  Are you sure that the 
time is coming from rdma_connect, versus route or address resolution?



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
