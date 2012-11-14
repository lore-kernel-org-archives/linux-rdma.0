From: Christopher Mitchell <christopher-1z5WdJkP5Frk1uMJSBkQmQ@public.gmane.org>
Subject: Sharing MR Between Multiple Connections
Date: Tue, 13 Nov 2012 23:36:16 -0500
Message-ID: <CAPb9-SHQ=r1MYu=771z2cTi9bAq=ueWMjw2vFDoSHbNByK5awA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi,

I am working on building an Infiniband application with a server that
can handle many simultaneous clients. The server exposes a chunk of
memory that each of the clients can read via RDMA. I was previously
creating a new MR on the server for each client (and of course in that
connection's PD). However, under stress testing, I realized that
ibv_reg_mr() started failing after I simultaneously MRed the same area
enough times to cover 20.0 GB. I presume that the problem is reaching
some pinning limit, although ulimit reports "unlimited" for all
relevant possibilities. I tried creating a single global PD and a
single MR to be shared among the multiple connections, but
rdma_create_qp() fails with an invalid argument when I try to do that.
I therefore deduce that the PD specified in rdma_create_qp() must
correspond to an active connection, not simply be created by opening a
device.

Long question short: is there any way I can share the same MR among
multiple clients, so that my shared memory region is limited to N
bytes instead of N/C (clients) bytes?

Thanks in advance,
Christopher

end
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
