From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH libmlx4 v6 1/2] libmlx4: Infra-structure changes to
 support verbs extensions
Date: Tue, 4 Jun 2013 19:46:41 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A823736FD2CF18@ORSMSX109.amr.corp.intel.com>
References: <1364332591-22866-1-git-send-email-sean.hefty@intel.com>
 <51AE4288.4010505@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <51AE4288.4010505-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org" <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tzahi Oved <tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> > +
> >   #ifdef HAVE_IBV_REGISTER_DRIVER
> >   static __attribute__((constructor)) void mlx4_register_driver(void)
> >   {
> > -	ibv_register_driver("mlx4", mlx4_driver_init);
> > +	verbs_register_driver("mlx4", mlx4_driver_init);
> > +
> >   }
> >   #else
> 
> Shouldn't ibv_register_driver() need to be called in the lib constructor
> function if HAVE_IBV_REGISTER_DRIVER is not defined?

?  If HAVE_IBV_REGISTER_DRIVER is not defined, then we can't call ibv_register_driver...

We should just remove the HAVE_IBV_... check completely, since with this change, libmlx4 requires an updated version of libibverbs.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
