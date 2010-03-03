From: Vladislav Bolkhovitin <vst-d+Crzxg7Rs0@public.gmane.org>
Subject: Re: SRP initiator and iSER initiator performance
Date: Wed, 03 Mar 2010 23:23:05 +0300
Message-ID: <4B8EC529.9010202@vlnb.net>
References: <e2e108261002271127x253faa84lf6eb8aa77d3cf51a@mail.gmail.com>	 <4B8C1FBF.8060001@vlnb.net> <e2e108261003012259o7c9b217j5011006e3a772d6a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <e2e108261003012259o7c9b217j5011006e3a772d6a-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: Chris Worley <worleys-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>, OFED mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, scst-devel <scst-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Bart Van Assche, on 03/02/2010 09:59 AM wrote:
> On Mon, Mar 1, 2010 at 9:12 PM, Vladislav Bolkhovitin <vst-d+Crzxg7Rs0@public.gmane.org> wrote:
>> [ ... ]
>> It's good if my impression was wrong. But you've got suspiciously low IOPS
>> numbers. On your hardware you should have much more. Seems you experienced a
>> bottleneck on the initiator somewhere above the drivers level (fio? sg
>> engine? IRQs or context switches count?), so your results could be not
>> really related to the topic. Oprofile and lockstat output can shed more
>> light on this.
> 
> You didn't understand the purpose of the test. My goal was not to
> achieve record IOPS numbers but to stress the SRP and iSER initiators
> as much as possible. I choose the sg I/O engine in order to bypass the
> block layer.

No, Bart, I understood your purpose very well. I'll illustrate my point 
on example. Let's consider we want to compare a Ferrari and Toyota 
Corolla cars. The only track we have to use has 60km/h speed limit, so 
we used it strictly following the speed limit. Would we have a correct 
comparison of the cars' capabilities, or would we compare only their 
speedometers' mistakes? If Toyota's speedometer allows to stay more 
closely to the limit, Toyota can win Ferrari. But would it win too on 
180 km/h limit? Or without speed limit at all?

The same is in our topic. We can consider your experiment correct only 
if the bottleneck is driver/hardware, which isn't likely to be.

Vlad
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
