From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH 3/3] IB/srpt: Fix a use-after-free
Date: Tue, 10 Jul 2018 15:36:32 -0600
Message-ID: <20180710213632.GA24930@ziepe.ca>
References: <20180710173200.19853-1-bart.vanassche@wdc.com>
 <20180710173200.19853-4-bart.vanassche@wdc.com>
 <20180710183823.GD8266@ziepe.ca>
 <8aebefee907dc858250dfdb47d6f1ca0f9f2db53.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <8aebefee907dc858250dfdb47d6f1ca0f9f2db53.camel@wdc.com>
Sender: stable-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>, "dledford@redhat.com" <dledford@redhat.com>, "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Jul 10, 2018 at 08:19:20PM +0000, Bart Van Assche wrote:
> On Tue, 2018-07-10 at 12:38 -0600, Jason Gunthorpe wrote:
> > On Tue, Jul 10, 2018 at 10:32:00AM -0700, Bart Van Assche wrote:
> > > diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
> > > index 325bae29e90d..705f6a992d82 100644
> > > +++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
> > > @@ -2152,6 +2152,7 @@ static int srpt_cm_req_recv(struct srpt_device *const sdev,
> > >  	}
> > > 
> > >  	kref_init(&ch->kref);
> > > +	kref_get(&ch->kref);
> > 
> > Oh that is ugly, can you put the 'get' closer to the the place that
> > stores the ch pointer this kref is protecting? Perhaps it is one of
> > the list_add's in this function?
> > 
> > Guessing the kref created kref_init should probably belong to target_core's
> > 'se_sess->fabric_sess_ptr' ..
> 
> Hello Jason,
> 
> Can you clarify your second paragraph? The ib_srpt driver has been implemented
> such that sess->fabric_sess_ptr == ch as long as a session exists.

In my view that means sess->fabric_sess_ptr is the pointer that
'owns' the kref_init's value - ie the kref_init pairs with the
kref_put added in your patch.

The question here, is what kref_put does the 2nd kref_get pair with?
When you identify that, then move the kref_get closer to the
assignment to the 'owning' pointer.

krefs are very tricky, I find it is best to be very rigorous with
them, and place some notes about how they pair and what storage is
'owning' each kref.

eg if you put something in a list, and incr the kref when doing so,
then place the kref_get near the list_add, and the kref_put near the
list_del. That gives somebody else a chance to understand that the
list_head is holding the kref.

And you have to be careful when sharing the stack kref with something
else - eg if a list_add 'moves' a stack kref into a list then another
thread can race and do list_del and put, even though the first thread
is still accessing the memory on its stack. Often times these
'publish' actions must be last in a function, or more krefs are
needed.

This is a really annoying bug class with krefs I find from time to time..

Jason
