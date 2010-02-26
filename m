From: Tom Ammon <tom.ammon-wbocuHtxKic@public.gmane.org>
Subject: Re: looking for opensm mailing list
Date: Fri, 26 Feb 2010 14:50:15 -0700
Message-ID: <4B884217.4090503@utah.edu>
References: <4B858330.2050406@utah.edu> <f0e08f231002241203i4ec23ef2ob05536a189507181@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <f0e08f231002241203i4ec23ef2ob05536a189507181-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Okay, a different question has just come up.

On my DDR IB fabric, using QLogic HCAs, when I run ibnetdiscover, I 
don't see the hostname in the node description, but I do see "HCA-1". On 
a different cluster, using Mellanox HCAs (and redhat's OFED), I do see 
the hostnames in the node description.

So here's my questions: How does ibnetdiscover find the hostname/node 
description? Is there an option somewhere in OFED on the node that I 
need to set to allow this name to show in ibnetdiscover?

Tom

On 02/24/2010 01:03 PM, Hal Rosenstock wrote:
> On Wed, Feb 24, 2010 at 2:51 PM, Tom Ammon<tom.ammon-wbocuHtxKic@public.gmane.org>  wrote:
>    
>> Hi,
>>
>> I'm looking for a mailing list where opensm developers and/or users might be
>> listening. Does anyone here know where I could find a list with such people?
>>      
> It's on this list too :-)
>
> -- Hal
>
>    
>> Tom
>>
>> --
>> --------------------------------------------------------------------
>> Tom Ammon
>> Network Engineer
>> Office: 801.587.0976
>> Mobile: 801.674.9273
>>
>> Center for High Performance Computing
>> University of Utah
>> http://www.chpc.utah.edu
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>>      

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
