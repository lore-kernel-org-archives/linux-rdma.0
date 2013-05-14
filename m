From: Richard Graham <richardg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Extended ibv_send_wr
Date: Tue, 14 May 2013 14:26:30 +0000
Message-ID: <3D8F945A4E59E644AE9205E5CD3708E51893EC96@MTIDAG01.mtl.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Hefty, Sean <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> (sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org)" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org" <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: Tzahi Oved <tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Sean,
=A0 Enclosed is the specific modification to the ibv_sen_wr we are plan=
ning on submitting up stream.=A0 This is intended to support XRC, but t=
his also shows the modifications needed=A0 to support several additiona=
l features (such as the DC transport and cross-channel synchronization)=
, so these are added to put the proposed change in a better context.=A0=
 The rdma and atomic data structures are replicated, as the UD and Cros=
s-channel synchronization require both the transport type (UD) and a ta=
sk.

Comments are welcome,
Rich



struct ibv_send_wr {
=A0=A0=A0 uint64_t=A0=A0=A0=A0=A0=A0=A0 wr_id;
=A0=A0=A0 struct ibv_send_wr=A0=A0=A0=A0 *next;
=A0=A0=A0 struct ibv_sge=A0=A0=A0=A0=A0=A0=A0=A0 *sg_list;
=A0=A0=A0 int=A0=A0 =A0=A0=A0=A0=A0=A0num_sge;
=A0=A0=A0 enum ibv_wr_opcode=A0 opcode;
=A0=A0=A0 int send_flags;
=A0=A0=A0 uint32_t=A0=A0=A0=A0=A0=A0=A0 imm_data;=A0=A0 /* in network b=
yte order */
=A0=A0=A0 union {
=A0=A0=A0=A0=A0=A0=A0 struct {
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 uint64_t=A0=A0=A0 remote_addr;
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 uint32_t=A0=A0=A0 rkey;
=A0=A0=A0=A0=A0=A0=A0 } rdma;
=A0=A0=A0=A0=A0=A0=A0 struct {
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 uint64_t=A0=A0=A0 remote_addr;
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 uint64_t=A0=A0=A0 compare_add;
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 uint64_t=A0=A0=A0 swap;
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 uint32_t=A0=A0=A0 rkey;
=A0=A0=A0=A0=A0=A0=A0 } atomic;
=A0=A0=A0=A0=A0=A0=A0 struct {
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 struct ibv_ah=A0 *ah;
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 uint32_t=A0=A0=A0 remote_qpn;
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 uint32_t=A0=A0=A0 remote_qkey;
=A0=A0=A0=A0=A0=A0=A0 } ud;
=A0=A0=A0 } wr;
=A0=A0=A0 union {
=A0=A0=A0=A0=A0=A0=A0 struct {
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 uint32_t=A0=A0=A0 remote_=
srqn;
=A0=A0=A0=A0=A0=A0=A0 } xrc;
=A0=A0=A0=A0=A0=A0=A0 struct {
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 struct ibv_ah=A0 *ah;
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 uint64_t remote dct_acces=
s_key;
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 uint32_t=A0 dct_number;
=A0=A0=A0=A0=A0=A0=A0 }dc;
=A0=A0=A0 } qp_type;
=A0=A0=A0 /* CD stuff inline */
=A0=A0=A0 union{
=A0=A0=A0=A0=A0=A0=A0 struct {=A0=20
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
uint64_t=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 remote_addr;
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 u=
int32_t=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 rkey;
=A0=A0=A0=A0=A0=A0=A0 } rdma;
=A0=A0=A0=A0=A0=A0=A0 struct {
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0u=
int64_t=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 remote_addr;
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 u=
int64_t=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 compare_add;
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 u=
int64_t=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 swap;
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 u=
int32_t=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 rkey;
=A0=A0=A0=A0=A0=A0=A0 } atomic;
=A0=A0=A0=A0=A0=A0=A0 struct {
=A0=A0=A0=A0=A0=A0=A0=A0 =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0s=
truct ibv_cq=A0=A0=A0=A0=A0 *cq;
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 i=
nt32_t=A0 cq_count;
=A0=A0=A0=A0=A0=A0=A0 } cqe_wait;
=A0=A0=A0=A0=A0=A0=A0 struct {
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 s=
truct ibv_qp=A0=A0=A0=A0 *qp;
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 i=
nt32_t=A0 wqe_count;
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 e=
num comm_type;
=A0=A0=A0=A0=A0 =A0=A0} wqe_enable;
=A0=A0=A0 } task;
=A0=A0=A0 union{
=A0=A0=A0=A0=A0=A0=A0 struct{
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 enum verbs_core_direct_ops data_op=
;
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 enum verbs_wr_calc_op=A0=A0=A0=A0 =
calc_op;
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 enum verbs_wr_data_type=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 data_type;
=A0=A0=A0=A0=A0=A0=A0 } calc;
=A0=A0=A0 }op;
};

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
