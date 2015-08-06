From: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH for-next 1/2] IB/core: Add support for RX/TX checksum
 offload capabilities report
Date: Thu, 6 Aug 2015 17:17:58 +0530
Message-ID: <CAG53R5WNpjq7R63n8V3ST5Du9dn7Q=W+2-kq9ERxFMKOg+6nqg@mail.gmail.com>
References: <1438788867-18332-1-git-send-email-amirv@mellanox.com>
	<1438788867-18332-2-git-send-email-amirv@mellanox.com>
	<20150805171634.GA12274@obsidianresearch.com>
	<HE1PR05MB1355B04E4B418A48DB5137B0C1740@HE1PR05MB1355.eurprd05.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <HE1PR05MB1355B04E4B418A48DB5137B0C1740-eBadYZ65MZ+lkJP6d7MyxNqRiQSDpxhJvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Moshe Lazer <moshel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eric Dube <edube-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Aug 6, 2015 at 4:30 PM, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
> On Wednesday, August 5, 2015 8:16 PM, Jason Gunthorpe jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
>> On Wed, Aug 05, 2015 at 06:34:26PM +0300, Amir Vadai wrote:
>>>  struct ib_uverbs_ex_query_device {
>>>       __u32 comp_mask;
>>> +     __u32 csum_caps;
>>>       __u32 reserved;
>>>  };
>>
>> Uh no.
> This is the struct of the command, not the response. There is no need to extend it. The command is designed to always return as much information as possible, so the user space code doesn't need to pass anything for it to work.
>
> Even if you did want to extend it, you would need to replace the reserved word. The structs in this header file must be made in such way that they have the same size on 32-bit systems and on 64-bit systems (see the comment at the beginning of the header file). This is why the reserved word is there.
>
>>
>>> @@ -221,6 +222,7 @@ struct ib_uverbs_odp_caps {
>>>  struct ib_uverbs_ex_query_device_resp {
>>>       struct ib_uverbs_query_device_resp base;
>>>       __u32 comp_mask;
>>> +     __u32 csum_caps;
>>>       __u32 response_length;
>>>       struct ib_uverbs_odp_caps odp_caps;
>>>       __u64 timestamp_mask;
>>
>> Also totally wrong.
>
> The response struct must maintain backward compatibility. You cannot change the order of the existing fields. The only valid way of extending it is at the end. Here too, you must make sure that the struct has the same size on 32-bit systems, so you would need to add a 32-bit reserved word at the end.
>

As struct ib_uverbs_ex_query_device_resp captures extended
capabilities, does it make sense to have few more reserved words
defined as part of this patch?
So that later on those reserved can be defined in future for
additional features.
This way for every new feature we dont need to bump structure size of
ABI, not we need to define new set of ABI calls.
Its hard to say how much more is sufficient, but was thinking of 8 32-bit words.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
