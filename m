From: Jason Gunthorpe <jgg@mellanox.com>
Subject: Re: [PATCH rdma-next 1/5] RDMA/core: Provide getter and setter to
 access IB device name
Date: Thu, 20 Sep 2018 10:46:48 -0600
Message-ID: <20180920164648.GM30219@mellanox.com>
References: <20180920112202.9181-1-leon@kernel.org>
 <20180920112202.9181-2-leon@kernel.org>
 <20180920151541.GC30219@mellanox.com>
 <20180920164039.GM3519@mtr-leonro.mtl.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180920164039.GM3519@mtr-leonro.mtl.com>
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>
Cc: Doug Ledford <dledford@redhat.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, linux-s390@vger.kernel.org, Ursula Braun <ubraun@linux.ibm.com>, "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org, Selvin Xavier <selvin.xavier@broadcom.com>, Steve Wise <swise@chelsio.com>, Lijun Ou <oulijun@huawei.com>, Shiraz Saleem <shiraz.saleem@intel.com>, Ariel Elior <Ariel.Elior@cavium.com>, Christian Benvenuti <benve@cisco.com>, Adit Ranadive <aditr@vmware.com>, Dennis Dalessandro <dennis.dalessandro@intel.com>
List-Id: linux-rdma@vger.kernel.org

On Thu, Sep 20, 2018 at 07:40:39PM +0300, Leon Romanovsky wrote:

> > > The protection is done with global device_lock because it is used in
> > > allocation and deallocation phases. At this stage, this lock is not
> > > busy and easily can be moved to be per-device, once it will be needed.
> > >
> > > Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
> > >  drivers/infiniband/core/device.c | 24 +++++++++++++++++++++++-
> > >  include/rdma/ib_verbs.h          |  8 +++++++-
> > >  2 files changed, 30 insertions(+), 2 deletions(-)
> > >
> > > diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/device.c
> > > index 5a680a88aa87..3270cde6d806 100644
> > > +++ b/drivers/infiniband/core/device.c
> > > @@ -170,6 +170,14 @@ static struct ib_device *__ib_device_get_by_name(const char *name)
> > >  	return NULL;
> > >  }
> > >
> > > +void ib_device_get_name(struct ib_device *ibdev, char *name)
> > > +{
> > > +	down_read(&lists_rwsem);
> > > +	strlcpy(name, ibdev->name, IB_DEVICE_NAME_MAX);
> > > +	up_read(&lists_rwsem);
> > > +}
> > > +EXPORT_SYMBOL(ib_device_get_name);
> >
> > I think we have to follow netdev and just rely on device_rename()
> > being 'good enough'.
> >
> > Switch everything to use dev_name()/etc rather than try and do
> > something like this so the responsibility is on the device core to
> > keep this working, not us.
> >
> > Turns out I have a series for that for unrelated reasons..
> 
> And what should I do now with this knowledge?

Maybe I can send it today..

Jason
