From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH for-next 09/10] IB/mlx4: Add timestamp_mask and
 hca_core_clock to query_device
Date: Tue, 26 May 2015 11:10:45 +0300
Message-ID: <CAJ3xEMinNsQrmQ7atAVkshefBDBQ1HRuGbOT_cJ4RxEj4dWUPA@mail.gmail.com>
References: <1431869786-6308-1-git-send-email-ogerlitz@mellanox.com>
	<1431869786-6308-10-git-send-email-ogerlitz@mellanox.com>
	<20150519185801.GM18675@obsidianresearch.com>
	<20150519190031.GN18675@obsidianresearch.com>
	<CAJ3xEMiO2y6G5YzzkGC1M=XB6yrtNJ7jj13pTUAee1TssiYwkQ@mail.gmail.com>
	<20150519191553.GP18675@obsidianresearch.com>
	<CAJ3xEMjj31SpZmYXORCePVCQfMOWVKEhtNay-v59FcnCOQWm9w@mail.gmail.com>
	<20150520002915.GD16941@obsidianresearch.com>
	<555C9D00.2090609@mellanox.com>
	<1432134677.5304.23.camel@opteya.com>
	<CAJ3xEMjO2HqFePAwXnoCt0rCzRLfYbqdP+883v4LaMovj7Y-FA@mail.gmail.com>
	<CAJ3xEMgppUPqOFm7L0+fR3z_N2ALZFb+GpSAGvyyNROZoFCUPA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJ3xEMgppUPqOFm7L0+fR3z_N2ALZFb+GpSAGvyyNROZoFCUPA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sat, May 23, 2015 at 7:26 AM, Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> On Wed, May 20, 2015 at 8:53 PM, Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> On Wed, May 20, 2015 at 6:11 PM, Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org> wrote:
>>
>>>> But this is whole purpose of the udata framework in uverbs, right? for
>>>> each uverb command the vendor user-space library has a well defined
>>>> channel to communicate directly with the low level vendor driver
>>>> throughout the uverbs channels.
>>
>>> Uverbs convey information between kernel and userspace drivers to
>>> implement verbs for userspace application. I don't think it's designed
>>> to allow vendor to add random extensions in the best way with regard to
>>> backward/forward compability.
>>
>> Disagree that this is random extension. The people that designed this
>> stack 10y ago (Roland and Co.) looked very nicely forward and realized
>> that not all the HW are the same nor can be put 101% under the same
>> API with no way out, and hence they came up with udata.
>>
>> Please state how you see the role of the uverbs udata mechanism.
>
> Guys, still waiting to hear why you think it's wrong here to use the
> mechanism which was built from day-1 for the purpose of allowing the
> user-space driver library to communicate with the kernel driver and
> pass values in both directions.

Jason, ping, it's fair to require that if you made a review argument against
the design done here and we've responded about a week ago, saying why
this design is valid (e.g goes along the 10y old IB stack udata mechanism and
such) -- you would comment on the response and not  leave it in the air.

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
