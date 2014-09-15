From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH for-next 1/2] IB/uverbs: Add QP creation flags, allow
 blocking UD multicast loopback
Date: Mon, 15 Sep 2014 20:36:08 +0300
Message-ID: <CAJ3xEMidZpzXaD=ttc5qAWZfX4DPRZxwK9YK6pPPjyDLjFMM7g@mail.gmail.com>
References: <1410700802-27848-1-git-send-email-ogerlitz@mellanox.com>
	<1410700802-27848-2-git-send-email-ogerlitz@mellanox.com>
	<1410799972.7830.25.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1410799972.7830.25.camel-bi+AKbBUZKY6gyzm1THtWbp2dZbC/Bob@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Sep 15, 2014 at 7:52 PM, Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org> wrote:
>> --- a/include/uapi/rdma/ib_user_verbs.h
>> +++ b/include/uapi/rdma/ib_user_verbs.h
>> @@ -470,7 +470,7 @@ struct ib_uverbs_create_qp {
>>       __u8  sq_sig_all;
>>       __u8  qp_type;
>>       __u8  is_srq;
>> -     __u8  reserved;
>> +     __u8  create_flags;
>>       __u64 driver_data[0];
>>  };
>>
>
> I'm not really happy with the way "reserved" field is used by this
> patch: as the field wasn't check for being set to 0, any value could be
> given by userspace (imagine the structure lay on stack). Using it now
> could be dangerous. It must be double checked.

We  are only allowing user space applications to program certain
aspects in the behavior
of their own QPs, no risk to the system/kernel state.

We've done it very successfully in the past with adding the link_layer field
to struct ib_uverbs_query_port_resp as part of the RoCE story instead of a
reserved field.

Or
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
