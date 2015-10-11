From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH] IB: merge struct ib_device_attr into struct ib_device
Date: Sun, 11 Oct 2015 19:16:27 +0300
Message-ID: <561A8B5B.1010309@dev.mellanox.co.il>
References: <1443023567-13259-1-git-send-email-hch@lst.de>
 <1443023567-13259-2-git-send-email-hch@lst.de>
 <8BE4B1B3-54CD-46D1-9BBD-9149F6219468@oracle.com>
 <20150923184106.GA7759@lst.de> <56038CFD.8030908@mellanox.com>
 <20150924133519.GA6291@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150924133519.GA6291-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 9/24/2015 4:35 PM, Christoph Hellwig wrote:
> On Thu, Sep 24, 2015 at 08:41:17AM +0300, Or Gerlitz wrote:
>>
>> We had a smaller volume move to cache the device attributes on the IB
>> device structure, and I just
>> realized it was dropped on the floor. Ira, that was a reviewer comment you
>> got when worked on OPA
>> and I missed the fact it didn't reach to acceptance
>> http://marc.info/?t=142309310600006&r=1&w=2
>> I vote for 1st and most doing this and taking things from there.
>
> I'm strongly against this.  As the reviews show the move is highly
> confusing.  The attributes don't change and there is no need to 'cache' or
> 'query' them.  Just merge them into the device, follow years of experience
> with how every other Linux subsystem does it and be done with it.

Umm, are we on board with this one?

Christoph, would you mind rebasing it on top of 4.3-rc4 or so? I
want to develop over it so I can test it on the fly.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
