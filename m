From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: [PATCH 2/2] Ad IB_MTU_1500|9000 enums.
Date: Wed, 03 Apr 2013 12:13:28 -0500
Message-ID: <515C6338.3000106@opengridcomputing.com>
References: <1364994796-10642-1-git-send-email-jsquyres@cisco.com> <1364994796-10642-2-git-send-email-jsquyres@cisco.com> <CAL1RGDUefwamQ2Gsm9QKC5+jxskxqE5orwNnbS_t060a+YXZDw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAL1RGDUefwamQ2Gsm9QKC5+jxskxqE5orwNnbS_t060a+YXZDw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: Jeff Squyres <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 4/3/2013 11:52 AM, Roland Dreier wrote:
> On Wed, Apr 3, 2013 at 6:13 AM, Jeff Squyres <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org> wrote:
>> diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
>> index 8a66758..4670f6f 100644
>> --- a/include/rdma/ib_verbs.h
>> +++ b/include/rdma/ib_verbs.h
>> @@ -174,8 +174,10 @@ enum ib_mtu {
>>          IB_MTU_256  = 1,
>>          IB_MTU_512  = 2,
>>          IB_MTU_1024 = 3,
>> -       IB_MTU_2048 = 4,
>> -       IB_MTU_4096 = 5
>> +       IB_MTU_1500 = 4,
>> +       IB_MTU_2048 = 5,
>> +       IB_MTU_4096 = 6,
>> +       IB_MTU_9000 = 7
>>   };
> I don't think we can blithely do this... I think the IB enum values
> are defined to match the values used in the IB spec (PathRecord etc).
>
> Even if we change it so 1500 and 9000 are outside of the range used by
> the IB spec, I don't understand the motivation for this change.  What
> does this buy us?  How is iWARP working today without this change?
>
>

The IB_MTU stuff really doesn't apply to iwarp devices.


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
