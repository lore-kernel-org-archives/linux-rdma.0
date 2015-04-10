From: Bob Ciotti <Bob.Ciotti-NSQ8wuThN14@public.gmane.org>
Subject: Re: RDMA Multicasting
Date: Fri, 10 Apr 2015 14:33:02 -0700
Message-ID: <5528418E.9040403@nasa.gov>
References: <A1EC1DB6D8AEAF4CB8006B3653F61C5471F997F9@CMEXMB1.ad.emulex.com> <alpine.DEB.2.11.1504090955080.19714@gentwo.org> <5526c0f8.2116430a.28f7.ffffd059SMTPIN_ADDED_BROKEN@mx.google.com> <alpine.DEB.2.11.1504091329180.24028@gentwo.org> <5526e18b.a50c450a.4b9f.77beSMTPIN_ADDED_BROKEN@mx.google.com> <alpine.DEB.2.11.1504101011300.30374@gentwo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.11.1504101011300.30374-gkYfJU5Cukgdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Caitlin Bestler <cait-DpaxOq6QOWMAvxtiuMwx3w@public.gmane.org>
Cc: Allen Andrews <Allen.Andrews-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



On 4/10/15 8:14 AM, Christoph Lameter wrote:
> On Thu, 9 Apr 2015, Caitlin Bestler wrote:
>
>>> Infiniband is lossless and thus what "unreliable" means is also quite
>>> foggy.
>>
>> InfiniBand is not lossless. It does a superb job of avoiding drops caused
>> by congestion. But applications should not assume that all UD messages
>> have been received, but should add their own checking. That is why the
>> U stands for Unreliable.
>
> Well applications can screw up yes but the fabric *IS* lossless.

This is a very bad assumption. Fabric *is not* lossless.

Packet loss happens - for various reasons that are typically specific to the environment.
We have found several broken pieces of SW that assumed RC connections are reliable, and
do bad things when the qp hits its retry limit. So not only loosing 1 packet, but 7 in a
row. Building SW that relied on RC - well OK, but assuming UD reliable in all environments?
If HW never broke, and systems were never overloaded, room temperatures never fluctuated, IB
cables were always reliable... Its not that uncommon to see packet loss on a perfectly functioning
(large) system let alone one thats having HW issues...


>>>> You are probably better off using RDMA ideas over UDP/UD, and doing the
>>>> direct memory placement from your own code, instead.
>>>
>>> So send the memory transfer info via multicast datagram to the
>>> endpoints and then run the transfer from the endpoint.
>>
>> Yes, possibly in a kermel module.
>
> Why? You can simply do this already from userspace with verbs messaging
> and RDMA tranfers.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
