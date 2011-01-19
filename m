From: "Manoj Nambiar" <manoj_n09-kXrGd1YOZaxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: Problems with ibv_post_send and completion queues
Date: Wed, 19 Jan 2011 19:33:07 +0530
Message-ID: <E130CB711EF24E5D9789DF505C3BD452@01HW325222>
References: <B7FE0EF644764FF8A57CDD6065A0E0C2@01HW325222> <BE2BFE91933D1B4089447C644860408066F493BE@irsmsx503.ger.corp.intel.com>
Reply-To: "Manoj Nambiar" <nambiar-EkmVulN54Sk@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed	reply-type=original
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <BE2BFE91933D1B4089447C644860408066F493BE-IGOiFh9zz4wLt2AQoY/u9bfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Walukiewicz, Miroslaw" <Miroslaw.Walukiewicz-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Thanks for the clarifications Mark. That settles it.

Manoj Nambiar

-----Original Message-----=20
=46rom: Walukiewicz, Miroslaw
Sent: Wednesday, January 19, 2011 6:51 PM
To: Manoj Nambiar ; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Subject: RE: Problems with ibv_post_send and completion queues

Hello Manoj,

Responding to your questions.
1. the 510 is HW max for QP length for NE020 card so it cannot be incre=
ased.

2. The NE020 driver keeps posted buffers on the FIFO-like queue which i=
s 510=20
entries long in your application.
There are maintained tail and head pointers that does not allow for QP=20
overflow. The head pointer is updated during post_send and tail is upda=
ted=20
during poll_cq on CQ assigned to your QP. When you make post_sends with=
out=20
checking cq the tail pointer is not updated so after 510 post_send call=
s the=20
QP looks being full for driver and in effect you cannot send more data =
using=20
that QP.

Regards,

Mirek

-----Original Message-----
=46rom: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org=20
[mailto:linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Manoj Nambiar
Sent: Wednesday, January 19, 2011 12:21 PM
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Subject: Problems with ibv_post_send and completion queues

Hi,

I am writing some rdma based programs using the Intel NetEffect iWARP N=
ICs.

I am running into the following problems with my code -

1.
I can only set maximum work requests to 510 using rdma_create_qp, other=
wise
it gives me an error =E2=80=93 =E2=80=9Clibnes: nes_ucreate_qp Bad sq a=
ttr parameters
max_send_wr=3D511 max_send_sge=3D1.
Is there a way to increase this?=E2=80=9D

2.
Is there a way to do RDMA writes without using a completion queue? I us=
e an
alternative channel to determine if my work requests were correctly exe=
cuted
or not. When I tried to do so I could send 510 (may be related to the
previous question) work requests successfully. After that ibv_post_send
returns 22. Repeatedly retrying ibv_post_send doesn=E2=80=99t seem to c=
lear the
problem. It returns the same error code. Checked up the error code whic=
h
tells me invalid arguments.? Unable to make sense of this.  Is there a =
way
to clean up the work requests in the system?

I am creating the queue pair with sq_sig_all =3D 0 in struct ibv_qp_ini=
t_attr
and am not setting setting IBV_SEND_SIGNALED in the send_flags member o=
f
struct ibv_send_wr. This means I do not get any completion events. When
calling rdma_create_qp I initialize the send_cq and recv_cq of the stru=
ct
ibv_qp_init_attr with the completion queue created using ibv_create_cq =
(with
cge parameter same as cap.max_send_wr in struct ibv_qp_init_attr. (I th=
ink
that creating a completion queue is a must for creating an rdma queue p=
air -
pls correct me if I am wrong.)

Pls note =E2=80=93 I do not get this problem when I poll completion que=
ues (when
rdma queue pair is created with sq_sig_all =3D 0 && IBV_SEND_SIGNALED s=
et in
the flag of the work requests to ibv_post_send)

Thanks,
Manoj Nambiar

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
N=EF=BF=BD=EF=BF=BD=EF=BF=BDr=EF=BF=BDy=EF=BF=BD=EF=BF=BD=D8=B2X=EF=BF=BD=
=EF=BF=BDv=D8=96)=EF=BF=BD{n=C7=89=EF=BF=BD=EF=BF=BD{=EF=BF=BD=D9=8A{y=EF=
=BF=BD=CA=87=EF=BF=BD=EF=BF=BDj=07=EF=BF=BDf=EF=BF=BD=EF=BF=BD=EF=BF=BD=
=EF=BF=BDz=EF=BF=BD=EF=BF=BDw=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BDj:v=EF=
=BF=BD=EF=BF=BDwj=D8=B6=EF=BF=BD=EF=BF=BD=07=EF=BF=BD=EF=BF=BDzZ=EF=BF=BD=
=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BDj=EF=BF=BD=EF=BF=BD=20

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
