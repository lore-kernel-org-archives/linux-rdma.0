From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH for-next V1 0/8] uverbs extensions fixes
Date: Wed, 6 Nov 2013 17:02:56 +0200
Message-ID: <527A5A20.5050907@mellanox.com>
References: <1383126771-7658-1-git-send-email-matanb@mellanox.com> <1383642320.18301.46.camel@localhost.localdomain> <5278F143.5070001@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5278F143.5070001-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 05/11/2013 15:23, Or Gerlitz wrote:
> On 05/11/2013 11:05, Yann Droneaud wrote:
>> Thanks Matan for carrying on the patchset.
>>
>> I've quite the same patchset, but the other way around, eg. enabling
>> the flow steering verbs after cleanup on the new ABI. I thought it would
>> make more sense this way. Would you like me to send the patchset this
>> way, with my others patches to rename the function, which was dropped
>> from my latest attempt in order to squeeze the patchset to bare 
>> minimal ?
>
> good! lets do that asap, please make sure to mark the series as V2 and 
> list the changes from V1 in the cover-letter

Yann, again, we have put the patches months ago on this list, your 
initial review comments arrived only after the code was accepted, but 
aligned with them and agreed it would be better to delay the uverbs 
extensions support to 3.13 such that the API is cleaner and more robust.

Roland, no way we can effort to loose another quarter just b/c Yan  is 
slow to send his final proposed patch series. We are already into the 
3.13 merge window and time is running out.

Yann, can you send today the V2 series with the two minor comments you 
had and we agreed addressed?!

Or.


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
