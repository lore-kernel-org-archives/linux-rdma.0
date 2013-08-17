From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: =?UTF-8?Q?ibv=5Fcreate=5Fqp=28=29=20and=20max=5Finline=5Fdata=20b?=
 =?UTF-8?Q?ehavior?=
Date: Sat, 17 Aug 2013 14:22:06 +0200
Message-ID: <d7685e13978f93890b2939c5ac2d5c7f@meuh.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Dotan Barak <dotanba-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, dotan-Hqos5LYUzRNWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi,

I'm facing a little odd behavior when trying to use IBV_SEND_INLINE fla=
g=20
in ibv_post_send().

I'm testing with QLogic InfiniPath HCA / Intel True Scale Fabric HCA,
QLE7340-CK, QL7342-CK, using driver ipath (libipathverbs), module qib,
on Fedora 18, Fedora 19 with kernel v3.11-rc5,
using libipathverbs 1.2,
       libibverbs 1.1.17
       librdmacm 1.0.17.

The test program creates a QP using ibv_create_qp() and=20
init_attr.cap.max_inline_data set to 16.
The QP creation is OK but init_attr.cap.max_inline_data is set to 0 on=20
return.

According to man page: http://linux.die.net/man/3/ibv_create_qp
                       =20
http://git.kernel.org/cgit/libs/infiniband/libibverbs.git/tree/man/ibv_=
create_qp.3

     The function ibv_create_qp() will update the qp_init_attr->cap=20
struct with the actual QP values
     of the QP that was created; the values will be greater than or equ=
al=20
to the values requested.

According to Dotan blog:=20
http://www.rdmamojo.com/2012/12/21/ibv_create_qp/

     max_inline_data  The maximum message size (in bytes) that can be=20
posted inline to the Send Queue.
                      0, if no inline message is requested

     Sending inline=E2=80=99d data is an implementation extension that =
isn=E2=80=99t=20
defined in any RDMA specification:
     it allows send the data itself in the Work Request (instead the=20
scatter/gather entries)
     that is posted to the RDMA device. The memory that holds this=20
message doesn=E2=80=99t have to be registered.
     There isn=E2=80=99t any verb that specifies the maximum message si=
ze that=20
can be sent inline=E2=80=99d in a QP.
     Some of the RDMA devices support it. In some RDMA devices creating=
 a=20
QP with will set the value of max_inline_data
     to the size of message that can be sent using the requested number=
=20
of scatter/gather elements of the Send Queue.
     If others, one should specify explicitly the message size to be se=
nt=20
inline before the creation of a QP.
     [F]or those devices, it is advised to try to create the QP with th=
e=20
required message size and continue decrease it
     if the QP creation fails.


I'd like the behavior of ibv_create_qp() regarding cap.max_inline_data=20
be clearer:

1) Should ibv_create_qp() failed if max_inline_data requested being=20
greater than supported ?

If not

2) Should ibv_create_qp() be allowed to return a value less than the=20
value requested ?

The fix would be different:

1) will require a small change to __ibv_create_qp() to enforce this=20
behavor.

2) will only require a small update to the documentation to allow=20
max_inline_data to be lower than requested.


Regards.

--=20
Yann Droneaud
OPTEYA

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
