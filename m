From: Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-next 0/3] Support out of order data placement
Date: Fri, 21 Jul 2017 19:29:20 -0700
Message-ID: <142c2fed-baa5-1295-1458-be765c94b957@talpey.com>
References: <20170612064918.12510-1-leon@kernel.org>
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
 <fbdcf05b-ccd8-bd9c-c9c8-86f373303250@talpey.com>
 <VI1PR0502MB30089271EB542493AA58060CD1C20@VI1PR0502MB3008.eurprd05.prod.outlook.com>
 <fb11f261-b80b-f71a-8076-204706267798@talpey.com>
 <VI1PR0502MB3008D488FEE8A7104A7B0A7CD1A60@VI1PR0502MB3008.eurprd05.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <VI1PR0502MB3008D488FEE8A7104A7B0A7CD1A60-o1MPJYiShExKsLr+rGaxW8DSnupUy6xnnBOFsp37pqbUKgpGm//BTAC/G2K4zDHf@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, "leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Idan Burstein <idanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 7/18/2017 10:33 PM, Parav Pandit wrote:
> Hi Tom, Jason,
> 
> Sorry for the late response.
> Please find the response inline below.
> 
>> -----Original Message-----
>> From: Tom Talpey [mailto:tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org]
>> Sent: Monday, June 12, 2017 8:30 PM
>> To: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>; Jason Gunthorpe
>> <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
>> Cc: Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>; leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org;
>> dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Idan Burstein
>> <idanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>> Subject: Re: [PATCH rdma-next 0/3] Support out of order data placement
>>
>>>
>>> In IB spec, in-order delivery is default.
>>
>> I don't agree. Requests are sent in-order, and the responder processes them in-
>> order, but the bytes thenselves are not guaranteed to appear in-order.
>> Additionally, if retries occur, this is most definitely not the case.
>>
>> Section 9.5 Transaction Ordering, I believe, covers these requirements. Can you
>> tell me where I misunderstand them?
>> In fact, c9-28 explicitly warns:
>>
>>     • An application shall not depend upon the order of data writes to
>>     memory within a message. For example, if an application sets up
>>     data buffers that overlap, for separate data segments within a
>>     message, it is not guaranteed that the last sent data will always
>>     overwrite the earlier.
>>
> The IB spec indeed does not imply any ordering in the placement of data into memory within a single message.
> 
> It does guarantee that writes don't bypass writes and reads don't bypass reads (Table 79), and transport operations are executed in their *message* order (C9-28):
> "A responder shall execute SEND requests, RDMA WRITE requests
> and ATOMIC Operation requests in the message order in which
> they are received."
> 
> Thus, ordering between messages is guaranteed - changes to remote memory of an RDMA-W will be observed strictly after any changes done by a previous RDMA-W; changes to local memory of an RDMA-R response will be observed strictly after any changes done by a previous RDMA-R response.
> 
> The proposed feature in this patch set is to relax the memory placement ordering *across* messages and not within a single message (which is not mandated by the spec as u noted), such that multiple consecutive RDMA-Ws may be committed to memory in any order, and similarly for RDMA-R responses.
> This changes application semantics whenever multiple-inflight RDMA operations write to overlapping locations, or when one operation indicates the completion of the other.
> A simple example to clarify: a requestor posted the following work elements in the written order:
> 1. RDMA-W(VA=0x1000, value=0x1)
> 2. RDMA-W(VA=0x1000, value=0x2)
> 3. Send()
> On responder side, following the Send() operation completion, and according to spec (C9-28), reading from VA=0x1000 will produce the value 2. With the proposed feature enabled, the read value is not deterministic and dependent on the order in which the RDMA-W operations were received.
> 
> The proposed QP flag allows applications to knowingly indicate this relaxed data placement, thereby enabling the HCA to place OOO RDMA messages into memory without buffering them.

You didn't answer my question what is the actual benefit of relaxing
the ordering. Is it performance? And, specifically what applications
*can't* use it?

To me, it appears that most storage upper layers can already use
the extension. If it performs better, I expect they will definitely
want to enable it. In that case I believe it should be the *default*,
not an opt-in that these upper layers are newly responsible for.

>> I have one other question on the Documentation out-of-order.txt.
>> It states the fence bit can be used to force ordering on a non-strict connection.
>> But fence doesn't apply to RDMA Write?
>> It only applies to operations which produce a reply, such as RDMA Read or
>> Atomic. Have you changed the semantic?
>>
> RDMA-R followed by RDMA-R semantic is changed when proposed QP flag is set.

Can you explain that statement in more detail please? Also, please
clarify on what operation(s) the fence bit now applies.

Tom.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
