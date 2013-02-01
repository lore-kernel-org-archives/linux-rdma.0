From: Bernd Schubert <bernd.schubert-mPn0NPGs4xGatNDF+KUbs4QuADTiUCJX@public.gmane.org>
Subject: Re: crash in librdmacm
Date: Fri, 01 Feb 2013 18:36:15 +0100
Message-ID: <510BFD0F.1060803@itwm.fraunhofer.de>
References: <510A954B.9060301@itwm.fraunhofer.de> <1828884A29C6694DAF28B7E6B8A8237357D423D5@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A8237357D423D5-P5GAC/sN6hmkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "Nikolova, Tatyana E" <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 01/31/2013 09:18 PM, Hefty, Sean wrote:
>> we got a bug report from a customer that FhGFS server daemons
>> frequently crash. Looking into it, we are almost sure it is related
>> to librdmacm/kernel-ib. So the crash in librdmacm resolves to:
>> 
>>> (gdb) l *(rdma_get_cm_event+0x102) 0x3d6dc04522 is in
>>> rdma_get_cm_event (src/cma.c:1975). 1970
>>> break; 1971            default: 1972
>>> evt->id_priv = (void *) (uintptr_t) resp.uid; 1973
>>> evt->event.id = &evt->id_priv->id; 1974
>>> evt->event.status = resp.status; 1975                    if
>>> (ucma_is_ud_qp(evt->id_priv->id.qp_type)) 1976
>>> ucma_copy_ud_event(evt, &resp.param.ud); 1977
>>> else 1978                            ucma_copy_conn_event(evt,
>>> &resp.param.conn); 1979                    break;
>> 
>> 
>> Now the complete shows that the issue comes up directly after
>> initiating a connection and we are just querying the file
>> descriptor for events. So from our point of view there is not much
>> we can do about it.
>> 
>> Possibly this is already fixed by commit 
>> 418edaaba96e58112b15c82b4907084e2a9caf42 and this commit is also
>> not yet in the latest RHEL kernel being used on the customer
>> system. However, the commit messages states it is for
>> RDMA_CM_EVENT_ESTABLISHED only, while the resolved address above
>> points to another event. Does the commit really on fix this event
>> or would it also fix further events?
> 
> The above commit fixes an issue where the uid can be returned 0 from
> the kernel.
> 
> A call to resolve an address should not have this issue.  The issue
> is limited to connections formed from a listen request.  The reason
> for this is that passive side connections create the kernel id first,
> which is then linked up with the user space id.  Active side
> processing creates the user space id, then the kernel id.

Hmm, I think there is a misunderstanding. Actually I meant the server side, 
so indeed the connection and crash are formed from the listen request. 
Could we somehow also fix or at least catch the issue from librdmacm, e.g. 
by checking for uid=0, see the patch below? Probably the patch is not 
sufficient, as the event needs to be deleted somehow, is there a way to do 
that without further processing it?

>> While looking where file->mut is being set, I notice that in 
>> ucma_create_id() the call of ucma_alloc_ctx() is protected by a
>> mutex, but the mutex is immediately given up after that call. In 
>> ucma_alloc_ctx() the ctx is already added to file->ctx_list, but
>> the ctx->uid and ctx->cm_id are then modified outside a mutex in 
>> ucma_create_id(). Shouldn't the mutex_unlock() be done after
>> assigning those values?
> 
> It shouldn't matter, as long as the uid and cm_id are set before any
> events can be generated.  Events are not generated on newly created
> id's.

Ah, thanks.


Thanks,
Bernd

rdma_get_cm_event: Check for a 0 uid

---
 src/cma.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/src/cma.c b/src/cma.c
index ff9b426..236cbd9 100755
--- a/src/cma.c
+++ b/src/cma.c
@@ -1929,6 +1929,8 @@ retry:
 		break;
 	case RDMA_CM_EVENT_CONNECT_REQUEST:
 		evt->id_priv = (void *) (uintptr_t) resp.uid;
+		if (!evt->id_priv)
+			return ERR(EINVAL); /* kernel bug? */
 		if (ucma_is_ud_qp(evt->id_priv->id.qp_type))
 			ucma_copy_ud_event(evt, &resp.param.ud);
 		else
@@ -1941,6 +1943,8 @@ retry:
 	case RDMA_CM_EVENT_CONNECT_RESPONSE:
 		ucma_copy_conn_event(evt, &resp.param.conn);
 		evt->event.status = ucma_process_conn_resp(evt->id_priv);
+		if (!evt->id_priv)
+			return ERR(EINVAL); /* kernel bug? */
 		if (!evt->event.status)
 			evt->event.event = RDMA_CM_EVENT_ESTABLISHED;
 		else {
@@ -1949,6 +1953,8 @@ retry:
 		}
 		break;
 	case RDMA_CM_EVENT_ESTABLISHED:
+		if (!evt->id_priv)
+			return ERR(EINVAL); /* kernel bug? */
 		if (ucma_is_ud_qp(evt->id_priv->id.qp_type)) {
 			ucma_copy_ud_event(evt, &resp.param.ud);
 			break;
@@ -1957,6 +1963,8 @@ retry:
 		ucma_copy_conn_event(evt, &resp.param.conn);
 		break;
 	case RDMA_CM_EVENT_REJECTED:
+		if (!evt->id_priv)
+			return ERR(EINVAL); /* kernel bug? */
 		if (evt->id_priv->connect_error) {
 			ucma_complete_event(evt->id_priv);
 			goto retry;
@@ -1965,6 +1973,8 @@ retry:
 		ucma_modify_qp_err(evt->event.id);
 		break;
 	case RDMA_CM_EVENT_DISCONNECTED:
+		if (!evt->id_priv)
+			return ERR(EINVAL); /* kernel bug? */
 		if (evt->id_priv->connect_error) {
 			ucma_complete_event(evt->id_priv);
 			goto retry;
@@ -1974,6 +1984,8 @@ retry:
 	case RDMA_CM_EVENT_MULTICAST_JOIN:
 		evt->mc = (void *) (uintptr_t) resp.uid;
 		evt->id_priv = evt->mc->id_priv;
+		if (!evt->id_priv)
+			return ERR(EINVAL); /* kernel bug? */
 		evt->event.id = &evt->id_priv->id;
 		ucma_copy_ud_event(evt, &resp.param.ud);
 		evt->event.param.ud.private_data = evt->mc->context;
@@ -1989,6 +2001,8 @@ retry:
 		break;
 	default:
 		evt->id_priv = (void *) (uintptr_t) resp.uid;
+		if (!evt->id_priv)
+			return ERR(EINVAL); /* kernel bug? */
 		evt->event.id = &evt->id_priv->id;
 		evt->event.status = resp.status;
 		if (ucma_is_ud_qp(evt->id_priv->id.qp_type))



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
