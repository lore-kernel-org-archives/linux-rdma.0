From: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [RFC] Avoid running out of local port in RDMA_CM
Date: Tue, 22 Nov 2016 12:12:29 +0200
Message-ID: <CAG9sBKMMuj5Qf7_jgL_EAwOAVAFZCp5Wf=NytqsHAezrys97pA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Introduction
--------------------------------------------------------------------------------
Like TCP/IP sockets, RDMA_CM connection identifier (rdma_id) is associated with
local and remote addresses and local and remote ports. Values for
these attributes
are assigned during the life cycle of the rdma_id. In this RFC we focus on the
value that is given to the local port of the rdma_id.
While in TCP/IP protocol port numbers are part of the transport header, in
InfiniBand they don't have a place. The way for an application to connect to
a specific service is to use the communication manager and use a known Service
ID (see CHAPTER 12:COMMUNICATION MANAGEMENT in the InfiniBandTM Architecture
Specification Volume 1). The RDMA IP CM Service, which provides support for
a socket-like connection model for RDMA-aware ULPs, replaces the
Service ID with a
16 bit port number which is used as an identifier for a service.

The problem
--------------------------------------------------------------------------------
RDMA_CM requires binding of a connection identifier (rdma_id) to a local port.
The passive side, the one calling rdma_listen(), usually binds explicitly to a
well-known port. The active side, the one calling rmda_connect(),
binds implicitly
to a random port that rdma_cm chooses for it. This makes sense if we
keep in mind
that the port number is a way to identify a service. Binding to a port
removes it
from the pool of available ports until the rdma_id is destroyed at
which time the
port is returned to the pool. The problem starts when number of
rdma_ids is larger
than the number of available ports. The most likely scenario for this
to happen is a
node with many clients trying to connect to remote services. When the
available port
pool is empty the call to rdma_resolve_addr() fails when a free port
number is requested
from the pool.

Suggested Solution
--------------------------------------------------------------------------------
Extending the size of the pool is out of the question since we must to keep the
16 bit width of the port number to avoid backward compatibility issues.
1. Port number is a parameter to the function that generates Service ID.
2. Port number is part of the private data of the request MAD (see Annex
   A11: RDMA IP CM Service in the InfiniBandTM Architecture
Specification Volume 1)
The other alternative is to reuse port numbers. Since port numbers are
not part of the
InfiniBand transport header we don't need to worry about wire protocol
issues. Also,
since binding to a port  on the active side doesn't create a conflict in service
identification (since no one listens to active side rdma_id), it is
safe to reuse a
port number there when the port pool is empty.
The suggested solution is to reserve one port as a global port for
reuse and assign
it under the following conditions
1. The request for binding is implicit and for any port (via
cma_alloc_any_port())
2. The pool is empty
3. The ULP allows it

Risks
--------------------------------------------------------------------------------
RDMA_CM puts the local port number in the private data section of the CM request
MAD. If this field is observed by an application or a traffic analyzer there
might be a confusion. A way to minimize the risk is to reuse a port only if
application allows it (say by setting an option to the rdma_id)
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
