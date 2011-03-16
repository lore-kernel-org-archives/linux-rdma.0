From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: IB: increase DMA max_segment_size on Mellanox hardware
Date: Wed, 16 Mar 2011 21:17:18 +0200
Message-ID: <AANLkTikPa8B86QVoxQLB5DjYAQrUY39pSMG9m_Kh8qpN@mail.gmail.com>
References: <1295230184.2574.26.camel@obelisk.thedillows.org>
	<4D342510.80701@voltaire.com>
	<1295318783.3051.81.camel@obelisk.thedillows.org>
	<4D353E5E.2020500@voltaire.com>
	<1295353524.3051.121.camel@obelisk.thedillows.org>
	<4D380AF2.4010905@voltaire.com>
	<1295525737.22825.24.camel@obelisk.thedillows.org>
	<4D3D9845.4050803@voltaire.com>
	<1295897819.29946.17.camel@lap75545.ornl.gov>
	<1297904810.8833.44.camel@lap75545.ornl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1297904810.8833.44.camel-FqX9LgGZnHWDB2HL1qBt2PIbXMQ5te18@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Feb 17, 2011 at 3:06 AM, David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org> wrote:
>> I don't see anything that would have a problem with larger DMA segment
>> sizes; some of them would see small efficiency gains similar to SRP if
>> more small segments could be coalesced into fewer larger ones.

>Is there still any concern about that patch possibly being wrong?
>Because I'd be inclined to merge it at this point.

Roland, what's your take on this patch? also I didn't had the chance
to test with it, I will be able to do so early next week, so when you
intend to send the 2nd pull request for this window?

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
