From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 18/19] ib_srp: Remove SCSI devices upon port down event
Date: Tue, 13 Nov 2012 23:23:19 +0200
Message-ID: <CAJZOPZLSPz7f99tj2w-79sPbibrHP3WZY_ct0Cq07Q1so54kFQ@mail.gmail.com>
References: <508A85BB.1000505@acm.org>
	<508A88D8.2050905@acm.org>
	<CAJZOPZL8mKU2MsrPPACvWjiA59aGnWDj0HNTQQNhbDrMsE0+Tg@mail.gmail.com>
	<50A20C03.9040607@acm.org>
	<CAJZOPZ+PiDQ6GYLkDO4MaPTDxLr2XDMn8q3gTaX-COx04PSegg@mail.gmail.com>
	<50A2B989.8000600@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <50A2B989.8000600-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, Karandeep Chahal <kchahal-LfVdkaOWEx8@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Nov 13, 2012 at 11:20 PM, Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org> wrote:
> On 11/13/12 21:54, Or Gerlitz wrote:
>>
>> Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org> wrote:
>> [ ... ]
>>
>> this gets way too much complicated, and just for patch which you said
>> "is not an essential part of this patch series" ... can we just drop
>> it altogether from the series?
>
>
> OK.

that was a fast move (what's the .conf you're using...) -- can you
actually confirm that the results obtained using this patch series
would remain in the same level without this patch?

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
