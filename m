From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [rdma:k.o/for-next 5/34]
 drivers/infiniband/hw/hns/hns_roce_device.h:625:2: error: implicit
 declaration of function '__raw_writeq'
Date: Mon, 14 Aug 2017 11:18:38 -0400
Message-ID: <1502723918.83939.2.camel@redhat.com>
References: <201708131058.lKYk3TId%fengguang.wu@intel.com>
         <5fd6a0f7-cbe4-8bd9-5310-fa2d64ec6829@redhat.com>
         <4871c56c-ce7a-204a-0d54-5ea5aae604fd@mellanox.com>
         <20170814145656.GJ24282@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170814145656.GJ24282-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: kbuild test robot <fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, kbuild-all-JC7UmRfGjtg@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, 2017-08-14 at 17:56 +0300, Leon Romanovsky wrote:
> On Mon, Aug 14, 2017 at 05:47:59PM +0300, Matan Barak wrote:
> > On 14/08/2017 17:40, Doug Ledford wrote:
> > > On 8/12/2017 10:09 PM, kbuild test robot wrote:
> > > > tree:   https://git.kernel.org/pub/scm/linux/kernel/git/dledfor
> > > > d/rdma.git k.o/for-next
> > > > head:   d0d62c34fb746eaf68df5b3d6f4877c7d1e6320c
> > > > commit: e89bf462b6bece63a60723af88c76dce9dbe6b85 [5/34] IB/hns:
> > > > Support compile test for hns RoCE driver
> > > > config: xtensa-allyesconfig (attached as .config)
> > > > compiler: xtensa-linux-gcc (GCC) 4.9.0
> > > > reproduce:
> > > 
> > > Hi Matan,
> > > 
> > > I know you have a fix patch for this on list.  I'll grab it this
> > > week
> > > for sure, so you can ignore this.
> > > 
> > > 
> > 
> > Hi Doug,
> > 
> > Thanks :-)
> > Just to make things easier, this is the link to that patch:
> > https://www.spinics.net/lists/linux-rdma/msg52386.html
> > 
> > In addition, there are a few more patches worth taking to the
> > current RCs
> > that fix kernel crashes:
> > 
> > https://www.spinics.net/lists/linux-rdma/msg52485.html
> > https://www.spinics.net/lists/linux-rdma/msg52722.html
> > 
> > We have another one coming ("IB/uverbs: Fix NULL pointer
> > dereference during
> > device removal"). I guess Leon will post it soon.
> 
> I queued it today [1] and planned to submit it EOW.
> 
> Doug,
> Do you want me to send it earlier?
> 
> [1] https://git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma.g
> it/commit/?h=rdma-rc&id=c102f66c43cfc568065df6441890621fb6f03002

Pull it out.  I've already grabbed it off of patchworks and pushed it
out.  I wanted to make sure it hit today's rdma tree in Stephen's for-
next no matter what.

-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
