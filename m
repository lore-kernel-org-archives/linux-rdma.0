From: David Solt <dsolt-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: Fw: Announcing IBM Platform MPI 9.1.2.1 FixPack
Date: Tue, 6 May 2014 15:25:57 -0500
Message-ID: <OF4A39F4F6.9B304440-ON86257CD0.006F96D1-86257CD0.00703B71@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, David Solt <dsolt-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Resending as plain text for linux-rdma's sake:


From:   David Solt/Dallas/IBM
To:     sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, 
Cc:     Geoffrey Paulsen/Dallas/IBM@IBMUS, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Date:   05/02/2014 09:33 AM
Subject:        Re: Fw: Announcing IBM Platform MPI 9.1.2.1 FixPack


Hi Sean,

I am trying to add rdmacm support to Platform MPI.   I noticed that the 
performance on our test cluster was very poor for creating connections. 
For 12 processes on 12 hosts to create n^^2 connections takes about 12 
seconds.   I also discovered that if I create some TCP sockets and use 
those to ensure that only one process at a time is calling rdmacm_connect 
to any target at a time, that the performance changes dramatically and 
that I can then connected the 12 processes very quickly (didn't measure 
exactly, but similar to our old rdma code).    The order in which I am 
connecting processes avoids flooding a single target with many 
rdmacm_connects at once, but it is difficult to avoid the case where 2 
processes call dmacm_connect to the same target at roughly the same time 
except when using my extra TCP socket connections.   I haven't played with 
MPICH code yet to see if they have the same issue, but will try that next. 
 

Our test cluster is a bit old:

09:00.0 InfiniBand: Mellanox Technologies MT26428 [ConnectX VPI PCIe 2.0 
5GT/s - IB QDR / 10GigE] (rev b0) 

Is this a known problem?  Are you aware of any issues that would shed some 
light on this? 

Thanks,
Dave

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
