From: "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 0/10] DAPL v2.0: support for MPI offloaded collectives via
 IB transport extensions
Date: Thu, 11 Aug 2011 00:41:06 +0000
Message-ID: <54347E5A035A054EAE9D05927FB467F916E41B0B@FMSMSX151.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>, "ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The collective extensions are designed to support MPI and general
multicast operations over IB fabrics that support offloaded collectives.
Where feasible, they come as close to MPI semantics as possible.
Unless otherwise stated, all members participating in a data collective
operation must call the associated collective routine for the data
transfer operation to complete. Unless otherwise stated, the
root collective member of a data operation will receive its own portion
of the collective data. In most cases, the root member can prevent
sending/receiving data when such operations would be redundant. When root
data is already "in place" the root member may set the send and/or receive
buffer pointer argument to NULL.

Unlike standard DAPL movement operations that require registered
memory and LMR objects, collective data movement operations employ
pointers to user-virtual address space that do not require
pre-registration by the application. From a resource usage point
of view, the API user should consider that the provider implementation
my perform memory registrations/deregistration on behalf of the
application to accomplish a data transfer.

Most collective calls are asynchronous. Upon completion, an event
will be posted to the EVD specified when the collective was created.

New collective driver for Mellanox FCA 2.1 on ConnectX-2 adapters is included
with this patch set and is supported via all IB providers (cma, ucm, scm).

See the following document for API details:

http://www.openfabrics.org/downloads/dapl/documentation/dat_collective_preview.pdf


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
