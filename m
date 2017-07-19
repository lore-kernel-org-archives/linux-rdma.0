From: "Boyer, Andrew" <Andrew.Boyer-8PEkshWhKlo@public.gmane.org>
Subject: Re: [PATCH resend] rxe: fix broken receive queue draining
Date: Wed, 19 Jul 2017 15:56:46 +0000
Message-ID: <D594F7C4.1AF34%Andrew.Boyer@emc.com>
References: <1498555178-12106-1-git-send-email-sagi@grimberg.me>
 <1499812957.2586.47.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1499812957.2586.47.camel-Sjgp3cTcYWE@public.gmane.org>
Content-Language: en-US
Content-ID: <6E1FD705AA542D4790CAC9E02A25D12C-/m+UfqrgI5Tvk4DGDgVwFwC/G2K4zDHf@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org" <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: "vijayi-R1PCaG5FPJG/3pe1ocb+swC/G2K4zDHf@public.gmane.org" <vijayi-R1PCaG5FPJG/3pe1ocb+swC/G2K4zDHf@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

To make this work, it also needs to handle the case where a pkt is on the
req_pkts list but the QP is no longer valid.

--- a/drivers/infiniband/sw/rxe/rxe_req.c
+++ b/drivers/infiniband/sw/rxe/rxe_req.c
@@ -594,8 +594,10 @@ int rxe_requester(void *arg)
 	rxe_add_ref(qp);
=20
 next_wqe:
-	if (unlikely(!qp->valid))
+	if (unlikely(!qp->valid)) {
+		rxe_drain_req_pkts(qp, true);
 		goto exit;
+	}
=20
 	if (unlikely(qp->req.state =3D=3D QP_STATE_ERROR)) {
 		rxe_drain_req_pkts(qp, true);


You could also combine the two checks into one conditional.

For that matter, what is the =8Cnotify=B9 argument supposed to do? I would
think =8Cnotify =3D=3D true=B9 would mean advancing the consumer pointer, n=
ot the
other way around.

-Andrew

On 7/11/17, 6:42 PM, "linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org on behalf of Bart
Van Assche" <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org on behalf of
Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org> wrote:

>On Tue, 2017-06-27 at 12:19 +0300, Sagi Grimberg wrote:
>> From: Vijay Immanuel <vijayi-R1PCaG5FPJG/3pe1ocb+swC/G2K4zDHf@public.gmane.org>
>>=20
>> If we modified the qp to ERROR state, and
>> drained the recieve queue, post_recv must
>              ^^^^^^^
>              receive?
>> trigger the responder task to complete
>> the drain work request.
>>=20
>> Cc: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
>> Signed-off-by: Vijay Immanuel <vijayi-R1PCaG5FPJG/3pe1ocb+swC/G2K4zDHf@public.gmane.org>
>> Signed-off-by: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
>> ---
>>  drivers/infiniband/sw/rxe/rxe_resp.c  | 3 +++
>>  drivers/infiniband/sw/rxe/rxe_verbs.c | 3 +++
>>  2 files changed, 6 insertions(+)
>>=20
>> diff --git a/drivers/infiniband/sw/rxe/rxe_resp.c
>>b/drivers/infiniband/sw/rxe/rxe_resp.c
>> index 23039768f541..f66b48c114ac 100644
>> --- a/drivers/infiniband/sw/rxe/rxe_resp.c
>> +++ b/drivers/infiniband/sw/rxe/rxe_resp.c
>> @@ -1217,6 +1217,9 @@ void rxe_drain_req_pkts(struct rxe_qp *qp, bool
>>notify)
>>  		kfree_skb(skb);
>>  	}
>> =20
>> +	if (notify)
>> +		return;
>> +
>>  	while (!qp->srq && qp->rq.queue && queue_head(qp->rq.queue))
>>  		advance_consumer(qp->rq.queue);
>
>Since an "if (...) return" statement is added, please consider moving the
>qp->srq test out of the while-loop and into the if-expression. Anyway:
>
>Reviewed-by: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>--
>To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
>the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
