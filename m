From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH for-next 09/10] IB/mlx4: Add timestamp_mask and hca_core_clock
 to query_device
Date: Wed, 20 May 2015 17:41:04 +0300
Message-ID: <555C9D00.2090609@mellanox.com>
References: <1431869786-6308-1-git-send-email-ogerlitz@mellanox.com>
 <1431869786-6308-10-git-send-email-ogerlitz@mellanox.com>
 <20150519185801.GM18675@obsidianresearch.com>
 <20150519190031.GN18675@obsidianresearch.com>
 <CAJ3xEMiO2y6G5YzzkGC1M=XB6yrtNJ7jj13pTUAee1TssiYwkQ@mail.gmail.com>
 <20150519191553.GP18675@obsidianresearch.com>
 <CAJ3xEMjj31SpZmYXORCePVCQfMOWVKEhtNay-v59FcnCOQWm9w@mail.gmail.com>
 <20150520002915.GD16941@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150520002915.GD16941-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 5/20/2015 3:29 AM, Jason Gunthorpe wrote:
> On Tue, May 19, 2015 at 10:30:00PM +0300, Or Gerlitz wrote:
>> >Are you objecting adding the clock frequency and mask to the qeury device verb?
>> >why?
> Lets see the verbs side and I'll let you know.

You mean the user series of libibverbs/libmlx4? I don't see why this 
should be a must for the review of the kernel bits. The user-space code 
is coming up soon, sure, but we should be able to review kernel patches 
without requiring to actually see the user-space code.

As the change-logs here explained, the clock frequency is needed for 
applications to convert the HCA clock delta (current time - timestamp on 
WC) into nano-secs and such.The mask is needed to realize how many bits
from the 64b time-stamp are supported by the HW.

>
>> >If not, are objecting using the vendor specific track of the verb to
>> >pass from the vendor driver to the vendor library this or that detail
>> >which is needed for proper operation? why?
> I'm uncomfortable seeing otherwise vendor-neutral calls gain vendor
> extensions.

But this is whole purpose of the udata framework in uverbs, right? for 
each uverb command the vendor user-space library has a well defined 
channel to communicate directly with the low level vendor driver 
throughout the uverbs channels.

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
