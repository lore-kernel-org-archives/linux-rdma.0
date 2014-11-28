From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: Tutorials/howto to modify exiting tcp/ip app for rdma
Date: Fri, 28 Nov 2014 11:08:50 -0500
Message-ID: <54789E12.6000601@dev.mellanox.co.il>
References: <CACaajQv2-TFkmANMNBikryG8CE_xhnOx05Qt9aQC8MXfyeRLSg@mail.gmail.com> <5477298A.6060605@dev.mellanox.co.il> <CACaajQs6vP=LJ+H=SC7G4EuwOebsjz9G1vxay=aYiKyo1AwSjg@mail.gmail.com> <54774122.1020502@dev.mellanox.co.il> <5477584A.9050605@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5477584A.9050605-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Vasiliy Tolstov <v.tolstov-+9FY0jupvH6HXe+LvDLADg@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 11/27/2014 11:58 AM, Hal Rosenstock wrote:
> On 11/27/2014 10:20 AM, Sagi Grimberg wrote:
>> On 11/27/2014 4:39 PM, Vasiliy Tolstov wrote:
>>> 2014-11-27 16:39 GMT+03:00 Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>:
>>>> You can keep doing IP address resolution using rdma_cm.
>>>>
>>>> You can see perftest examples in
>>>> git://flatbed.openfabrics.org/~grockah/perftest.git
>>>> Or,
>>>> librdmacm's rping in git://flatbed.openfabrics.org/~shefty/librdmacm.git
>>>
>>>
>>> Thanks! But if don't have ipoib connection why i need ip address ?=)
>>>
>>
>> My understanding was that you want to _add_ support for RDMA to a
>> working tcp/ip application, the natural thing is using rdma_cm.
>>
>> If you want to replace IP address resolution you need to start
>> communicating with the SM.
> 
> rsockets now supports AF_IB address family (assuming kernel does too -
> 3.11 or beyond) but you need the path record to the destination IB
> address (GID) to make the connection so that involves an SA query or the
> equivalent...

Also, you need librdmacm 1.0.19-1 or later for this.

rstream is the best example of how to use AF_IB.

-- Hal

> 
> -- Hal
> 
>>
>> srptools is a nice example for that:
>> git://flatbed.openfabrics.org/~bvanassche/srptools.git/.git
>>
>> Sagi.
>> -- 
>> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
> 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
