From: Devesh Sharma <devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
Subject: Re: [PATCH for-next 2/7] IB: Introduce Work Queue object and its verbs
Date: Sun, 18 Oct 2015 21:08:07 +0530
Message-ID: <CANjDDBgVhY-shh_ouBe2+_0FcYYkmTzgkthNv=f6jmkJxzPk3Q@mail.gmail.com>
References: <1444893410-13242-1-git-send-email-yishaih@mellanox.com>
 <1444893410-13242-3-git-send-email-yishaih@mellanox.com> <CAG53R5V7u7o+cVQnqhfjXdUjKJRVBiMx5CF3snWAWKG6ZbWMow@mail.gmail.com>
 <561FB463.8030602@dev.mellanox.co.il> <CAG53R5U256Nt=3xd3sVUuf8J1icdK5YEiQFoQjR_HB_=5-cVww@mail.gmail.com>
 <561FD375.3000205@dev.mellanox.co.il> <CAG53R5UmEhOh3n-+9qMoDthAtROdWQXstwqAFxzx8Urx1ZETnw@mail.gmail.com>
 <5623B5D3.2020206@dev.mellanox.co.il> <CAG53R5VFK20e-=1VANya3XQCWts0wyhttsdp+SVJ=MR_27smnQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAG53R5VFK20e-=1VANya3XQCWts0wyhttsdp+SVJ=MR_27smnQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Alex Vainman <alexv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi All,

Will it be a good idea to have ha separate header for this feature.
Lets not append to ib_verbs.h?

-Regards
Devesh

On Sun, Oct 18, 2015 at 8:45 PM, Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> On Sun, Oct 18, 2015 at 8:38 PM, Yishai Hadas
> <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:
>> On 10/15/2015 7:49 PM, Parav Pandit wrote:
>>
>>> If there is stateless WQ being used by multiple QPs in multiplexed
>>
>>
>> The WQ is not stateless and always has its own PD.
>>
>>> way, it should be able to multiplex between QP's of different PD as
>>> well.
>>> Otherwise for every PD being created, there will have be one WQ needed
>>> to service all the QPs belonging to that PD.
>>
>>
>> As mentioned, same WQ can serve multiple QPs, from PD point of view it
>> behaves similarly to SRQ that may be associated with many QPs with different
>> PDs.
>>
>> See IB SPEC, Release 1.3, o10-2.2.1:
>> "SRQ may be associated with the same PD as used by one or more of its
>> associated QPs or a different PD."
>>
>> As part of coming V1 will improve the commit message to better clarify the
>> WQ's PD behavior, thanks.
>
> Ok. Got it. Thanks.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
