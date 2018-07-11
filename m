From: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 3/3] IB/srpt: Fix a use-after-free
Date: Wed, 11 Jul 2018 11:45:59 +0200
Message-ID: <20180711094559.GB5492@kroah.com>
References: <20180710173200.19853-1-bart.vanassche@wdc.com>
 <20180710173200.19853-4-bart.vanassche@wdc.com>
 <20180710185144.GA11114@kroah.com>
 <76bc5a122c637f9050d9a8d1b4b91e6cb386561f.camel@wdc.com>
 <20180710204435.GA23028@kroah.com>
 <1ab0cbf69675ecd942a77f6f71b9d51359a2df86.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1ab0cbf69675ecd942a77f6f71b9d51359a2df86.camel@wdc.com>
Sender: stable-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "jgg@ziepe.ca" <jgg@ziepe.ca>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "dledford@redhat.com" <dledford@redhat.com>, "stable@vger.kernel.org" <stable@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Jul 10, 2018 at 09:02:51PM +0000, Bart Van Assche wrote:
> On Tue, 2018-07-10 at 22:44 +0200, gregkh@linuxfoundation.org wrote:
> > On Tue, Jul 10, 2018 at 08:23:01PM +0000, Bart Van Assche wrote:
> > > On Tue, 2018-07-10 at 20:51 +0200, Greg KH wrote:
> > > > On Tue, Jul 10, 2018 at 10:32:00AM -0700, Bart Van Assche wrote:
> > > > > diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
> > > > > index 325bae29e90d..705f6a992d82 100644
> > > > > --- a/drivers/infiniband/ulp/srpt/ib_srpt.c
> > > > > +++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
> > > > > @@ -2152,6 +2152,7 @@ static int srpt_cm_req_recv(struct srpt_device *const sdev,
> > > > >  	}
> > > > >  
> > > > >  	kref_init(&ch->kref);
> > > > > +	kref_get(&ch->kref);
> > > > 
> > > > kref_init starts the reference count at at 1, so why do you need to
> > > > increment it right away?  That feels like something is "odd" here, why
> > > > do you start with 2 references in the same function?
> > > 
> > > An ib_srpt RDMA channel object (ch in the above code) must stay around as long
> > > as the associated target core session (se_sess) exists and also as long as the
> > > target core has not yet called srpt_close_session(). Hence the initialization of
> > > ch->kref to 2 just before an RDMA channel is registered with the target core.
> > 
> > Shouldn't the registration increment the reference?  Starting out at "2"
> > feels very "odd", don't you agree?
> 
> Hello Greg,
> 
> The code that registers the session with the target core is in another driver
> (SCSI target core) and that driver doesn't know about the abstractions maintained
> by the ib_srpt driver.

Ok, but then that registration shouldn't be dropping a reference either,
right?

> That's why the above kref_get() call is in the ib_srpt
> driver and not e.g. in the target_alloc_session() function.

But I still do not understand why you have 2 on the count here.  Why do
you need that?

> BTW, there is more code in the Linux kernel that follows the above pattern.
> target_submit_cmd_map_sgls() initializes the se_cmd reference count to two as
> follows:
> * transport_init_se_cmd() initializes it to one.
> * target_get_sess_cmd() increments it from one to two.

That is two different areas of the code, right?  That is not "initialize
the count to 2 when we first create it".

> This is because two contexts keep a reference to se_cmd data structures,
> namely the target core and the target driver. A SCSI target command data
> structure (se_cmd) must only be freed after both contexts have finished their
> part of the command processing.

It's your subsytem, I'm just trying to point out that this pattern you
have created is very odd and is probably wrong.  If you all insist it is
correct, that's great, but I did warn you :)

good luck!

greg k-h
