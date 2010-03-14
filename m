From: Bernard Metzler <BMT-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>
Subject: Software iWARP stack
Date: Sun, 14 Mar 2010 17:37:59 +0100
Message-ID: <OF64DD5621.D563EA15-ONC12576E6.00510BE1-C12576E6.005B5E57@ch.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Bernard Metzler <BMT-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


We at IBM Zurich Laboratory are developing a full-software
iWARP stack to run within the OpenFabrics verbs framework.
Today we open sourced that work to be available at
http://gitorious.org/softiwarp. It consists of a kernel
module (siw) and a user level library (libsiw).

The Linux kernel module implements the iWARP protocol suite
(MPA/DDP/RDMAP, IETF-RFC 5044/5041/5040) completely in software.
Targeted for integration with OpenFabrics kernel interfaces,
it appears as a kernel module in the drivers/infiniband/hw
subdirectory of the Linux kernel. siw exports the OFA RDMA
verbs interface, currently useable only for user level
applications. The code assumes that connection management
is done via the OpenFabrics connection manager.
siw runs on top of TCP kernel sockets, which are used in
non-blocking mode. Current development work is done in Linux
kernel version 2.6.34-rc1.

libsiw implements user level access to the siw modules.
It attaches with the OpenFabrics user level verbs (libibvers)
and the OpenFabrics rdma connection manager (librdmacm).
It is tested to run in version 1.4.1 of OpenFabrics.


We belief that a software only implementation of the
iWARP protocol is beneficial for the wider acceptance
of the RDMA communication semantics for many reasons,
including:
o It allows low end systems to peer with RDMA hardware).
  equipped systems. This, conversely, makes the use of).
  RDMA hardware in loaded systems like servers a more
  interesting option.
o It eases the migration of existing non-RDMA solutions.
  to the RDMA model both at application and at network
  stack level.
o We expect that kernel clients like NSF and iSER can
  benefit from the existence of a software kernel RDMA
  stack.
o While potentially not running at the full speed of an.
  offloaded RDMA stack, the asynchronous and one-sided
  communication model of RDMA itself may give the application
  an advantage over running on plain sockets.
o The explicit communication buffer ownership management of
  RDMA enables the consistent implementation of user data copy
  avoidance techniques without hardware support.
o Last not least, softiwarp offers the application programmer
  access to a well-documented asynchronous communication interface
  w/o the need to install potentially expensive hardware.
  Asynchronous I/O may become a viable option.


We are making our work available under Dual License (BSD/Gnu) -
see the Copyright statement within the source code files for details.
Since the siw kernel module implements the iWARP protocol
suite of the IETF, we refer to the IPR page of the IETF
(http://www.ietf.org/ipr/).

We explicitely declare our work as 'work-in-progress'. We make
that work open source when its functionality and stability
still has some limitations (see IMPLEMENTATION.txt in the
infiniband/hw/softiwarp subdirectory). Some of the functional
limitations are not the result of lack of time and labor:
they are intentionally - we would like to discuss with the
Community how to architect it the most appropriate way.

We are completely open to any improvements of the code base
and in fact hope to help establishing a community contributing
to the improvement and completion of a software based RDMA
stack.

Thanks, Bernard.

--
Bernard Metzler, PhD
IBM Zurich Research Laboratory
S=E4umerstrasse 4
CH-8803 R=FCschlikon/Switzerland
bmt-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org
phone +41-44-7248605

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
