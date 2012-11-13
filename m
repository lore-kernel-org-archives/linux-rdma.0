From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH 18/19] ib_srp: Remove SCSI devices upon port down event
Date: Tue, 13 Nov 2012 22:35:33 +0100
Message-ID: <50A2BD25.60407@acm.org>
References: <508A85BB.1000505@acm.org> <508A88D8.2050905@acm.org> <CAJZOPZL8mKU2MsrPPACvWjiA59aGnWDj0HNTQQNhbDrMsE0+Tg@mail.gmail.com> <50A20C03.9040607@acm.org> <CAJZOPZ+PiDQ6GYLkDO4MaPTDxLr2XDMn8q3gTaX-COx04PSegg@mail.gmail.com> <50A2B989.8000600@acm.org> <CAJZOPZLSPz7f99tj2w-79sPbibrHP3WZY_ct0Cq07Q1so54kFQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJZOPZLSPz7f99tj2w-79sPbibrHP3WZY_ct0Cq07Q1so54kFQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, Karandeep Chahal <kchahal-LfVdkaOWEx8@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 11/13/12 22:23, Or Gerlitz wrote:
> On Tue, Nov 13, 2012 at 11:20 PM, Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org> wrote:
>> On 11/13/12 21:54, Or Gerlitz wrote:
>>>
>>> Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org> wrote:
>>> [ ... ]
>>>
>>> this gets way too much complicated, and just for patch which you said
>>> "is not an essential part of this patch series" ... can we just drop
>>> it altogether from the series?
>>
>> OK.
>
> that was a fast move (what's the .conf you're using...) -- can you
> actually confirm that the results obtained using this patch series
> would remain in the same level without this patch?

Failover time in case of cable pulling will increase slightly but 
otherwise the behavior of this patch series will be unaffected. I'll 
retest this patch series anyway before reposting it.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
