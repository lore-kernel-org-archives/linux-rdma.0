From: Bob Biloxi <iambobbiloxi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: mlx4 - query regarding PF VF functionality division
Date: Thu, 26 Jun 2014 14:33:02 +0530
Message-ID: <CANwwZzXMn5sCCGtaNBr+ri2Ujm5dmfgMiu4nS7MVqm1Uta0sig@mail.gmail.com>
References: <CANwwZzWsjQwZB5Cc4Hyv2HQOLhAx6ycjf32UQG55zVX=Kmbi6Q@mail.gmail.com>
	<CAJZOPZ+FUneDDKMh0O2aZLYeDTcH8cHA7ati5wzi7Ycgc5wFXQ@mail.gmail.com>
	<CANwwZzXc2UyYxGX2X+O38jTVki70HrP71FBWbc4dTyt9nEN0nA@mail.gmail.com>
	<CAJZOPZK0naRu_rv-MMPp9y9Eg_baEJXSGzdERQLWvi3Bh9qD+g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJZOPZK0naRu_rv-MMPp9y9Eg_baEJXSGzdERQLWvi3Bh9qD+g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> I see, by the nature of the mlx4 SRIOV architecture under which
> there's no dedicated/separated PF vs VF driver, this is indeed a
> non-trivial task, need to think how to make it easier for you
Thanks for considering. It would be really helpful. I actually
appreciate the mlx4 architecture wherein 3 separate drivers are part
of 1 integrated code base which I think is really difficult to
accomplish. I mean the dedicated driver, VF driver, PF driver are all
part of single code base which i think is good.

The only thing is when one wants to understand these pieces (VF or PF)
separately, it takes some effort(as in my case)

For e.g

there is this flow:

mlx4_en_get-qp()->mlx4_register_mac()->mlx4_slave_cmd()

after this the wrapper function gets called be it either for
master(PF) or for slave(VF)

Till now I was assuming that this makes sense only for the slave(VF)
because register_mac is supposed to be called by VF. But from the code
even the PF makes the call. So i was somewhat confused.

It would be of immense help if I could understand this somehow..


On Thu, Jun 26, 2014 at 2:13 AM, Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> On Tue, Jun 24, 2014 at 4:42 PM, Bob Biloxi <iambobbiloxi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>>
>> > Not really, but let's take EIM approach, what's your goal/mission?
>> Let's say I am going through code to understand only the PF related
>> functionality without bothering about VF, what are the things I need
>> to keep in mind.
>
>
>
> I see, by the nature of the mlx4 SRIOV architecture under which
> there's no dedicated/separated PF vs VF driver, this is indeed a
> non-trivial task, need to think how to make it easier for you
>
> Or.
>
>
>>
>> I mean do i need to :
>>
>> a. Go through all the files in mlx4
>> b. If the code is not specifically under mlx4_is_master, I still need
>> to understand it because it is also part of PF driver
>> c. I can ignore the logic which executes if mlx4_is_master is false,
>> because that would be the VF code
>>
>> Thanks for the help!!
>>
>>
>>
>>
>> On Mon, Jun 23, 2014 at 5:30 PM, Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> > On Mon, Jun 23, 2014 at 12:33 PM, Bob Biloxi <iambobbiloxi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> > [...]
>> >> Is there any way we can clearly separate the files that are used by PF
>> >> vs the files that are used by VF in the (drivers/net/ethernet/mlx4
>> >> sub-directory)?
>> > [...]
>> >
>> > Not really, but let's take EIM approach, what's your goal/mission?
>> >
>> > Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
