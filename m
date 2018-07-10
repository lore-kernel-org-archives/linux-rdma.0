From: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 3/3] IB/srpt: Fix a use-after-free
Date: Tue, 10 Jul 2018 22:44:35 +0200
Message-ID: <20180710204435.GA23028@kroah.com>
References: <20180710173200.19853-1-bart.vanassche@wdc.com>
 <20180710173200.19853-4-bart.vanassche@wdc.com>
 <20180710185144.GA11114@kroah.com>
 <76bc5a122c637f9050d9a8d1b4b91e6cb386561f.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <76bc5a122c637f9050d9a8d1b4b91e6cb386561f.camel@wdc.com>
Sender: stable-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "jgg@ziepe.ca" <jgg@ziepe.ca>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "dledford@redhat.com" <dledford@redhat.com>, "stable@vger.kernel.org" <stable@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Jul 10, 2018 at 08:23:01PM +0000, Bart Van Assche wrote:
> On Tue, 2018-07-10 at 20:51 +0200, Greg KH wrote:
> > On Tue, Jul 10, 2018 at 10:32:00AM -0700, Bart Van Assche wrote:
> > > diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
> > > index 325bae29e90d..705f6a992d82 100644
> > > --- a/drivers/infiniband/ulp/srpt/ib_srpt.c
> > > +++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
> > > @@ -2152,6 +2152,7 @@ static int srpt_cm_req_recv(struct srpt_device *const sdev,
> > >  	}
> > >  
> > >  	kref_init(&ch->kref);
> > > +	kref_get(&ch->kref);
> > 
> > kref_init starts the reference count at at 1, so why do you need to
> > increment it right away?  That feels like something is "odd" here, why
> > do you start with 2 references in the same function?
> 
> Hi Greg,
> 
> An ib_srpt RDMA channel object (ch in the above code) must stay around as long
> as the associated target core session (se_sess) exists and also as long as the
> target core has not yet called srpt_close_session(). Hence the initialization of
> ch->kref to 2 just before an RDMA channel is registered with the target core.

Shouldn't the registration increment the reference?  Starting out at "2"
feels very "odd", don't you agree?

thanks,

greg k-h
