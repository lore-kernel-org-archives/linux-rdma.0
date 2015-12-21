From: Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: RoCE passive side failures on 4.4-rc5
Date: Mon, 21 Dec 2015 17:08:58 +0200
Message-ID: <CAAKD3BBhjP+fO6TPPTXRhtQKmUv2Tz6RJosrn4=o2s=0by5acQ@mail.gmail.com>
References: <5672BF85.6080005@mellanox.com>
	<567658E4.6040508@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <567658E4.6040508-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, Dec 20, 2015 at 9:29 AM, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
> On 12/17/2015 3:58 PM, Or Gerlitz wrote:
>>
>> Using 4.4-rc5+ [1] and **not** applying any of the patches I sent today,
>> I noted that RoCE passive side isn't working (rdma-cm, ibv_rc_pingpong
>> works).
>>
>> I have two nodes in ConnectX3 VPI config (port1 IB and port2 Eth), the one
>> with the 4.4-rc5 kernel can act as both (rping) client/server for IB links
>> but only (rping) client for RoCE.
>>
>> I tried both inter-node and loopback runs, in all cases, the client side
>> getsCM
>> reject with reason 28, see [2], tried both iser and rping. Eth (ICMP, TCP)
>> works OK.
>
>
> OK, small progress, when the force Eth link type on my IB port (using mlx4
> sysfs), things work.
>
> You should be able to reproduce it on your non-VPI systems the other way
> around, by
> forcing IB link type on one of the Eth ports and see the failure.
>
> I Saw the same behavior with both 4.4-rc2 and 4.4-rc5
>
> Or.

I've posted a patch that fixes that, please take a look at [1].

Regards,
Matan

[1] https://www.mail-archive.com/linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org/msg30777.html

>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
