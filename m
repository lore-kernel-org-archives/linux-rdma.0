From: Nicolas Morey-Chaisemartin <nmoreychaisemartin-IBi9RG/b67k@public.gmane.org>
Subject: Re: [RFC rdma-core 2/2] srp_daemon: fix CQ handling
Date: Mon, 11 Dec 2017 17:38:07 +0100
Message-ID: <31e8bc8d-2d76-95ad-37cb-62576bd4afa9@suse.com>
References: <82dc0912-3ac3-9548-2c3b-703c6e1c9c95@dev.mellanox.co.il>
 <f35bfdad-9027-d2be-9706-b5a0edd9a778@suse.com>
 <1513009807.2747.11.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1513009807.2747.11.camel-Sjgp3cTcYWE@public.gmane.org>
Content-Language: fr-xx-classique+reforme1990
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: "hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org" <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



Le 11/12/2017 à 17:30, Bart Van Assche a écrit :
> On Mon, 2017-12-11 at 15:46 +0100, Nicolas Morey-Chaisemartin wrote:
>> +tatic int poll_cq_once(struct sync_resources *sync_res, struct ibv_cq *cq,
>> +           struct ibv_wc *wc)
> Has this patch been tested? I don't think that "tatic" is a valid keyword?

Typo during the rebase. But the overall fix was tested yes. I'm looking for insight to make sure my understanding of the issue (and the way to fix it) is valid.
>
>> +		/* Poll CQ once. There may be extra completion that
>> +		 * were associated to the previous event */
>> +		ret = poll_cq_once(sync_res, cq, wc);
>> +		if (ret)
>> +			return ret;
> How many extra completions can be associated with an event? Is polling once
> sufficient? If so, please update the comment ("an" is missing / "were" ->
> "was").
There can be more than one.
This should be enough becausethey would all be consumed through the call to poll_cq.
As long as there as completion in the CQ, they will be returned directly without waiting for an event.
Once there are no more, the code will wait for the next event again.

I'll fix the typo and the log.

Thanks

Nicolas

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
