From: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Subject: Re: Two more ib_srp patches
Date: Fri, 17 Aug 2012 09:49:51 -0700
Message-ID: <CAL1RGDWg7NaPkwGdOYsQ6usoztKKWhdWQzjN=MGe4xatdyRVTg@mail.gmail.com>
References: <502E13DA.2030603@acm.org> <1345216056.17811.7.camel@frustration.ornl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1345216056.17811.7.camel-zHLflQxYYDO4Hhoo1DtQwJ9G+ZOsUmrO@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Cc: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Aug 17, 2012 at 8:07 AM, David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org> wrote:
> On Fri, 2012-08-17 at 05:50 -0400, Bart Van Assche wrote:
>> Hello Dave,
>>
>> I think I have found two additional (longstanding) ib_srp issues. Do the
>> patches below make sense to you ? If so, do you prefer that I post these
>> as individual patches or that I merge these in the patch called "[PATCH
>> 01/20] ib_srp: Fix a race condition" ?
>
> Separate patches are fine.

Yes, please send new separate patches, I already merged the race fix and
I'm planning on sending a pull request to Linus shortly.

[ugh, reply-to-all this time, sorry for the dupe Dave]
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
