From: "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
Subject: Re: [PATCH v2 00/10] iSER support for remote invalidate
Date: Wed, 06 Jan 2016 10:43:16 -0800
Message-ID: <1452105796.26125.28.camel@haakon3.risingtidesystems.com>
References: <1449663128-368-1-git-send-email-sagig@mellanox.com>
	 <1450671628.25674.27.camel@haakon3.risingtidesystems.com>
	 <20151224101514.GB6438@infradead.org> <567BC782.7090501@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <567BC782.7090501-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jenny Derzhavetz <jennyf-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, 2015-12-24 at 12:22 +0200, Sagi Grimberg wrote:
> >> Applied to target-pending/for-next as v4.5-rc1 material, along with
> >> Reviewed-by tags from HCH.
> >
> > So this is both in your and Dougs now it seems.  Given the non-trivial
> > merge with the other RDMA updates I'd suggest to drop it from the
> > target tree as Doug already sorted out the merge.
> 
> Yea, this conflicts with the CQ API stuff. Doug and I sorting it out.
> 

FYI, the only conflict as reported in linux-next last week is with nfsd
tree and "IB: merge struct ib_device_attr into struct ib_device" here:

http://marc.info/?l=linux-next&m=145155049101826&w=2

It looks like there is ongoing discussion this morning wrt rdma + nfsd
trees..

Do you still want this series dropped from target-pending/for-next..?







--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
