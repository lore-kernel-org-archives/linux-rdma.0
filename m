From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: When is it safe to release connection resources?
Date: Wed, 4 Jan 2012 19:53:43 +0000
Message-ID: <CAO+b5-qHFFg-KKQQkEZ2sS_+TWAFCJ0Ed4XGV15cs==_9zttSw@mail.gmail.com>
References: <4EFC987B.6070901@list-group.com>
	<1828884A29C6694DAF28B7E6B8A8237325662B63@ORSMSX102.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A8237325662B63-P5GAC/sN6hlcIJlls4ac1rfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Flavio Baronti <f.baronti-ngIpsMLAhaq41k5uCYKmRQ@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Jan 2, 2012 at 4:39 PM, Hefty, Sean <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrot=
e:
>> If I understood correctly, when ibv_get_cq_event returns, it holds s=
ome sort
>> of lock over the completion queue, which is
>> ibv_destroy_cq, so that:
>> 1) When ibv_destroy_cq returns, I am certain that there is no thread=
 running
>> somewhere between ibv_get_cq_event and
>> ibv_req_notify_cq
>
> ibv_destroy_cq will block until all outstanding references on the cq =
have been released.
>=A0The intent is to protect the user from ibv_get_cq_event from return=
ing a reference to a cq
> that is being destroyed from another thread, which could result in a =
crash in the user's code.

I've just had a look at the kernel code that implements all this
(uverbs_cmd.c and uverbs_main.c). I haven't found any precautions
against ib_uverbs_comp_handler() accessing *uobj after
ib_uverbs_destroy_cq() has invoked put_uobj(uobj). Did I miss
something ?

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
