From: Potnuri Bharat Teja <bharat@chelsio.com>
Subject: Re: [PATCH] infiniband: cxgb4: fix a potential NULL pointer
 dereference
Date: Thu, 28 Mar 2019 19:50:23 +0530
Message-ID: <20190328142022.GA13931@chelsio.com>
References: <20190309051921.15212-1-kjlu@umn.edu>
 <CC1E06D8-7817-4314-AAD4-434FEB8C4157@umn.edu>
 <20190327133728.GA26660@chelsio.com>
 <20190328124037.GJ21008@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190328124037.GJ21008@ziepe.ca>
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Kangjie Lu <kjlu@umn.edu>, "pakki001@umn.edu" <pakki001@umn.edu>, Doug Ledford <dledford@redhat.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Thursday, March 03/28/19, 2019 at 18:10:37 +0530, Jason Gunthorpe wrote:
> On Wed, Mar 27, 2019 at 07:08:54PM +0530, Potnuri Bharat Teja wrote:
> > On Saturday, March 03/23/19, 2019 at 08:07:46 +0530, Kangjie Lu wrote:
> > > 
> > > 
> > > > On Mar 8, 2019, at 11:19 PM, Kangjie Lu <kjlu@umn.edu> wrote:
> > > > 
> > > > get_skb may fail and return NULL. The fix returns "ENOMEM"
> > > > when it fails to avoid NULL dereference.
> > > > 
> > > > Signed-off-by: Kangjie Lu <kjlu@umn.edu>
> > > > drivers/infiniband/hw/cxgb4/cm.c | 3 +++
> > > > 1 file changed, 3 insertions(+)
> > > > 
> > > > diff --git a/drivers/infiniband/hw/cxgb4/cm.c b/drivers/infiniband/hw/cxgb4/cm.c
> > > > index 8221813219e5..502a54d57e2c 100644
> > > > +++ b/drivers/infiniband/hw/cxgb4/cm.c
> > > > @@ -1919,6 +1919,9 @@ static int send_fw_act_open_req(struct c4iw_ep *ep, unsigned int atid)
> > > > 	int win;
> > > > 
> > > > 	skb = get_skb(NULL, sizeof(*req), GFP_KERNEL);
> > > > +	if (!skb)
> > > > +		return -ENOMEM;
> > > > +
> > > 
> > > Can someone review this patch? Thanks.
> > 
> > Sorry for the late response.
> > I recommend an error print before the return.
> > if (!skb) {
> > 	pr_err("%s - failed to alloc skb\n", __func__);
> > 	return -ENOMEM;
> > }
> 
> no error prints on memory allocation failure, the kernel already
> prints enough on this
Ok.

Acked-by: Potnuri Bharat Teja <bharat@chelsio.com>
