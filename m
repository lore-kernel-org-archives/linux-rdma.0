From: Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-next 0/3] Support out of order data placement
Date: Mon, 12 Jun 2017 20:11:58 -0400
Message-ID: <fbdcf05b-ccd8-bd9c-c9c8-86f373303250@talpey.com>
References: <20170612064918.12510-1-leon@kernel.org>
 <1497281280.2770.1.camel@wdc.com>
 <VI1PR0502MB3008478FC7C70D1F398FE2B2D1CD0@VI1PR0502MB3008.eurprd05.prod.outlook.com>
 <20170612162917.GA11993@obsidianresearch.com>
 <VI1PR0502MB3008EA451DA9ECEBECE27362D1CD0@VI1PR0502MB3008.eurprd05.prod.outlook.com>
 <20170612164343.GA12435@obsidianresearch.com>
 <VI1PR0502MB300831A1560531E67B29589DD1CD0@VI1PR0502MB3008.eurprd05.prod.outlook.com>
 <20170612165536.GB12435@obsidianresearch.com>
 <6747e257-67b0-a364-be21-04f73ef82ffe@talpey.com>
 <VI1PR0502MB30080B672B80836FF0A328DCD1CD0@VI1PR0502MB3008.eurprd05.prod.outlook.com>
 <475e1873-e842-ecb9-d260-34777da57e51@talpey.com>
 <VI1PR0502MB3008B7FE60CAB3BD49907A1BD1CD0@VI1PR0502MB3008.eurprd05.prod.outlook.com>
 <d3a436a0-9ace-b11a-2e4c-387fc575877e@talpey.com>
 <VI1PR0502MB3008E04612EED6BC83F37115D1CD0@VI1PR0502MB3008.eurprd05.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <VI1PR0502MB3008E04612EED6BC83F37115D1CD0-o1MPJYiShExKsLr+rGaxW8DSnupUy6xnnBOFsp37pqbUKgpGm//BTAC/G2K4zDHf@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, "leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Idan Burstein <idanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 6/12/2017 7:59 PM, Parav Pandit wrote:
>> -----Original Message-----
>> From: Tom Talpey [mailto:tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org]
>> Sent: Monday, June 12, 2017 6:44 PM
>> To: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>; Jason Gunthorpe
>> <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
>> Cc: Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>; leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org;
>> dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Idan Burstein
>> <idanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>> Subject: Re: [PATCH rdma-next 0/3] Support out of order data placement
>>
>> On 6/12/2017 6:54 PM, Parav Pandit wrote:
>>> Hi Tom,
>>>
>>>> -----Original Message-----
>>>> From: Tom Talpey [mailto:tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org]
>>>> Sent: Monday, June 12, 2017 5:20 PM
>>>> To: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>; Jason Gunthorpe
>>>> <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
>>>> Cc: Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>; leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org;
>>>> dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Idan Burstein
>>>> <idanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>>>> Subject: Re: [PATCH rdma-next 0/3] Support out of order data
>>>> placement
>>>>
>>>> On 6/12/2017 5:32 PM, Parav Pandit wrote:
>>>>> Hi Tom,
>>>> ...
>>>>>>
>>>>>> I agree with Jason, the bit should be 1 by default, if defined as
>>>>>> you
>>>> propose.
>>>>>> Out-of-order is the norm, not the exception, for ULPs.
>>>>>> Honestly, I think you should perhaps consider making it the default
>>>>>> on your devices, and allowing only MLX-aware ULPs to turn it off.
>>>>>>
>>>>>
>>>>> There can be cases in deployment where responder has support for
>>>> receiving out-of-order, but requester doesn't.
>>>>
>>>> Yuck! So this needs to be negotiated end-to-end, and by the upper layer?
>>>> Talk about barriers to adoption, and opportunities for disaster.
>>>>
>>> As Jason confirmed that all Linux kernel consumers are coded to be
>>> compliant to o9-20 requirement, So I think kernel based rdma-cm
>> consumers can be transparently enabled end-to-end without ULP's
>> involvement with rdma_accept() and rdma_connect().
>>
>> I have two thoughts here.
>>
>> 1) You seem to assume all consumers are Linux, and do not need to
>> negotiate. This is a dangerous assumption.
> Certainly not. I didn't assume that. I just gave one example that known consumers can be done without modifying the ULP.
> Explained further in 3rd question.
> Even other consumers can work with this solution.
> For example Linux rdmacm based client and Other OS based server.
> Client is ooo capable.
> Server is ooo not capable.
> Once you follow below rdmacm based sequence, it will be clear how this will works.

Oh, so there's a MAD protocol change under the hood. Well,
that's a wider question. And I still don't understand how
existing, non-strict-requiring protocols can take advantage
of this. Nor how this works for non-Mellanox, non-IB/RoCE
implementations.

Again, I'd be a lot less concerned if non-strict were the
default, and strict mode was negotiated. It's all just so
upside-down.

Tom.

>> 2) I assume that there is some performance benefit to toggling this setting
>> to non-strict. So, how do existing consumers get this advantage, especially
>> since they don't need strict semantics? Bearing in mind that they do have
>> to negotiate this end-to-end, meaning they require a protocol extension.
> I don't have completely transparent upstream solution for existing consumers yet.
>>
>> Actually. I have a third thought. Since this is an attribute to qp creation,
>> performed even before establishing a connection, how does the upper layer
>> know when to set it?
> This is not at QP creation time. I have described in Documentation/out_of_order.txt in usage section 3.
> This is at QP state transition from INIT to RTR.
> Here is the flow. It's just not coded enough for posting patches.
> 
> 1. When rdmacm active side creates the QP, It is INIT state.
> 2. Send MAD_Req msg (indicating ooo_requested=1)
> 3. When rdmacm passive side receives the message, it looks up device_cap attribute and matches it against ooo_requested flag.
> 4. when device supports it, MAD_Rsp msg sets ooo_enabled=1, if it doesn't support it, ooo_enabled=0
> 5. rdmacm passive side creates the QP and moves to RTR state (with QP ooo enabled bit set).
> 6. active side receives the message and puts the QP to RTR, RTS state based on received bit setting from passive side.
> 
> Flow is no different than how rest of the connection specific parameters are shared such as IRD/ORD, PSN, timeouts, mtu etc.
> 
> 
> 
>>
>> Tom.
> N�����r��y���b�X��ǧv�^�)޺{.n�+����{��ٚ�{ay�
ʇڙ�,j��f���h���z�
�w���
���j:+v���w�j�m��������zZ+�����ݢj"��!tml=
> 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
