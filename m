From: "Amrani, Ram" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Subject: Issues Building krping on RHEL 7.2
Date: Sun, 5 Mar 2017 17:53:41 +0000
Message-ID: <DM3PR07MB22010C36EE6B652B1AA1356FF82D0@DM3PR07MB2201.namprd07.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Steve,
Are you the maintainer of krping?
I've tried to build krping from https://github.com/larrystevenwise/krping.g=
it.
But I get multiple errors.
I guess I'm missing something simple.

i.e. -
0. RHEL 7.2 with INBOX OFED (tried also newer kernels)
1. git clone https://github.com/larrystevenwise/krping.git
2. vim Makefile and have 'KSRC=3D/usr/src/kernels/3.10.0-327.el7.x86_64/'
3. Make

And I get all the errors below.

Any clue?

Thanks,
Ram


[root@lbtlvb-pcie120 krping]# ll /usr/src/kernels/
total 4
drwxr-xr-x. 22 root root 4096 Jan 10 08:27 3.10.0-327.el7.x86_64
 [root@lbtlvb-pcie120 krping]# cat /etc/redhat-release=20
Red Hat Enterprise Linux Server release 7.2 (Maipo)
[root@lbtlvb-pcie120 krping]# ofed_info -s
-bash: ofed_info: command not found=20


