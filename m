From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [RFC 5/8] IB/srp: reduce local coverage for command submission
 and EH
Date: Sun, 2 Jan 2011 18:16:43 +0100
Message-ID: <AANLkTi=pRdoMWw4ZNy4JK9CoNGB=wyrThTNuDH+LUW0Y@mail.gmail.com>
References: <1293139893-11678-1-git-send-email-dillowda@ornl.gov> <1293139893-11678-6-git-send-email-dillowda@ornl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1293139893-11678-6-git-send-email-dillowda-1Heg1YXhbW8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Dec 23, 2010 at 10:31 PM, David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org> wrot=
e:
>
> We only need locks to protect our lists and number of credits availab=
le.
> By pre-consuming the credit for the request, we can reduce our lock
> coverage to just those areas. If we don't actually send the request,
> we'll need to put the credit back into the pool.
>
> [ ... ]
>
> - =A0 =A0 =A0 iu->type =3D iu_type;
> + =A0 =A0 =A0 list_del_init(&iu->list);

Hello Dave,

As far as I can see the above call of list_del_init() can be modified
into a list_del() call. The same holds for the other list_del_init()
call introduced by this patch.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
