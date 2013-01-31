From: Bernd Schubert <bernd.schubert-mPn0NPGs4xGatNDF+KUbs4QuADTiUCJX@public.gmane.org>
Subject: crash in librdmacm
Date: Thu, 31 Jan 2013 17:01:15 +0100
Message-ID: <510A954B.9060301@itwm.fraunhofer.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi all,

we got a bug report from a customer that FhGFS server daemons frequently 
crash. Looking into it, we are almost sure it is related to 
librdmacm/kernel-ib. So the crash in librdmacm resolves to:

> (gdb) l *(rdma_get_cm_event+0x102)
> 0x3d6dc04522 is in rdma_get_cm_event (src/cma.c:1975).
> 1970                    break;
> 1971            default:
> 1972                    evt->id_priv = (void *) (uintptr_t) resp.uid;
> 1973                    evt->event.id = &evt->id_priv->id;
> 1974                    evt->event.status = resp.status;
> 1975                    if (ucma_is_ud_qp(evt->id_priv->id.qp_type))
> 1976                            ucma_copy_ud_event(evt, &resp.param.ud);
> 1977                    else
> 1978                            ucma_copy_conn_event(evt, &resp.param.conn);
> 1979                    break;


Now the complete shows that the issue comes up directly after initiating 
a connection and we are just querying the file descriptor for events. So 
from our point of view there is not much we can do about it.

Possibly this is already fixed by commit 
418edaaba96e58112b15c82b4907084e2a9caf42 and this commit is also not yet 
in the latest RHEL kernel being used on the customer system.
However, the commit messages states it is for RDMA_CM_EVENT_ESTABLISHED 
only, while the resolved address above points to another event. Does the 
commit really on fix this event or would it also fix further events?

While looking where file->mut is being set, I notice that in 
ucma_create_id() the call of ucma_alloc_ctx() is protected by a mutex, 
but the mutex is immediately given up after that call. In 
ucma_alloc_ctx() the ctx is already added to file->ctx_list, but the 
ctx->uid and ctx->cm_id are then modified outside a mutex in 
ucma_create_id(). Shouldn't the mutex_unlock() be done after assigning 
those values?

Looking further, I also notice that 'enum rdma_cm_event_type' does not 
initialize a single value. AFAIK, according to the C standard at least 
the first value has to be initialized, otherwise the compiler is free to 
assign random values. This is certainly fine for in-kernel enums, 
however, as kernel and user space need to use the same numbers this 
probably should be improved. Shall I write a patch, assigning the first 
value to 0 for kernel and lib definitions?


Thanks,
Bernd

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
