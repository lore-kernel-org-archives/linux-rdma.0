From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [RFC PATCH] rxe: Fix structure layouts for 32/64 bit compat
Date: Wed, 7 Feb 2018 16:57:25 -0700
Message-ID: <20180207235725.GA9080@ziepe.ca>
References: <20180207234153.GA14067@ziepe.ca>
 <1518047664.2870.82.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1518047664.2870.82.camel-Sjgp3cTcYWE@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>
Cc: "matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Feb 07, 2018 at 11:54:25PM +0000, Bart Van Assche wrote:
> On Wed, 2018-02-07 at 16:41 -0700, Jason Gunthorpe wrote:
> > diff --git a/include/uapi/rdma/rdma_user_rxe.h b/include/uapi/rdma/rdma_user_rxe.h
> > index e3e6852b58eb45..b501deb18d8184 100644
> > +++ b/include/uapi/rdma/rdma_user_rxe.h
> > @@ -58,6 +58,8 @@ struct rxe_global_route {
> >  struct rxe_av {
> >  	__u8			port_num;
> >  	__u8			network_type;
> > +	__u16			reserved1;
> > +	__u32			reserved2;
> 
> Hello Jason,
> 
> Seeing two consecutive reserved members is a bit weird. Have you considered
> to use something like __u8 reserved[6] instead?

Ah, I had that originally but changed it to make pahole work properly..
Can switch it back.

Although, this does really firmly say what the alighment is, eg
down the road someone might be tempted to do:

- __u8 reserved[6];
+ __u32 new_value;
+ __u16 reserved;

Which would be quite wrong..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
