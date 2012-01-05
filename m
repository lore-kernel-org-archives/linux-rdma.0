From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: When is it safe to release connection resources?
Date: Thu, 5 Jan 2012 12:23:49 +0100
Message-ID: <CAO+b5-pk8v-1+STkYXmwTv2nKyQJcZd575dJW6Hipfo5_AchwA@mail.gmail.com>
References: <4EFC987B.6070901@list-group.com>
	<1828884A29C6694DAF28B7E6B8A8237325662B63@ORSMSX102.amr.corp.intel.com>
	<CAO+b5-qHFFg-KKQQkEZ2sS_+TWAFCJ0Ed4XGV15cs==_9zttSw@mail.gmail.com>
	<1828884A29C6694DAF28B7E6B8A823732566B335@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A823732566B335-P5GAC/sN6hmkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Flavio Baronti <f.baronti-ngIpsMLAhaq41k5uCYKmRQ@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Jan 4, 2012 at 9:05 PM, Hefty, Sean <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrot=
e:
>> I've just had a look at the kernel code that implements all this
>> (uverbs_cmd.c and uverbs_main.c). I haven't found any precautions
>> against ib_uverbs_comp_handler() accessing *uobj after
>> ib_uverbs_destroy_cq() has invoked put_uobj(uobj). Did I miss
>> something ?
>
> The kernel operation is different, since it relies on callbacks. =A0W=
hen the kernel ib_destroy_cq()
> returns, we are guaranteed that the completion handler (ib_uverbs_com=
p_handler) is not executing
> and will not be called. =A0After destroying the kernel cq, ib_uverbs_=
destroy_cq() will remove all
> references to the destroyed cq from the event list.

Sorry if I wasn't clear enough, but I was referring to the case where
the kernel completion handler gets invoked after
ib_uverbs_destroy_cq() has started but before that function has
invoked ib_destroy_cq().

More in general - assuming that completion notifications have been
enabled - I'm wondering whether it is possible to shut down a queue
pair without triggering a race condition if that queue pair hasn't
been transitioned to the reset or error state first.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
