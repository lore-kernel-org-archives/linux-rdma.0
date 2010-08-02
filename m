From: Tom Tucker <tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: [RFC PATCH] libmthca: Add support for the reg_io_mr verb.
Date: Mon, 02 Aug 2010 11:34:30 -0500
Message-ID: <4C56F396.3080209@opengridcomputing.com>
References: <20100729163624.15024.57249.stgit@build.ogc.int>	<20100729163650.15024.66012.stgit@build.ogc.int> <E113D394D7C5DB4F8FF691FA7EE9DB443B3910A85A@MTLMAIL.mtl.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <E113D394D7C5DB4F8FF691FA7EE9DB443B3910A85A-WQlSmcKwN8Te+A/uUDamNg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tziporet Koren <tziporet-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Cc: Tom Tucker <tom-/Yg/VP3ZvrM@public.gmane.org>, "rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org" <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "brandt-4OHPYypu0djtX7QSmKvirg@public.gmane.org" <brandt-4OHPYypu0djtX7QSmKvirg@public.gmane.org>, "swise-/Yg/VP3ZvrM@public.gmane.org" <swise-/Yg/VP3ZvrM@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Tziporet Koren wrote:
> Hi Tom,
> What is the purpose of this?
> Is there a reason you did it only for mthca and not mlx4?
>
> Tziporet
>   
Hi Tziporet,

I just picked mthca arbitrarily to demonstrate how to do it. If people 
like the verb, then I'll do it for all the devices, but I didn't want to 
do all that work when there are likely to be changes.

But the point is that this is certainly not a mthca only functionality.

Thanks,
Tom

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
