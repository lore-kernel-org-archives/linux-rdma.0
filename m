From: Erez Shitrit <erezsh-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: AW: AW: AW: IPoIB GRO
Date: Tue, 05 Nov 2013 10:48:10 +0200
Message-ID: <5278B0CA.9080305@dev.mellanox.co.il>
References: <12EF8D94C6F8734FB2FF37B9FBEDD173585A3E3B@EXCHANGE.collogia.de>,<527759C6.3070009@dev.mellanox.co.il> <12EF8D94C6F8734FB2FF37B9FBEDD173585A4301@EXCHANGE.collogia.de>,<52779612.9020103@dev.mellanox.co.il> <12EF8D94C6F8734FB2FF37B9FBEDD173585A45CF@EXCHANGE.collogia.de>,<5278A757.2070406@mellanox.com> <12EF8D94C6F8734FB2FF37B9FBEDD173585A4B3D@EXCHANGE.collogia.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <12EF8D94C6F8734FB2FF37B9FBEDD173585A4B3D-Xnr6BND5kcg29+KCeZIpYi5l6jQMEky5@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Markus Stockhausen <stockhausen-FhFLwxQf9jkb1SvskN2V4Q@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Wendy Cheng <s.wendy.cheng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


>> I see. This didn't happen on our setups here since we tests with
>> newer cards (ConnectX2/3/3-pro).
>> For ConnectX1 (A0) and this firmware that you are using smells
>> like something goes wrong. If possible, I would change to newish
>> card.
> No problem with that. My journey up to here was hard but very
> interesting. Especially when you expect everything in the system
> to be consistent and new speedups with every new kernel or
> driver version. Encountering a throughput drop of nearly 50%
> with the upgrade of our NFS servers I was challenged.
>
> With TSO disabled on our old cards I'm back to LRO speeds and
> I'm more than happy with that.
>
> Just a final clarification for the interested reader: Are the TCP Ids
> in an TSO setup generated through firmware or in the software
> stack? And if in firmware: How does the card know how to
> increase them? I would expect that it only works with IB packets
> and does not know of the IP encapsulation.
The card (HW) knows how to deal with IP packets, the card is configured 
via the FW to increase the ip-id for each ip packet that it is part of 
the full message.

so, to summarize:
The HW does the work (truncates the big ip packet to series of ip 
packets, each with the relevant mtu size and increases the ip-id for each)
The FW enables that work on the HW
the FW in A0 card doesn't enable that option for the HW.

>
> Best regards.
>
> Markus

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
