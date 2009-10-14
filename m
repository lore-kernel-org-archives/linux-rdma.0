From: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: ConnectX saquery question
Date: Wed, 14 Oct 2009 16:16:51 +0200
Message-ID: <4AD5DD53.2080305@dev.mellanox.co.il>
References: <eafd71280910140630w2ca6a802s9ef98362d0fecb6@mail.gmail.com> <f0e08f230910140637g5049658cy8b3481c06b0865af@mail.gmail.com> <4AD5D854.20506@dev.mellanox.co.il>
Reply-To: kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4AD5D854.20506-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org
Cc: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Aaron Knister <aaron.knister-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Yevgeny Kliteynik wrote:
> Hal Rosenstock wrote:
>> On Wed, Oct 14, 2009 at 9:30 AM, Aaron Knister 
>> <aaron.knister-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>>> I searched the lists and can't really find an answer to my question-
>>>
>>> When I run saquery -s on my cluster with ConnectX HCAs (fw ver
>>> 2.6.648) all I get is the following output
>>>
>>> IsSM ports
>>>
>>> IsSMdisabled ports
>>>
>>> I thought this should show ports that are running a subnet manager
>>> (there are 2 running on the cluster) or am I incorrect?
>>
>> That means that the IsSM bit in PortInfo:CapabilityMask is not being
>> set. Maybe that's not supported by the firmware.
> 
> Nope, I just checked it with FW 2.6.648 - looks fine:
> 
>     # saquery -s
>     IsSM ports
>     PortInfoRecord dump:
>                     EndPortLid..............512
>                     PortNum.................0x1
>                     base_lid................0x200
>                     master_sm_base_lid......0x80
>                     capability_mask.........0x251086A
>     PortInfoRecord dump:
>                     EndPortLid..............128
>                     PortNum.................0x1
>                     base_lid................0x80
>                     master_sm_base_lid......0x80
>                     capability_mask.........0x251086A
>     
>     IsSMdisabled ports
> 
> Maybe IsSM bit is not being set by the OSM?
> What SM version are you running?

Also, run the following from the node that runs SM and
doesn't appear in the 'saquery -s' report:

sminfo -D 0
smpquery -D portinfo 0 <sm_port_num>

'sm_port_num' is the number of port that SM is binded to.
Usually it's 1.

-- Yevgeny

 
> -- Yevgeny
> 
> 
>> -- Hal
>>
>>> Thanks!
>>>
>>> -Aaron
>>> -- 
>>> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
>>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>> -- 
>> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
> 
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
