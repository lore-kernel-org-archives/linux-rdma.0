From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH] Support for Chelsio T6 devices
Date: Tue, 20 Sep 2016 09:12:13 -0500
Message-ID: <004401d21348$fc2c9940$f485cbc0$@opengridcomputing.com>
References: <20160919200957.8777AE0BC1@smtp.ogc.us> <20160920102108.GG26673@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160920102108.GG26673-2ukJVAZIZ/Y@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Leon Romanovsky' <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: 'Gil Rockah' <gilr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

> > diff --git a/src/perftest_parameters.h b/src/perftest_parameters.h
> > index 448e398..727a65f 100755
> > --- a/src/perftest_parameters.h
> > +++ b/src/perftest_parameters.h
> > @@ -269,7 +269,8 @@ enum ctx_device {
> >  	CONNECTX4		= 10,
> >  	CONNECTX4LX		= 11,
> >  	QLOGIC_E4		= 12,
> > -	QLOGIC_AH		= 13
> > +	QLOGIC_AH		= 13,
> > +	CHELSIO_T6		= 14
> 
> Nit comment,
> if you use "14," and not "14", the next submitter will send patch with
> less churn.

Yup.  I usually try to adhere to the coding style of the existing code though. 



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
