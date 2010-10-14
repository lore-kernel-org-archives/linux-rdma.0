From: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC 2/2] IB/umad: Export mad snooping capability to userspace
Date: Thu, 14 Oct 2010 09:02:32 -0400
Message-ID: <AANLkTimGjm9ZzWsav91CHSqgftxTzZW3iZN1fAp+EWd5@mail.gmail.com>
References: <CF9C39F99A89134C9CF9C4CCB68B8DDF25B7DAA129@orsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CF9C39F99A89134C9CF9C4CCB68B8DDF25B7DAA129-osO9UTpF0USkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Linux RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Sean,

Some minor comments below.

On Tue, Oct 12, 2010 at 3:13 PM, Hefty, Sean <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wro=
te:
> Export the mad snooping capability to user space clients
> through the existing umad interface. =C2=A0This will allow
> users to capture MAD data for debugging, plus it allows
> for services to act on MAD traffic that occurs.

Should it also be noted that snooping of RMPP'd MADs occurs at the
reassembled packet level with the last header being indicated ?

> For example,
> a daemon could snoop SA queries and CM messages as part of
> providing a path record caching service. =C2=A0(It could cached
> snooped path records, record the average time needed for the
> SA to respond to queries, use CM timeouts as an indication
> that cached data may be stale, etc.)
>
> Because such services may become crucial to support large
> clusters, mad snooping capabilities are not limited to
> a debugging interface.
>
> Backwards compatibility is maintained by using the upper bit
> of the QPN to indicate if a user is registering to send/receive
> MADs or only wishes to snoop traffic.

See below for comment on this.

> Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---
> =C2=A0drivers/infiniband/core/user_mad.c | =C2=A0134 ++++++++++++++++=
++++++++++++++------
> =C2=A0include/rdma/ib_user_mad.h =C2=A0 =C2=A0 =C2=A0 =C2=A0 | =C2=A0=
 33 ++++++++-
