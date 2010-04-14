From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: Socket Direct Protocol: help (2)
Date: Wed, 14 Apr 2010 10:08:15 -0500
Message-ID: <4BC5DA5F.6010607@opengridcomputing.com>
References: <13381_1271060138_o3C8FUH8013968_2977669.1271060085255.SLOX.WebMail.wwwrun@imap.lnl.infn.it>	<1246722.1271082830120.SLOX.WebMail.wwwrun@imap.lnl.infn.it>	<2EFBCAEF10980645BBCFB605689E08E9047C7402DA@azsmsx506.amr.corp.intel.com>	<4BC49E2B.3000804@opengridcomputing.com>	<2EFBCAEF10980645BBCFB605689E08E9047C7405A0@azsmsx506.amr.corp.intel.com>	<4BC4D22A.6020700@opengridcomputing.com>	<2EFBCAEF10980645BBCFB605689E08E9047C7405E9@azsmsx506.amr.corp.intel.com>	<7037536.1271235105513.SLOX.WebMail.wwwrun@imap.lnl.infn.it>	<4BC5D1D3.3020004@mellanox.co.il> <4BC5D727.4090400@opengridcomputing.com> <4BC5D95D.3010108@mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4BC5D95D.3010108-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Cc: Andrea Gozzelino <Andrea.Gozzelino-PK20h7lG/Rc1GQ1Ptb7lUw@public.gmane.org>, "Tung, Chien Tin" <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org" <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, "peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org" <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "pavel-+ZI9xUNit7I@public.gmane.org" <pavel-+ZI9xUNit7I@public.gmane.org>, "mingo-X9Un+BFzKDI@public.gmane.org" <mingo-X9Un+BFzKDI@public.gmane.org>, Eric B Munson <ebmunson-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Amir Vadai wrote:
> You are right - I missed it.
>
> Andrea, Please open a bug at bugzilla (https://bugs.openfabrics.org) -
> so that you will be notified as soon as I will fix SDP not use FMR if
> not supported.
>
> As to fastreg_mrs support - I don't know this mechanism. Do you mean FRWR?
>
>   

ib_alloc_fast_reg_mr(), ib_alloc_fast_reg_page_list() and friends, plus 
the IB_WR_FAST_REG_MR work request.


> Thanks,
> Amir
>
>
> On 04/14/2010 05:54 PM, Steve Wise wrote:
>   
>> Hey Amir,
>>
>> I don't think this helps because sdp_add_device() will not add rdma 
>> devices that fail to create fmr pools. 
>>
>> So I guess you could key off of fmr pool failures and set 
>> sdp_zcopy_thresh to 0 and allow the device to be used?
>>
>> But what we really need is sdp support for fastreg_mrs  as an 
>> alternative to fmrs.
>>
>>
>> Steve.
>>
>>
>> Amir Vadai wrote:
>>   
>>     
>>> Hi,
>>>
>>> FMR are being used only in a special mode called ZCopy.
>>>
>>> You could disable this mode by setting the module paramter
>>> sdp_zcopy_thresh to 0, or by issuing:
>>> # echo 0 > /sys/module/ib_sdp/parameters/sdp_zcopy_thresh
>>>
>>> This means that you won't get the benefits of Zero-copy.
>>>
>>> - Amir
>>>
>>> On 04/14/2010 11:51 AM, Andrea Gozzelino wrote:
>>>   
>>>     
>>>       
>>>> On Apr 13, 2010 10:22 PM, "Tung, Chien Tin" <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>>>> wrote:
>>>>
>>>>   
>>>>     
>>>>       
>>>>         
>>>>>>>> Chien, does the NE020 support FMRs? I looked at the nes ofed-1.5
>>>>>>>> code
>>>>>>>> and it appears to do nothing in the map_phys_fmr functions.
>>>>>>>>
>>>>>>>>           
>>>>>>>>             
>>>>>>>>               
>>>>>>>>                 
>>>>>>> We never implemented map_phys_fmr. Is it relevant to the # of SGEs?
>>>>>>>
>>>>>>>         
>>>>>>>           
>>>>>>>             
>>>>>>>               
>>>>>> No, but SDP uses FMRs. I don't think it will run without FMR support.
>>>>>>
>>>>>>       
>>>>>>         
>>>>>>           
>>>>>>             
>>>>> Good to know.  Thanks.
>>>>>
>>>>> Chien
>>>>>
>>>>>
>>>>>     
>>>>>       
>>>>>         
>>>>>           
>>>> Hi Steve and Chien,
>>>>
>>>> I understand that NE020 cards have problem with SDP connected with
>>>> map_phy_fmr (FMR stands for Fast Memory Region).
>>>> Is it possible to solve/fix this point?
>>>> If yes, have you an idea about the time that is necessary to code
>>>> development/build?
>>>> If no, can you suggest me a card that supports SDP protocol?
>>>>
>>>> I work on NE020 cards from February 2010 for an INFN experimental
>>>> proposal, called REDIGO (Read out at 10 Gbits/s), about the data
>>>> acquisition and movement systems. The covergence of storage protocols
>>>> around 10 Gigabits/s Ethernet protocols shows that one way could be the
>>>> Remote Direct Memory Access (RDMA). The goals are the investigations of
>>>> latency time, the throughput, the buffer size schemes and finally the
>>>> global event building bandwidth.
>>>>
>>>> Do you know if NE020 cards have problems with librdma (RDMA procedures,
>>>> in general) and / or with MPI versions?
>>>>
>>>> Thank you very much,
>>>> Andrea
>>>>
>>>> Andrea Gozzelino
>>>>
>>>> INFN - Laboratori Nazionali di Legnaro	(LNL)
>>>> Viale dell'Universita' 2
>>>> I-35020 - Legnaro (PD)- ITALIA
>>>> Tel: +39 049 8068346
>>>> Fax: +39 049 641925
>>>> Mail: andrea.gozzelino-PK20h7lG/Rc1GQ1Ptb7lUw@public.gmane.org			
>>>>
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
>>>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>>   
>>>>     
>>>>       
>>>>         
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>> Please read the FAQ at  http://www.tux.org/lkml/
>>>   
>>>     
>>>       
>>   
>>     

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
