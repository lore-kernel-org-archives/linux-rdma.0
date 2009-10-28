From: Bart Van Assche <bart.vanassche-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: OFED 1.5 complains about freeing invalid memtype
Date: Wed, 28 Oct 2009 18:46:35 +0100
Message-ID: <e2e108260910281046v3ed2158lf80b96aa66170d75@mail.gmail.com>
References: <e2e108260910271330n665cbe2eyd2dfce60f4e61cc2@mail.gmail.com>
	 <e2e108260910271332i50e1f127vc4ea72a0be1239e1@mail.gmail.com>
	 <4AE7F5BF.3020106@mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4AE7F5BF.3020106-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tziporet Koren <tziporet-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Cc: OFED mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Oct 28, 2009 at 8:41 AM, Tziporet Koren <tziporet-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org> wrote:
> Bart Van Assche wrote:
>>
>> Hello,
>>
>> While /etc/init.d/openibd runs the following kernel messages were
>> generated:
>>
>> mstmread:2578 freeing invalid memtype fe600000-fe610000
>> mstmread:2578 freeing invalid memtype fe610000-fe700000
>> mstmread:2581 freeing invalid memtype fe600000-fe610000
>> mstmread:2581 freeing invalid memtype fe610000-fe700000
>> mstmread:2584 freeing invalid memtype fe600000-fe610000
>> mstmread:2584 freeing invalid memtype fe610000-fe700000
>> mstmread:2587 freeing invalid memtype fe600000-fe610000
>> mstmread:2587 freeing invalid memtype fe610000-fe700000
>> mstmread:2626 freeing invalid memtype fea00000-fea10000
>> mstmread:2626 freeing invalid memtype fea10000-feb00000
>> mstmread:2629 freeing invalid memtype fea00000-fea10000
>> mstmread:2629 freeing invalid memtype fea10000-feb00000
>> mstmread:2632 freeing invalid memtype fea00000-fea10000
>> mstmread:2632 freeing invalid memtype fea10000-feb00000
>> mstmread:2635 freeing invalid memtype fea00000-fea10000
>> mstmread:2635 freeing invalid memtype fea10000-feb00000
>>
>> This occurred with a 2.6.30.9 kernel with kernel debugging enabled,
>> OFED-1.5-20091027-0600 and mlx4 hardware. Is this a known issue ?
>
> This happened from mstmread utility
> Are you using it?

I didn't invoke mstmread manually. mstmread got invoked from
/etc/init.d/openibd during every boot because of a configuration error
in /etc/infiniband/openib.conf: CXGB3_LOAD was set to yes while no
such hardware was present on the system openibd ran on.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
