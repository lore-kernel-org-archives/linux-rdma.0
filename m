From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: RDMA Read: Local protection error
Date: Fri, 29 Apr 2016 12:24:19 -0400
Message-ID: <1A4F4C32-CE5A-44D9-9BFE-0E1F8D5DF44D@oracle.com>
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

I've found some new behavior, recently, while testing the
v4.6-rc Linux NFS/RDMA client and server.

When certain kernel memory debugging CONFIG options are
enabled, 1MB NFS WRITEs can sometimes result in a
IB_WC_LOC_PROT_ERR. I usually turn on most of them because
I want to see any problems, so I'm not sure which option
in particular is exposing the issue.

When debugging is enabled on the server, and the underlying
device is using FRWR to register the sink buffer, an RDMA
Read occasionally completes with LOC_PROT_ERR.

When debugging is enabled on the client, and the underlying
device uses FRWR to register the target of an RDMA Read, an
ingress RDMA Read request sometimes gets a Syndrome 99
(REM_OP_ERR) acknowledgement, and a subsequent RDMA Receive
on the client completes with LOC_PROT_ERR.

I do not see this problem when kernel memory debugging is
disabled, or when the client is using FMR, or when the
server is using physical addresses to post its RDMA Read WRs,
or when wsize is 512KB or smaller.

I have not found any obvious problems with the client logic
that registers NFS WRITE buffers, nor the server logic that
constructs and posts RDMA Read WRs.

My next step is to bisect. But first, I was wondering if
this behavior might be related to the recent problems with
s/g lists seen with iSER/SRP? ie, is this a recognized
issue?


--
Chuck Lever



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
