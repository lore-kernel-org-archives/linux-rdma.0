From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: SRP initiator and iSER initiator performance
Date: Thu, 4 Mar 2010 08:03:02 +0100
Message-ID: <e2e108261003032303g972b373t38886e5e8ad393bd@mail.gmail.com>
References: <e2e108261002271127x253faa84lf6eb8aa77d3cf51a@mail.gmail.com>
	 <4B8C1FBF.8060001@vlnb.net>
	 <e2e108261003011238h331e473bge905b8ea695f7483@mail.gmail.com>
	 <4B8EC526.4060006@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4B8EC526.4060006-d+Crzxg7Rs0@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vladislav Bolkhovitin <vst-d+Crzxg7Rs0@public.gmane.org>
Cc: Chris Worley <worleys-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>, OFED mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, scst-devel <scst-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Mar 3, 2010 at 9:23 PM, Vladislav Bolkhovitin <vst-d+Crzxg7Rs0@public.gmane.org> wr=
ote:
> Bart Van Assche, on 03/01/2010 11:38 PM wrote:
>>
>> On Mon, Mar 1, 2010 at 9:12 PM, Vladislav Bolkhovitin <vst-d+Crzxg7Rs0@public.gmane.org
>> <mailto:vst-d+Crzxg7Rs0@public.gmane.org>> wrote:
>>
>> =A0 =A0[ ... ]
>> =A0 =A0It's good if my impression was wrong. But you've got suspicio=
usly
>> =A0 =A0low IOPS numbers. On your hardware you should have much more.=
 Seems
>> =A0 =A0you experienced a bottleneck on the initiator somewhere above=
 the
>> =A0 =A0drivers level (fio? sg engine? IRQs or context switches count=
?), so
>> =A0 =A0your results could be not really related to the topic. Oprofi=
le and
>> =A0 =A0lockstat output can shed more light on this.
>>
>>
>> The number of IOPS I obtained is really high considering that I used=
 the
>> sg I/O engine. This means that no buffering has been used and none o=
f the
>> I/O requests were combined into larger requests. I chose the sg I/O =
engine
>> on purpose in order to bypass the block layer. I was not interested =
in
>> record IOPS numbers but in a test where most of the time is spent in=
 the SRP
>> / iSER initiator instead of the block layer.
>
> 116K IOPS'es isn't high, it's pretty low for QDR IB. [ ... ]

It looks like it's time that you make yourself familiar with the
difference between CPU-bound, I/O bound and memory bound. It is
essential to understand this terminology before starting to comment on
performance tests.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
