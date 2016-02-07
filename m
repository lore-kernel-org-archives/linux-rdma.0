From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH 1/3] IB: new common API for draining a queue pair
Date: Sun, 7 Feb 2016 13:51:48 +0200
Message-ID: <56B72FD4.3060407@dev.mellanox.co.il>
References: <cover.1454709317.git.swise@chelsio.com>
 <2da1db58d642789e8df154e34d622a37295d1ba3.1454709317.git.swise@chelsio.com>
 <20160206170838.GC8584@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160206170838.GC8584-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


>> +	ret = ib_modify_qp(qp, &attr, IB_QP_STATE);
>> +	if (ret) {
>> +		WARN_ONCE(ret, "failed to drain QP: %d\n", ret);
>> +		return;
>> +	}
>> +
>> +	ret = ib_post_recv(qp, &rwr, &bad_rwr);
>> +	if (ret) {
>> +		WARN_ONCE(ret, "failed to drain recv queue: %d\n", ret);
>> +		return;
>> +	}
>> +
>> +	ret = ib_post_send(qp, &swr, &bad_swr);
>> +	if (ret) {
>> +		WARN_ONCE(ret, "failed to drain send queue: %d\n", ret);
>> +		return;
>
> You are returning here despite the fact that recv queue drained
> successfully and you can wait for completion of rdrain safely.
> Is it done on purpose?

Good catch, the completion structures are on-stack.

Steve, you need to wait for the completion of the
successful post in this case...
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
