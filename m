From: "Manoj Nambiar" <manoj_n09-kXrGd1YOZaxBDgjK7y7TUQ@public.gmane.org>
Subject: Problems with ibv_post_send and completion queues
Date: Wed, 19 Jan 2011 16:51:19 +0530
Message-ID: <B7FE0EF644764FF8A57CDD6065A0E0C2@01HW325222>
Reply-To: "Manoj Nambiar" <nambiar-EkmVulN54Sk@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed	reply-type=original
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi,

I am writing some rdma based programs using the Intel NetEffect iWARP N=
ICs.

I am running into the following problems with my code -

1.
I can only set maximum work requests to 510 using rdma_create_qp, other=
wise=20
it gives me an error =E2=80=93 =E2=80=9Clibnes: nes_ucreate_qp Bad sq a=
ttr parameters=20
max_send_wr=3D511 max_send_sge=3D1.
Is there a way to increase this?=E2=80=9D

2.
Is there a way to do RDMA writes without using a completion queue? I us=
e an=20
alternative channel to determine if my work requests were correctly exe=
cuted=20
or not. When I tried to do so I could send 510 (may be related to the=20
previous question) work requests successfully. After that ibv_post_send=
=20
returns 22. Repeatedly retrying ibv_post_send doesn=E2=80=99t seem to c=
lear the=20
problem. It returns the same error code. Checked up the error code whic=
h=20
tells me invalid arguments.? Unable to make sense of this.  Is there a =
way=20
to clean up the work requests in the system?

I am creating the queue pair with sq_sig_all =3D 0 in struct ibv_qp_ini=
t_attr=20
and am not setting setting IBV_SEND_SIGNALED in the send_flags member o=
f=20
struct ibv_send_wr. This means I do not get any completion events. When=
=20
calling rdma_create_qp I initialize the send_cq and recv_cq of the stru=
ct=20
ibv_qp_init_attr with the completion queue created using ibv_create_cq =
(with=20
cge parameter same as cap.max_send_wr in struct ibv_qp_init_attr. (I th=
ink=20
that creating a completion queue is a must for creating an rdma queue p=
air -=20
pls correct me if I am wrong.)

Pls note =E2=80=93 I do not get this problem when I poll completion que=
ues (when=20
rdma queue pair is created with sq_sig_all =3D 0 && IBV_SEND_SIGNALED s=
et in=20
the flag of the work requests to ibv_post_send)

Thanks,
Manoj Nambiar=20

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
