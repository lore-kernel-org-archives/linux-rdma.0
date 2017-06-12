From: Artemy Kovalyov <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [RFC 2/5] verbs: Introduce tag matching SRQ
Date: Tue, 13 Jun 2017 00:09:29 +0300
Message-ID: <af1d8a49-7d4a-6f3c-b5a1-c4aba79d74d1@mellanox.com>
References: <1497249767-15353-1-git-send-email-artemyko@mellanox.com>
 <1497249767-15353-3-git-send-email-artemyko@mellanox.com>
 <20170612163856.GA12282@obsidianresearch.com>
 <0c00c167-1cfb-d169-134d-d608079b53df@mellanox.com>
 <20170612205015.GA24893@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170612205015.GA24893-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, yosefe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, anag-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



On 12/06/2017 23:50, Jason Gunthorpe wrote:
> On Mon, Jun 12, 2017 at 11:38:09PM +0300, Artemy Kovalyov wrote:
>>
>>
>> On 12/06/2017 19:38, Jason Gunthorpe wrote:
>>> On Mon, Jun 12, 2017 at 09:42:44AM +0300, Artemy Kovalyov wrote:
>>>> enum ibv_srq_type {
>>>> 	IBV_SRQT_BASIC,
>>>> -	IBV_SRQT_XRC
>>>> +	IBV_SRQT_XRC,
>>>> +	IBV_SRQT_TAG_MATCHING
>>>> };
>>>
>>> Please put trailing commas on all these enum changes in all patches
>>
>> So do we drop overboard all -Wpedantic users?
>
> Eh? Try it.
>
> You only get warnings if your compiler is running in c89 or ansi mode,
> which went 'overboard' a long time ago.
Bare -Wpedantic -Werror fails with this.

>
> Jason
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
