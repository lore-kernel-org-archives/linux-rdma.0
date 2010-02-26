From: Tom Ammon <tom.ammon-wbocuHtxKic@public.gmane.org>
Subject: Re: looking for opensm mailing list
Date: Fri, 26 Feb 2010 15:12:22 -0700
Message-ID: <4B884746.5060504@utah.edu>
References: <4B858330.2050406@utah.edu>	<f0e08f231002241203i4ec23ef2ob05536a189507181@mail.gmail.com>	<4B884217.4090503@utah.edu> <20100226135341.8046af65.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100226135341.8046af65.weiny2-i2BcT+NCU+M@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Cc: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Kelly Cash <kelly.cash-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Ahh...

We are using QLogic's distribution of OFED, and they had disabled this 
script. When I run it manually, it puts the hostname in the node 
description and works like a charm.

Thanks!

Tom

On 02/26/2010 02:53 PM, Ira Weiny wrote:
> On Fri, 26 Feb 2010 14:50:15 -0700
> Tom Ammon<tom.ammon-wbocuHtxKic@public.gmane.org>  wrote:
>
>    
>> Okay, a different question has just come up.
>>
>> On my DDR IB fabric, using QLogic HCAs, when I run ibnetdiscover, I
>> don't see the hostname in the node description, but I do see "HCA-1". On
>> a different cluster, using Mellanox HCAs (and redhat's OFED), I do see
>> the hostnames in the node description.
>>      
> set_nodedesc.sh is part of the infiniband-diags package.  I believe RHEL runs this by default at boot.  It will set the nodedesc as the hostname.  When I wrote the script, I asked on the list if the method I was using would work for all HCA's and I was told that it would.
>
> Could you run that script on a node by hand and see if it will at least work with the QLogic HCA's?
>
> If this works then you will need to figure out why it is not run at boot.
>
> Thanks,
> Ira
>
>    
>> So here's my questions: How does ibnetdiscover find the hostname/node
>> description? Is there an option somewhere in OFED on the node that I
>> need to set to allow this name to show in ibnetdiscover?
>>
>> Tom
>>
>> On 02/24/2010 01:03 PM, Hal Rosenstock wrote:
>>      
>>> On Wed, Feb 24, 2010 at 2:51 PM, Tom Ammon<tom.ammon-wbocuHtxKic@public.gmane.org>   wrote:
>>>
>>>        
>>>> Hi,
>>>>
>>>> I'm looking for a mailing list where opensm developers and/or users might be
>>>> listening. Does anyone here know where I could find a list with such people?
>>>>
>>>>          
>>> It's on this list too :-)
>>>
>>> -- Hal
>>>
>>>
>>>        
>>>> Tom
>>>>
>>>> --
>>>> --------------------------------------------------------------------
>>>> Tom Ammon
>>>> Network Engineer
>>>> Office: 801.587.0976
>>>> Mobile: 801.674.9273
>>>>
>>>> Center for High Performance Computing
>>>> University of Utah
>>>> http://*www.*chpc.utah.edu
>>>>
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
>>>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>>>> More majordomo info at  http://*vger.kernel.org/majordomo-info.html
>>>>
>>>>
>>>>          
>> -- 
>> --------------------------------------------------------------------
>> Tom Ammon
>> Network Engineer
>> Office: 801.587.0976
>> Mobile: 801.674.9273
>>
>> Center for High Performance Computing
>> University of Utah
>> http://*www.*chpc.utah.edu
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://*vger.kernel.org/majordomo-info.html
>>
>>      
>
>    

-- 
--------------------------------------------------------------------
Tom Ammon
Network Engineer
Office: 801.587.0976
Mobile: 801.674.9273

Center for High Performance Computing
University of Utah
http://www.chpc.utah.edu

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
