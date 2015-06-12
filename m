From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH for-next V3 1/8] IB/core: Change provider's API of
 create_cq to be extendible
Date: Fri, 12 Jun 2015 06:06:00 +0300
Message-ID: <CAJ3xEMgA0UorV3ERz_M7-H0Z4c6tmK2e_k84c6VExhzjQJ+9LQ@mail.gmail.com>
References: <1434029727-6062-1-git-send-email-ogerlitz@mellanox.com>
	<1434029727-6062-2-git-send-email-ogerlitz@mellanox.com>
	<20150611175555.GB20142@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150611175555.GB20142-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Jun 11, 2015 at 8:55 PM, Jason Gunthorpe
<jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
> On Thu, Jun 11, 2015 at 04:35:20PM +0300, Or Gerlitz wrote:
>> From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>>
>> Add a new ib_cq_init_attr structure which contains the
>> previous cqe (minimum number of CQ entries) and comp_vector
>> (completion vector) in addition to a new flags field.
>> All vendors' create_cq callbacks are changed in order
>> to work with the new API.
>>
>> This commit does not change any functionality.
>>
>> Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>> Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>
> You need to collect any Reviwed-By's etc people provide to earlier
> series, and include them when spining a new revision.  For instance

Right, I agree, but our official WW here has ended and the merge
window is likely to open Monday, I hope this time Doug can do that and
pick the patches today so they can pass linux-next built tests and
such in his tree

> http://permalink.gmane.org/gmane.linux.drivers.rdma/26129
>
> I think I had provided a Reviewed-By for some of these patches too.

You only provided your reviewed by to patch #1 and said once we do
the last fix to #2 it can go there too.

> It isn't reasonable to expect Doug to do that.

next time I'll make sure not to forget it, so

Add Jason's Reviewed-By to patches #1/#2

Reviewed-By: Devesh Sharma <devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org> to patch #2
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
