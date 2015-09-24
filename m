From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH] IB: merge struct ib_device_attr into struct ib_device
Date: Thu, 24 Sep 2015 09:48:17 +0300
Message-ID: <56039CB1.2090706@dev.mellanox.co.il>
References: <1443023567-13259-1-git-send-email-hch@lst.de>
 <1443023567-13259-2-git-send-email-hch@lst.de>
 <8BE4B1B3-54CD-46D1-9BBD-9149F6219468@oracle.com>
 <20150923184106.GA7759@lst.de> <56038CFD.8030908@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <56038CFD.8030908-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

> Christoph,
>
> We had a smaller volume move to cache the device attributes on the IB
> device structure, and I just
> realized it was dropped on the floor. Ira, that was a reviewer comment
> you got when worked on OPA
> and I missed the fact it didn't reach to acceptance
> http://marc.info/?t=142309310600006&r=1&w=2
> I vote for 1st and most doing this and taking things from there.

That's also workable.

But Ira's patch is missing ib_query_device conversion to
simply take the cached device attributes.

I'm fine with either way to go.

Sagi.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
