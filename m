From: stuarts <stuarts-dK3M3PVJaX4iXRBKUn1UN0EOCMrvLtNR@public.gmane.org>
Subject: Re: Multicast joins failing on 1.5-rc1? (OFED BACKPORT BUG)
Date: Thu, 22 Oct 2009 10:08:20 -0500
Message-ID: <3BAE2C3C-9724-47C6-BF44-EF0CDD47612C@routingdynamics.com>
References: <A5E1097A-DFEA-4508-A47F-FF07C34EA525@routingdynamics.com> <f0e08f230910201152g476383ffp8e7392dc0c48e41@mail.gmail.com> <C28CB83A-CF52-4603-91DF-D56865CBEA98@routingdynamics.com> <20091021202346.GO14520@obsidianresearch.com> <A53D7B2B-EE41-4ABC-BC02-EE9A100C5DD8@routingdynamics.com> <20091021220837.GP14520@obsidianresearch.com>
Mime-Version: 1.0 (Apple Message framework v1076)
Content-Type: text/plain; charset=us-ascii; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20091021220837.GP14520-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


On Oct 21, 2009, at 5:08 PM, Jason Gunthorpe wrote:

> On Wed, Oct 21, 2009 at 04:43:53PM -0500, stuarts wrote:
>
>>>
<snip patch, etc>
>
> This is better than the current stuff since it preserves the intent of
> the ip_ib_mc_map patches, and it adjusts the dmi_addr directly so ip
> maddr reports the correct address to aid in debugging.
>
>> Sorry for the extra goop in there. This is gone from the mainline
>> kernel, so it is RHEL5.4 + backport that seems to be the problem.
>
> Correct. We need someone to pick up the above patch for the
> backports. I don't know who that is (someone please speak up?)
>
> If you can confirm the above does it for you then it would probably
> help the backporter.

Confirmed. I have multicast again!

Shall I open a bug, or has one already been done?

Thanks, --stuart


--
Stuart Stanley
M: 952-457-3790
stuarts-dK3M3PVJaX4iXRBKUn1UN0EOCMrvLtNR@public.gmane.org
--
"Not bad for a man in his jim jams. Very Aurther Dent. Now, there was  
a nice man." - The Doctor in Dr. Who:"The Christmas Invasion"

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
