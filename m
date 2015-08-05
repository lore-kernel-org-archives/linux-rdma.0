From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH for-next 1/2] IB/core: Add support for RX/TX checksum
 offload capabilities report
Date: Thu, 6 Aug 2015 01:16:17 +0300
Message-ID: <CAJ3xEMgFCx3Xaan2WYL53HRnhdvnoDsS2TriYbENQizpnV31dw@mail.gmail.com>
References: <1438788867-18332-1-git-send-email-amirv@mellanox.com>
	<1438788867-18332-2-git-send-email-amirv@mellanox.com>
	<20150805171634.GA12274@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150805171634.GA12274-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Moshe Lazer <moshel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eric Dube <edube-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Aug 5, 2015 at 8:16 PM, Jason Gunthorpe
<jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
> On Wed, Aug 05, 2015 at 06:34:26PM +0300, Amir Vadai wrote:
>>  struct ib_uverbs_ex_query_device {
>>       __u32 comp_mask;
>> +     __u32 csum_caps;
>>       __u32 reserved;
>>  };
>
> Uh no.
>
>> @@ -221,6 +222,7 @@ struct ib_uverbs_odp_caps {
>>  struct ib_uverbs_ex_query_device_resp {
>>       struct ib_uverbs_query_device_resp base;
>>       __u32 comp_mask;
>> +     __u32 csum_caps;
>>       __u32 response_length;
>>       struct ib_uverbs_odp_caps odp_caps;
>>       __u64 timestamp_mask;
>
> Also totally wrong.
>
> Or, WTF? why is something so screwed up like this being sent to the list?
> NAK


Jason,

So -- shit happens, I am trying to figure out if an internal review
has been done, b/c we do have some folks who terribly master the
extended uverbs framework, right...? if this is wrong it's good that
you rejected the patch and even put it in WTF response, but again, I
see that the author is someone new to the upstream rdma stack and we
should encourage more people to participate... so you sent him back
home to do HW, let's see what this will yield.

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
