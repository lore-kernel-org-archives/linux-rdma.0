From: Nicolas Morey-Chaisemartin <nmoreychaisemartin-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH rdma-core 2/2] srp_daemon: fix CQ handling
Date: Tue, 12 Dec 2017 18:28:45 +0100
Message-ID: <e584830f-64a0-d5b6-c3b7-1cb6e0f4df90@suse.com>
References: <05bbb67fea5e3cae535c0d9d21866cf8ad76f74f.1513087686.git.NMoreyChaisemartin@suse.com>
 <19c1241b-6a22-f8c2-32a2-6233f62cc39c@suse.com>
 <1513098293.2999.15.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1513098293.2999.15.camel-Sjgp3cTcYWE@public.gmane.org>
Content-Language: fr-xx-classique+reforme1990
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: "bvanassche-HInyCGIudOg@public.gmane.org" <bvanassche-HInyCGIudOg@public.gmane.org>, "stable-Xl5UnYtxxKxKUA01WzcqbQ@public.gmane.org" <stable-Xl5UnYtxxKxKUA01WzcqbQ@public.gmane.org>, "hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org" <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



Le 12/12/2017 à 18:04, Bart Van Assche a écrit :
> On Tue, 2017-12-12 at 15:08 +0100, Nicolas Morey-Chaisemartin wrote:
>> +static int poll_cq_once(struct sync_resources *sync_res, struct ibv_cq *cq,
>> +			struct ibv_wc *wc)
>> +{
>> +	int ret;
>> +	ret = ibv_poll_cq(cq, 1, wc);
> Please leave one blank line between declarations and statements.

OK

>
>> +	if (ret < 0) {
>> +		pr_err("poll CQ failed\n");
>> +		return ret;
>> +	}
>> +
>> +	if (ret > 0 && wc->status != IBV_WC_SUCCESS) {
>> +		if (!stop_threads(sync_res))
>> +			pr_err("got bad completion with status: 0x%x\n",
>> +			       wc->status);
>> +		return -ret;
>> +	}
>> +
>> +	return ret;
>> +}
> This function can return negative values, positive values or zero. Please
> modify it such that either 0 or a negative Unix error code is returned. This
> will make it easier to read this function and also the code that calls this
> function.

We still need to differenciate between OK with 0 completions polled, and OK with 1 completion.
I did it this way to limit the side effect of factoring the code.
Would you want poll_cq_once to return -EAGAIN  when no completion was found?

I just realized the code is broken anyway.
if poll_cq_once returns an error in the second poll_cq loop, it is not returned by poll_cq itself (simply return 0).


Nicolas
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
