From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v6 for-4.13 0/7] Automatic affinity settings for nvme
 over rdma
Date: Fri, 04 Aug 2017 15:18:47 -0400
Message-ID: <1501874327.79618.12.camel@redhat.com>
References: <1497796677-15794-1-git-send-email-sagi@grimberg.me>
         <20170619122806.GA29061@lst.de> <20170626100113.GA14446@lst.de>
         <7a91bc31-9a4d-a07c-002d-af06143c4257@grimberg.me>
         <2eecc5bb-e356-73e5-a2fc-1f1867a779f3@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <2eecc5bb-e356-73e5-a2fc-1f1867a779f3-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Saeed Mahameed <saeedm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, 2017-08-03 at 18:22 +0300, Sagi Grimberg wrote:
> Doug,
> 
> > > > Thanks Sagi,
> > > > 
> > > > the whole series looks great to me.
> > > > 
> > > > It would be even nicer if the maintainers of the various HCA
> > > > drivers
> > > > could look into adding support..
> > > 
> > > Did we make any progress on getting this included?
> > 
> > AFAICT, its waiting for Doug to pick it up...
> > 
> > Not sure if Saeed is planning to run any tests on this,
> > but its clearly agreed that this is the direction all parties
> > want to take, and we have 6-9 rc's to hash out any issues if
> > exist...
> > 
> > > It would be sad to miss another merge window..
> > 
> > I hope we don't...
> 
> Are you picking this up for 4.14? This already missed two merge
> windows..

You're confusing me Sagi.  This thread is the v6 of this patchset. 
Don't you have a v8 of this patchset in this mailing list?  Are you
saying you want me to grab v6 and not v8, or are you asking in the
wrong thread?

-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
