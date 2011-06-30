From: Benoit Hudzia <benoit.hudzia-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: kernel space rdma client, reg_mr issue
Date: Thu, 30 Jun 2011 15:19:01 +0100
Message-ID: <BANLkTi=+mFMHzoS9A=M1mW5pSjy8qdoV7Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: john stewart <john.stewart.kz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, jean-noel.gonzalez.de.linares-y6kNeMnOB+c@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi,

We are working to create a RDMA client within the kernel which will
connect to a working RDMA userspace server.
We are using the userspace code  for testing purpose , in the final
version all the communication will be done within the kernel space.

We rely on softiwarp so far for dev purpose.

We have achieved a connection but are now having trouble prior to the
communication stage.

We are trying to register a user space created buffer using the
device->reg_user_mr . However the kernel crash and the crash dump
shows a page fault after siw_reg_user_mr.


What we would like to know:

If this is the correct approach to register memory for RDMA
communication ? If yes what are we doing wrong ?
Is there a possibility to use kernel allocated memory rather than
using userspace created and then passing the address back to the
kernel through IOCTL ? ( if yes if there is any code example floating
around?)
basically the question boils down to how to allcoate and registr
buffer for RDMA communication from inside a kernel module?


=A0This is the code.

#######################################################################=
###############


struct rdma_cm_id *id =3D rdma_create_id(my_rdma_cm_event_handler
event_handler, NULL, RDMA_PS_TCP, IB_QPT_RC);
struct ib_pd *pd =3D ib_alloc_pd(id->device);
struct ib_cq *cq =3D ib_create_cq(id->device, NULL, NULL, NULL, 2, 0);

// Userspace buffer addresses passed via IOCTl
unsigned long user_buffer_send;=09
unsigned long user_buffer_recv;


int my_rdma_cm_event_handler event_handler(struct rdma_cm_id *id,
struct rdma_cm_event *event)
{

	switch (event)
	{
		case RDMA_CM_EVENT_ADDR_RESOLVED:

			rdma_resolve_route(id, 2000);

			break;

		case RDMA_CM_EVENT_ROUTE_RESOLVED:
		{

			struct ib_qp_init_attr attr;

			memset(&attr, 0, sizeof attr);

			attr.send_cq =3D cq;
			attr.recv_cq =3D cq;
			attr.sq_sig_type =3D IB_SIGNAL_ALL_WR;
			attr.cap.max_send_wr =3D 2;
			attr.cap.max_recv_wr =3D 2;
			attr.cap.max_send_sge =3D 1;
			attr.cap.max_recv_sge =3D 1;
			attr.qp_type =3D IB_QPT_RC;
			attr.port_num =3D id->port_num;
			attr.event_handler =3D my_qp_event_handler;

			rdma_create_qp(id, pd, &attr)

			rdma_connect(id, &conn_param);
=09
			break;
		}
		case RDMA_CM_EVENT_ESTABLISHED:
		{

			struct ib_mr *send_mr =3D id->device->reg_user_mr(pd, (u64)
user_buffer_send, sizeof *user_buffer_send, NULL,
									IB_ACCESS_LOCAL_WRITE | IB_ACCESS_REMOTE_READ |
IB_ACCESS_REMOTE_WRITE, NULL);

			struct ib_mr *recv_mr =3D id->device->reg_user_mr(pd, (u64)
user_buffer_recv, sizeof *user_buffer_recv, NULL,
									IB_ACCESS_LOCAL_WRITE | IB_ACCESS_REMOTE_READ |
IB_ACCESS_REMOTE_WRITE, NULL);

			break;
		}

	}

	...
}

#######################################################################=
###############

--
" The production of too many useful things results in too many useless =
people"
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