[root@lbtlvb-pcie120 krping]# make
make -C /usr/src/kernels/3.10.0-327.el7.x86_64/ M=3D`pwd` modules
make[1]: Entering directory `/usr/src/kernels/3.10.0-327.el7.x86_64'
  CC [M]  /usr/qlc/il_proj/ctl_sw/ramrani/git/krping/getopt.o
  CC [M]  /usr/qlc/il_proj/ctl_sw/ramrani/git/krping/krping.o
/usr/qlc/il_proj/ctl_sw/ramrani/git/krping/krping.c:182:19: error: field 'r=
eg_mr_wr' has incomplete type
  struct ib_reg_wr reg_mr_wr;
                   ^
/usr/qlc/il_proj/ctl_sw/ramrani/git/krping/krping.c:201:20: error: field 'r=
dma_sq_wr' has incomplete type
  struct ib_rdma_wr rdma_sq_wr; /* rdma work request record */
                    ^
/usr/qlc/il_proj/ctl_sw/ramrani/git/krping/krping.c: In function 'krping_se=
tup_wr':
/usr/qlc/il_proj/ctl_sw/ramrani/git/krping/krping.c:479:28: error: 'struct =
ib_pd' has no member named 'local_dma_lkey'
  cb->recv_sgl.lkey =3D cb->pd->local_dma_lkey;
                            ^
/usr/qlc/il_proj/ctl_sw/ramrani/git/krping/krping.c:485:28: error: 'struct =
ib_pd' has no member named 'local_dma_lkey'
  cb->send_sgl.lkey =3D cb->pd->local_dma_lkey;
                            ^
/usr/qlc/il_proj/ctl_sw/ramrani/git/krping/krping.c:504:28: error: 'IB_WR_R=
EG_MR' undeclared (first use in this function)
  cb->reg_mr_wr.wr.opcode =3D IB_WR_REG_MR;
                            ^
/usr/qlc/il_proj/ctl_sw/ramrani/git/krping/krping.c:504:28: note: each unde=
clared identifier is reported only once for each function it appears in
/usr/qlc/il_proj/ctl_sw/ramrani/git/krping/krping.c: In function 'krping_se=
tup_buffers':
/usr/qlc/il_proj/ctl_sw/ramrani/git/krping/krping.c:539:2: error: implicit =
declaration of function 'ib_alloc_mr' [-Werror=3Dimplicit-function-declarat=
ion]
  cb->reg_mr =3D ib_alloc_mr(cb->pd,  IB_MR_TYPE_MEM_REG,
  ^
/usr/qlc/il_proj/ctl_sw/ramrani/git/krping/krping.c:539:36: error: 'IB_MR_T=
YPE_MEM_REG' undeclared (first use in this function)
  cb->reg_mr =3D ib_alloc_mr(cb->pd,  IB_MR_TYPE_MEM_REG,
                                    ^
/usr/qlc/il_proj/ctl_sw/ramrani/git/krping/krping.c: In function 'krping_se=
tup_qp':
/usr/qlc/il_proj/ctl_sw/ramrani/git/krping/krping.c:657:2: error: too many =
arguments to function 'ib_alloc_pd'
  cb->pd =3D ib_alloc_pd(cm_id->device, 0);
  ^
In file included from /usr/qlc/il_proj/ctl_sw/ramrani/git/krping/krping.c:5=
5:0:
include/rdma/ib_verbs.h:2146:15: note: declared here
 struct ib_pd *ib_alloc_pd(struct ib_device *device);
               ^
/usr/qlc/il_proj/ctl_sw/ramrani/git/krping/krping.c: In function 'krping_rd=
ma_rkey':
/usr/qlc/il_proj/ctl_sw/ramrani/git/krping/krping.c:727:2: error: implicit =
declaration of function 'ib_map_mr_sg' [-Werror=3Dimplicit-function-declara=
tion]
  ret =3D ib_map_mr_sg(cb->reg_mr, &sg, 1, NULL, PAGE_SIZE);
  ^
/usr/qlc/il_proj/ctl_sw/ramrani/git/krping/krping.c:734:13: error: 'struct =
ib_mr' has no member named 'page_size'
   cb->reg_mr->page_size,
             ^
/usr/qlc/il_proj/ctl_sw/ramrani/git/krping/krping.c:735:13: error: 'struct =
ib_mr' has no member named 'length'
   cb->reg_mr->length,
             ^
/usr/qlc/il_proj/ctl_sw/ramrani/git/krping/krping.c:736:13: error: 'struct =
ib_mr' has no member named 'iova'
   cb->reg_mr->iova);
             ^
/usr/qlc/il_proj/ctl_sw/ramrani/git/krping/krping.c: In function 'krping_te=
st_server':
/usr/qlc/il_proj/ctl_sw/ramrani/git/krping/krping.c:863:30: error: 'struct =
ib_pd' has no member named 'local_dma_lkey'
    cb->rdma_sgl.lkey =3D cb->pd->local_dma_lkey;
                              ^
/usr/qlc/il_proj/ctl_sw/ramrani/git/krping/krping.c: In function 'reg_suppo=
rted':
/usr/qlc/il_proj/ctl_sw/ramrani/git/krping/krping.c:1361:10: error: 'struct=
 ib_device' has no member named 'attrs'
  if ((dev->attrs.device_cap_flags & needed_flags) !=3D needed_flags) {
          ^
/usr/qlc/il_proj/ctl_sw/ramrani/git/krping/krping.c:1364:12: error: 'struct=
 ib_device' has no member named 'attrs'
    (u64)dev->attrs.device_cap_flags);
            ^
/usr/qlc/il_proj/ctl_sw/ramrani/git/krping/krping.c:1368:11: error: 'struct=
 ib_device' has no member named 'attrs'
   (u64)dev->attrs.device_cap_flags);
           ^
/usr/qlc/il_proj/ctl_sw/ramrani/git/krping/krping.c: In function 'krping_fr=
_test':
/usr/qlc/il_proj/ctl_sw/ramrani/git/krping/krping.c:1766:19: error: storage=
 size of 'fr' isn't known
  struct ib_reg_wr fr;
                   ^
/usr/qlc/il_proj/ctl_sw/ramrani/git/krping/krping.c:1778:27: error: 'IB_MR_=
TYPE_MEM_REG' undeclared (first use in this function)
  mr =3D ib_alloc_mr(cb->pd, IB_MR_TYPE_MEM_REG, plen);
                           ^
/usr/qlc/il_proj/ctl_sw/ramrani/git/krping/krping.c:1793:17: error: 'IB_WR_=
REG_MR' undeclared (first use in this function)
  fr.wr.opcode =3D IB_WR_REG_MR;
                 ^
/usr/qlc/il_proj/ctl_sw/ramrani/git/krping/krping.c:1766:19: warning: unuse=
d variable 'fr' [-Wunused-variable]
  struct ib_reg_wr fr;
                   ^
/usr/qlc/il_proj/ctl_sw/ramrani/git/krping/krping.c: In function 'krping_do=
it':
/usr/qlc/il_proj/ctl_sw/ramrani/git/krping/krping.c:2107:2: warning: passin=
g argument 1 of 'rdma_create_id' from incompatible pointer type [enabled by=
 default]
  cb->cm_id =3D rdma_create_id(&init_net, krping_cma_event_handler, cb, RDM=
A_PS_TCP, IB_QPT_RC);
  ^
In file included from /usr/qlc/il_proj/ctl_sw/ramrani/git/krping/krping.c:5=
6:0:
include/rdma/rdma_cm.h:169:20: note: expected 'rdma_cm_event_handler' but a=
rgument is of type 'struct net *'
 struct rdma_cm_id *rdma_create_id(rdma_cm_event_handler event_handler,
                    ^
/usr/qlc/il_proj/ctl_sw/ramrani/git/krping/krping.c:2107:2: error: incompat=
ible type for argument 3 of 'rdma_create_id'
  cb->cm_id =3D rdma_create_id(&init_net, krping_cma_event_handler, cb, RDM=
A_PS_TCP, IB_QPT_RC);
  ^
In file included from /usr/qlc/il_proj/ctl_sw/ramrani/git/krping/krping.c:5=
6:0:
include/rdma/rdma_cm.h:169:20: note: expected 'enum rdma_port_space' but ar=
gument is of type 'struct krping_cb *'
 struct rdma_cm_id *rdma_create_id(rdma_cm_event_handler event_handler,
                    ^
/usr/qlc/il_proj/ctl_sw/ramrani/git/krping/krping.c:2107:2: error: too many=
 arguments to function 'rdma_create_id'
  cb->cm_id =3D rdma_create_id(&init_net, krping_cma_event_handler, cb, RDM=
A_PS_TCP, IB_QPT_RC);
  ^
In file included from /usr/qlc/il_proj/ctl_sw/ramrani/git/krping/krping.c:5=
6:0:
include/rdma/rdma_cm.h:169:20: note: declared here
 struct rdma_cm_id *rdma_create_id(rdma_cm_event_handler event_handler,
                    ^
cc1: some warnings being treated as errors
make[2]: *** [/usr/qlc/il_proj/ctl_sw/ramrani/git/krping/krping.o] Error 1
make[1]: *** [_module_/usr/qlc/il_proj/ctl_sw/ramrani/git/krping] Error 2
make[1]: Leaving directory `/usr/src/kernels/3.10.0-327.el7.x86_64'
make: *** [default] Error 2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