> =C2=A02 files changed, 143 insertions(+), 24 deletions(-)
>
> diff --git a/drivers/infiniband/core/user_mad.c b/drivers/infiniband/=
core/user_mad.c
> index 5fa8569..e666038 100644
> --- a/drivers/infiniband/core/user_mad.c
> +++ b/drivers/infiniband/core/user_mad.c
> @@ -252,6 +252,80 @@ err1:
> =C2=A0 =C2=A0 =C2=A0 =C2=A0ib_free_recv_mad(mad_recv_wc);
> =C2=A0}
>
> +static void snoop_send_handler(struct ib_mad_agent *agent,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0struct ib_mad_send_wc *send_wc)
> +{
> + =C2=A0 =C2=A0 =C2=A0 struct ib_umad_file *file =3D agent->context;
> + =C2=A0 =C2=A0 =C2=A0 struct ib_umad_packet *packet;
> + =C2=A0 =C2=A0 =C2=A0 struct ib_mad_send_buf *msg =3D send_wc->send_=
buf;
> + =C2=A0 =C2=A0 =C2=A0 struct ib_rmpp_mad *rmpp_mad;
> + =C2=A0 =C2=A0 =C2=A0 int data_len;
> + =C2=A0 =C2=A0 =C2=A0 u32 seg_num;
> +
> + =C2=A0 =C2=A0 =C2=A0 data_len =3D msg->seg_count ? msg->seg_size : =
msg->data_len;
> + =C2=A0 =C2=A0 =C2=A0 packet =3D kzalloc(sizeof *packet + msg->hdr_l=
en + data_len, GFP_KERNEL);
> + =C2=A0 =C2=A0 =C2=A0 if (!packet)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return;
> +
> + =C2=A0 =C2=A0 =C2=A0 packet->length =3D msg->hdr_len + data_len;
> + =C2=A0 =C2=A0 =C2=A0 packet->mad.hdr.status =3D send_wc->status;
> + =C2=A0 =C2=A0 =C2=A0 packet->mad.hdr.timeout_ms =3D msg->timeout_ms=
;
> + =C2=A0 =C2=A0 =C2=A0 packet->mad.hdr.retries =3D msg->retries;
> + =C2=A0 =C2=A0 =C2=A0 packet->mad.hdr.length =3D hdr_size(file) + pa=
cket->length;
> +
> + =C2=A0 =C2=A0 =C2=A0 if (msg->seg_count) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 rmpp_mad =3D msg->=
mad;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 seg_num =3D be32_t=
o_cpu(rmpp_mad->rmpp_hdr.seg_num);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 memcpy(packet->mad=
=2Edata, msg->mad, msg->hdr_len);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 memcpy(((u8 *) pac=
ket->mad.data) + msg->hdr_len,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0ib_get_rmpp_segment(msg, seg_num), data_len);
> + =C2=A0 =C2=A0 =C2=A0 } else {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 memcpy(packet->mad=
=2Edata, msg->mad, packet->length);
> + =C2=A0 =C2=A0 =C2=A0 }
> +
> + =C2=A0 =C2=A0 =C2=A0 if (queue_packet(file, agent, packet))
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 kfree(packet);
> +}
> +
> +static void snoop_recv_handler(struct ib_mad_agent *agent,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0struct ib_mad_recv_wc *mad_recv_wc)
> +{
> + =C2=A0 =C2=A0 =C2=A0 struct ib_umad_file *file =3D agent->context;
> + =C2=A0 =C2=A0 =C2=A0 struct ib_umad_packet *packet;
> + =C2=A0 =C2=A0 =C2=A0 struct ib_mad_recv_buf *recv_buf =3D &mad_recv=
_wc->recv_buf;
> +
> + =C2=A0 =C2=A0 =C2=A0 packet =3D kzalloc(sizeof *packet + sizeof *re=
cv_buf->mad, GFP_KERNEL);
> + =C2=A0 =C2=A0 =C2=A0 if (!packet)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return;
> +
> + =C2=A0 =C2=A0 =C2=A0 packet->length =3D sizeof *recv_buf->mad;
> + =C2=A0 =C2=A0 =C2=A0 packet->mad.hdr.length =3D hdr_size(file) + pa=
cket->length;
> + =C2=A0 =C2=A0 =C2=A0 packet->mad.hdr.qpn =3D cpu_to_be32(mad_recv_w=
c->wc->src_qp);
> + =C2=A0 =C2=A0 =C2=A0 packet->mad.hdr.lid =3D cpu_to_be16(mad_recv_w=
c->wc->slid);
> + =C2=A0 =C2=A0 =C2=A0 packet->mad.hdr.sl =3D mad_recv_wc->wc->sl;
> + =C2=A0 =C2=A0 =C2=A0 packet->mad.hdr.path_bits =3D mad_recv_wc->wc-=
>dlid_path_bits;
> + =C2=A0 =C2=A0 =C2=A0 packet->mad.hdr.pkey_index =3D mad_recv_wc->wc=
->pkey_index;
> + =C2=A0 =C2=A0 =C2=A0 packet->mad.hdr.grh_present =3D !!(mad_recv_wc=
->wc->wc_flags & IB_WC_GRH);
> + =C2=A0 =C2=A0 =C2=A0 if (packet->mad.hdr.grh_present) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 struct ib_ah_attr =
ah_attr;
> +
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ib_init_ah_from_wc=
(agent->device, agent->port_num,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0mad_recv_wc->wc, mad_r=
ecv_wc->recv_buf.grh,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0&ah_attr);
> +
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 packet->mad.hdr.gi=
d_index =3D ah_attr.grh.sgid_index;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 packet->mad.hdr.ho=
p_limit =3D ah_attr.grh.hop_limit;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 packet->mad.hdr.tr=
affic_class =3D ah_attr.grh.traffic_class;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 memcpy(packet->mad=
=2Ehdr.gid, &ah_attr.grh.dgid, 16);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 packet->mad.hdr.fl=
ow_label =3D cpu_to_be32(ah_attr.grh.flow_label);
> + =C2=A0 =C2=A0 =C2=A0 }
> +
> + =C2=A0 =C2=A0 =C2=A0 memcpy(packet->mad.data, recv_buf->mad, packet=
->length);
> +
> + =C2=A0 =C2=A0 =C2=A0 if (queue_packet(file, agent, packet))
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 kfree(packet);
> +}
> +
> =C2=A0static ssize_t copy_recv_mad(struct ib_umad_file *file, char __=
user *buf,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 struct ib_umad_packet *packet, size_t coun=
t)
> =C2=A0{
> @@ -603,8 +677,9 @@ static int ib_umad_reg_agent(struct ib_umad_file =
*file, void __user *arg,
> =C2=A0{
> =C2=A0 =C2=A0 =C2=A0 =C2=A0struct ib_user_mad_reg_req ureq;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0struct ib_mad_reg_req req;
> + =C2=A0 =C2=A0 =C2=A0 struct ib_mad_snoop_reg_req snoop_req;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0struct ib_mad_agent *agent =3D NULL;
> - =C2=A0 =C2=A0 =C2=A0 int agent_id;
> + =C2=A0 =C2=A0 =C2=A0 int agent_id, snoop;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0int ret;
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0mutex_lock(&file->port->file_mutex);
> @@ -620,6 +695,8 @@ static int ib_umad_reg_agent(struct ib_umad_file =
*file, void __user *arg,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0goto out;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0}
>
> + =C2=A0 =C2=A0 =C2=A0 snoop =3D ureq.qpn & IB_UMAD_SNOOP;
> + =C2=A0 =C2=A0 =C2=A0 ureq.qpn &=3D ~IB_UMAD_SNOOP;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0if (ureq.qpn !=3D 0 && ureq.qpn !=3D 1) {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ret =3D -EINVA=
L;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0goto out;
> @@ -633,28 +710,41 @@ static int ib_umad_reg_agent(struct ib_umad_fil=
e *file, void __user *arg,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0goto out;
>
> =C2=A0found:
> - =C2=A0 =C2=A0 =C2=A0 if (ureq.mgmt_class) {
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 req.mgmt_class =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =3D ureq.mgmt_class;
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 req.mgmt_class_ver=
sion =3D ureq.mgmt_class_version;
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 memcpy(req.oui, ur=
eq.oui, sizeof req.oui);
> -
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (compat_method_=
mask) {
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 u32 *umm =3D (u32 *) ureq.method_mask;
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 int i;
> -
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 for (i =3D 0; i < BITS_TO_LONGS(IB_MGMT_MAX_METHODS); ++i)
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 req.method_mask[i] =3D
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 umm[i *=
 2] | ((u64) umm[i * 2 + 1] << 32);
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 } else
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 memcpy(req.method_mask, ureq.method_mask,
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0sizeof req.method_mask);
> - =C2=A0 =C2=A0 =C2=A0 }
> + =C2=A0 =C2=A0 =C2=A0 if (snoop) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 snoop_req.mgmt_cla=
ss =3D ureq.mgmt_class;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 snoop_req.mgmt_cla=
ss_version =3D ureq.mgmt_class_version;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 memcpy(snoop_req.o=
ui, ureq.oui, sizeof snoop_req.oui);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 snoop_req.errors =3D=
 ureq.filter.errors;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 snoop_req.attr_id =
=3D ureq.filter.attr_id;
> +
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 agent =3D ib_regis=
ter_mad_snoop(file->port->ib_dev, file->port->port_num,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 ureq.qpn ? IB_QPT_GSI : IB_QPT_SMI,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 &snoop_req, snoop_send_handler,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 snoop_recv_handler, file);
> + =C2=A0 =C2=A0 =C2=A0 } else {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (ureq.mgmt_clas=
s) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 req.mgmt_class =C2=A0 =C2=A0 =C2=A0 =C2=A0 =3D ureq.mgmt_class;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 req.mgmt_class_version =3D ureq.mgmt_class_version;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 memcpy(req.oui, ureq.oui, sizeof req.oui);
> +
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 if (compat_method_mask) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 u32 *umm =3D (u32 *) ureq.method_ma=
sk;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 int i;
> +
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 for (i =3D 0; i < BITS_TO_LONGS(IB_=
MGMT_MAX_METHODS); ++i)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 req.met=
hod_mask[i] =3D
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 umm[i * 2] | ((u64) umm[i * 2 + 1] << 32);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 } else
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 memcpy(req.method_mask, ureq.method=
_mask,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0sizeof r=
eq.method_mask);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
>
> - =C2=A0 =C2=A0 =C2=A0 agent =3D ib_register_mad_agent(file->port->ib=
_dev, file->port->port_num,
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ureq.qpn ? IB_=
QPT_GSI : IB_QPT_SMI,
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ureq.mgmt_clas=
s ? &req : NULL,
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ureq.rmpp_vers=
ion,
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 send_handler, =
recv_handler, file);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 agent =3D ib_regis=
ter_mad_agent(file->port->ib_dev, file->port->port_num,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 ureq.qpn ? IB_QPT_GSI : IB_QPT_SMI,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 ureq.mgmt_class ? &req : NULL,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 ureq.rmpp_version,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 send_handler, recv_handler, file);
> + =C2=A0 =C2=A0 =C2=A0 }
> =C2=A0 =C2=A0 =C2=A0 =C2=A0if (IS_ERR(agent)) {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ret =3D PTR_ER=
R(agent);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0agent =3D NULL=
;
> diff --git a/include/rdma/ib_user_mad.h b/include/rdma/ib_user_mad.h
> index d6fce1c..0c40861 100644
> --- a/include/rdma/ib_user_mad.h
> +++ b/include/rdma/ib_user_mad.h
> @@ -165,10 +165,36 @@ struct ib_user_mad {
> =C2=A0typedef unsigned long __attribute__((aligned(4))) packed_ulong;
> =C2=A0#define IB_USER_MAD_LONGS_PER_METHOD_MASK (128 / (8 * sizeof (l=
ong)))
>
> +enum {
> + =C2=A0 =C2=A0 =C2=A0 IB_UMAD_QP0,
> + =C2=A0 =C2=A0 =C2=A0 IB_UMAD_QP1,
> + =C2=A0 =C2=A0 =C2=A0 IB_UMAD_SNOOP =3D 0x80,
> + =C2=A0 =C2=A0 =C2=A0 IB_UMAD_SNOOP_QP0 =3D IB_UMAD_SNOOP & IB_UMAD_=
QP0,
> + =C2=A0 =C2=A0 =C2=A0 IB_UMAD_SNOOP_QP1 =3D IB_UMAD_SNOOP & IB_UMAD_=
QP1
> +};

typos above: s.b. | r.t. &

> +
> +/**
> + * ib_user_mad_snoop_filter - additional filter applied to snooped M=
ADs
> + * @attr_id: If non-zero, specifies that the reported MADs must
> + * =C2=A0 reference the indicated attribute identifier.
> + * @errors: If non-zero, indicates that the caller only wishes to
> + * =C2=A0 view sent MADs which complete in error, or received respon=
ses
> + * =C2=A0 which contain a non-zero status value. =C2=A0MADs that com=
plete as
> + * =C2=A0 canceled are not reported if errors is non-zero.
> + * @reserved: Must be set to 0.
> + */
> +struct ib_user_mad_snoop_filter {
> + =C2=A0 =C2=A0 =C2=A0 u16 =C2=A0 =C2=A0 attr_id;
> + =C2=A0 =C2=A0 =C2=A0 u8 =C2=A0 =C2=A0 =C2=A0errors;
> + =C2=A0 =C2=A0 =C2=A0 u8 =C2=A0 =C2=A0 =C2=A0reserved[13];
> +};
> +
> =C2=A0/**
> =C2=A0* ib_user_mad_reg_req - MAD registration request
> =C2=A0* @id - Set by the kernel; used to identify agent in future req=
uests.
> - * @qpn - Queue pair number; must be 0 or 1.
> + * @qpn - Queue pair number; must be 0 or 1. =C2=A0If the upper bit =
of the qpn
> + * =C2=A0 is set to 1, then the registration will be set to snoop tr=
affic
> + * =C2=A0 over that QP.

Should this take half the qpn space or be two specific values ?

-- Hal

> =C2=A0* @method_mask - The caller will receive unsolicited MADs for a=
ny method
> =C2=A0* =C2=A0 where @method_mask =3D 1.
> =C2=A0* @mgmt_class - Indicates which management class of MADs should=
 be receive
> @@ -183,7 +209,10 @@ typedef unsigned long __attribute__((aligned(4))=
) packed_ulong;
> =C2=A0*/
> =C2=A0struct ib_user_mad_reg_req {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0__u32 =C2=A0 id;
> - =C2=A0 =C2=A0 =C2=A0 packed_ulong method_mask[IB_USER_MAD_LONGS_PER=
_METHOD_MASK];
> + =C2=A0 =C2=A0 =C2=A0 union {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 packed_ulong metho=
d_mask[IB_USER_MAD_LONGS_PER_METHOD_MASK];
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 struct ib_user_mad=
_snoop_filter filter;
> + =C2=A0 =C2=A0 =C2=A0 };
> =C2=A0 =C2=A0 =C2=A0 =C2=A0__u8 =C2=A0 =C2=A0qpn;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0__u8 =C2=A0 =C2=A0mgmt_class;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0__u8 =C2=A0 =C2=A0mgmt_class_version;
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
