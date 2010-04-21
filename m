From: Ding Dinghua <dingdinghua85-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: two questions about RDMA-WRITE
Date: Wed, 21 Apr 2010 20:37:04 +0800
Message-ID: <l2q7bb361261004210537na5feca2rfc240c77263bdc72@mail.gmail.com>
References: <q2v7bb361261004130308za7b4d6ccj6fdb657b7c7cc7e9@mail.gmail.com>
	 <77BFFFE3D9C34D64A03DA5A9DC22F42D@amr.corp.intel.com>
	 <20100414034142.GA5567@DINGDH.localhost.domain>
	 <4B0EDAC5753E48CD8CE32B6E3EF15949@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4B0EDAC5753E48CD8CE32B6E3EF15949-Zpru7NauK7drdx17CPfAsdBPR1lH4CV8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

2010/4/16 Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>:
>>static void jm_cq_comp_handler(struct ib_cq *cq, void *context) {
>> =A0 =A0 =A0 =A0struct jm_rdma_conn *conn =3D context;
>> =A0 =A0 =A0 =A0struct ib_wc wc;
>> =A0 =A0 =A0 =A0struct jm_send_ctx *send;
>>
>> =A0 =A0 =A0 =A0/* No idea why it should be called twice. */
>> =A0 =A0 =A0 =A0printk("cq comp for id %p\n", conn->jc_id);
>> =A0 =A0 =A0 =A0ib_req_notify_cq(cq, IB_CQ_NEXT_COMP);
>> =A0 =A0 =A0 =A0while (ib_poll_cq(cq, 1, &wc) =3D=3D 1) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (wc.opcode !=3D IB_WC_RDMA_WRITE) =
{
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0printk("completed unk=
nown opcode %d\n", wc.opcode);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* continue; */
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0send =3D (struct jm_send_ctx *)wc.wr_=
id;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0printk("got send=3D%p\n", send);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0printk("completed RDMA_WRITE of IO(%L=
u, %u)\n",
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 send->s_offset, send->s_=
size);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0send->s_done =3D wc.status =3D=3D IB_=
WC_SUCCESS ? 1 : -EIO;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0wake_up_all(&send->s_wait);
>> =A0 =A0 =A0 =A0}
>> =A0 =A0 =A0 =A0ib_req_notify_cq(cq, IB_CQ_NEXT_COMP);
>
> unrelated to your problem, but this second call to ib_req_notify_cq i=
sn't
> necessary.
>
>>static int jm_rdma_cm_event_handler(struct rdma_cm_id *id, struct rdm=
a_cm_event
>>*event) {
> ..
>> =A0 =A0 =A0 =A0case RDMA_CM_EVENT_DISCONNECTED:
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0connstate =3D -ECONNABORTED;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto connected;
> ..
>>connected:
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0printk("%pI4:%u (event 0x%x)\n",
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 &conn->jc_remoteaddr.sin=
_addr.s_addr,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ntohs(conn->jc_remoteadd=
r.sin_port),
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 event->event << 11);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0conn->jc_connstate =3D connstate;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0wake_up_all(&conn->jc_connect_wait);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0break;
>
> How quickly do you respond to the disconnect event? =A0The remote sid=
e will wait
> until it receives a response or times out, which may be several secon=
ds or
> minutes.
>
Thanks a lot, I think the problem lays here.
> - Sean
>
>



--=20
Ding Dinghua
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
