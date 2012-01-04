From: Flavio Baronti <f.baronti-ngIpsMLAhaq41k5uCYKmRQ@public.gmane.org>
Subject: Re: When is it safe to release connection resources?
Date: Wed, 04 Jan 2012 10:42:49 +0100
Message-ID: <4F041F19.1070608@list-group.com>
References: <4EFC987B.6070901@list-group.com> <1828884A29C6694DAF28B7E6B8A8237325662B63@ORSMSX102.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A8237325662B63-P5GAC/sN6hlcIJlls4ac1rfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

So in order to safely call ibv_destroy_cq, I should call ibv_ack_cq_events *after* ibv_poll_cq? The example on the man 
page for ibv_get_cq_event calls it before, is it an error?

Flavio

Il 1/2/2012 17:39 PM, Hefty, Sean ha scritto:
>> If I understood correctly, when ibv_get_cq_event returns, it holds some sort
>> of lock over the completion queue, which is
>
> ibv_get_cq_event will increment a reference count on the CQ that it is returning.
>
>> released when I call ibv_req_notify_cq. This lock is checked also in
>
> You decrement the count with ibv_ack_cq_events.  ibv_req_notify_cq is used to arm the cq, so that a completion generates an interrupt and a new event.
>
>> ibv_destroy_cq, so that:
>> 1) When ibv_destroy_cq returns, I am certain that there is no thread running
>> somewhere between ibv_get_cq_event and
>> ibv_req_notify_cq
>
> ibv_destroy_cq will block until all outstanding references on the cq have been released.  The intent is to protect the user from ibv_get_cq_event from returning a reference to a cq that is being destroyed from another thread, which could result in a crash in the user's code.
>
>> 2) When ibv_destroy_cq returns, I am certain that ibv_get_cq_event will not
>> return the destroyed cq any more.
>
> correct
>
> - Sean
>

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
