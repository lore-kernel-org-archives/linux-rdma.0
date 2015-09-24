From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] IB: merge struct ib_device_attr into struct ib_device
Date: Thu, 24 Sep 2015 08:41:17 +0300
Message-ID: <56038CFD.8030908@mellanox.com>
References: <1443023567-13259-1-git-send-email-hch@lst.de>
 <1443023567-13259-2-git-send-email-hch@lst.de>
 <8BE4B1B3-54CD-46D1-9BBD-9149F6219468@oracle.com>
 <20150923184106.GA7759@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150923184106.GA7759-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 9/23/2015 9:41 PM, Christoph Hellwig wrote:
> On Wed, Sep 23, 2015 at 10:23:15AM -0700, Chuck Lever wrote:
>> Getting rid of ib_query_device() makes sense. Moving the device
>> attributes into ib_device is nice. Getting rid of ib_device_attr
>> is of questionable value. Why do we need to go there?
>>
>> IB core API changes generate merge conflicts with feature work
>> in the ULPs. It=E2=80=99s a pain for maintainers. In this particular
>> case, keeping ib_device_attr would greatly reduce ULP churn.
> But it will keep a totally nonsenical structure around in the future.
>
> Note that the whole in-kernel Verbs API is a bit of a nightmare, so
> there will be all kinds of larger changes.  Better get it right as lo=
ng
> as we have as few ULPs as we have now.
>

Christoph,

We had a smaller volume move to cache the device attributes on the IB=20
device structure, and I just
realized it was dropped on the floor. Ira, that was a reviewer comment=20
you got when worked on OPA
and I missed the fact it didn't reach to acceptance=20
http://marc.info/?t=3D142309310600006&r=3D1&w=3D2
I vote for 1st and most doing this and taking things from there.

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
