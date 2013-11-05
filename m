From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH for-next V1 0/8] uverbs extensions fixes
Date: Tue, 5 Nov 2013 15:23:15 +0200
Message-ID: <5278F143.5070001@mellanox.com>
References: <1383126771-7658-1-git-send-email-matanb@mellanox.com> <1383642320.18301.46.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1383642320.18301.46.camel-bi+AKbBUZKY6gyzm1THtWbp2dZbC/Bob@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 05/11/2013 11:05, Yann Droneaud wrote:
> Thanks Matan for carrying on the patchset.
>
> I've quite the same patchset, but the other way around, eg. enabling
> the flow steering verbs after cleanup on the new ABI. I thought it would
> make more sense this way. Would you like me to send the patchset this
> way, with my others patches to rename the function, which was dropped
> from my latest attempt in order to squeeze the patchset to bare minimal ?

good! lets do that asap, please make sure to mark the series as V2 and 
list the changes from V1 in the cover-letter

> Regarding the extensible framework, I haven't found time to design a new
> proposal for the interface.
>
> I keep in my mind that something built around writev(2) (struct iovec)
> and/or cmsg(3) / netlink(3) would be preferable to ease sending
> multipart command to uverbs subsystem.

Well, we do want the solution to use the uverbs framework and not 
involve another paradigm for user/kernel verbs interaction. With this in 
mind && as Matan and Tzahi wrote you earlier on the list, we do think 
the current proposal is good enough to carry on with.


> BTW, I think we should drop the patch that adds the comp_mask in the
> header. As you wrote in a previous mail, a comp_mask could be present
> in the "provider" part of the command. This make handling of comp_mask
> from header very different, very specific, while it's not, since there
> could be more "comp_mask": one in command, one in provider, one in
> response and one in the provider response parts. So I would prefer not
> have the command comp_mask being treated differently than the other.

makes sense.

Matan and Or.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
