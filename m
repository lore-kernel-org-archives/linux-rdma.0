From: Nicolas Morey-Chaisemartin <NMoreyChaisemartin-l3A5Bk7waGM@public.gmane.org>
Subject: Re: Patches for rdma-core stable-v15
Date: Tue, 14 Nov 2017 15:41:33 +0100
Message-ID: <068edead-ca0c-f378-bf6f-e16b46534906@suse.de>
References: <6ccc2110-2e27-bacd-b821-f862785a10ca@suse.de>
 <BN3PR07MB257876D3FE069B77DC7AFFBFF8280@BN3PR07MB2578.namprd07.prod.outlook.com>
 <CANjDDBjv4C_TJWtgJ=zVPef+TQqSFBNuf5dnUnVRf0k4+sf8nA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CANjDDBjv4C_TJWtgJ=zVPef+TQqSFBNuf5dnUnVRf0k4+sf8nA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: fr-xx-classique+reforme1990
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, stable-Xl5UnYtxxKxKUA01WzcqbQ@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



Le 14/11/2017 à 15:29, Devesh Sharma a écrit :
> Ack'ing following two patches :
>
>>> Devesh Sharma (1):
>>>       bnxt_re/lib: increment psn in case of 0 length packets
> And
>
>> Yeah,
>>
>> Jason is asking for further amendments to the barrier mechanism we
>> have today in rdma-core. That can be handled in a separate patch
>> series.  For now this should be good to go unless Jason suggests
>> otherwise.
> It should be fine as is. This is just something we should fix in
> mainline to ensure we don't get burned by a newer compiler or
> something.
>
> bnxt_re/lib: fix the memory barrier call during poll-cq
> commit-id: f4e67f1027011a6f9081b6239b866f27f750f678
>

Both picked in stable-v15.

Nicolas

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
