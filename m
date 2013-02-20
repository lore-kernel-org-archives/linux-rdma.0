From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 1/7] libibumad: Provide MAD definitions with libibumad
Date: Wed, 20 Feb 2013 16:07:59 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A823736F34E958@ORSMSX101.amr.corp.intel.com>
References: <1359409135-559-1-git-send-email-sean.hefty@intel.com>
 <5124F212.2060503@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5124F212.2060503-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> > +/* RMPP information */
> > +#define UMAD_RMPP_VERSION		1
> > +enum {
> > +	UMAD_RMPP_TYPE_DATA		= 1,
> > +	UMAD_RMPP_TYPE_ACK		= 2,
> > +	UMAD_RMPP_TYPE_STOP		= 3,
> > +	UMAD_RMPP_TYPE_ABORT		= 4,
> > +
> > +	UMAD_RMPP_FLAG_MASK		= 0x07,
> > +	UMAD_RMPP_FLAG_ACTIVE		= 1,
> > +	UMAD_RMPP_FLAG_FIRST		= (1 << 1),
> > +	UMAD_RMPP_FLAG_LAST		= (1 << 2),
> > +
> > +	UMAD_RMPP_RESP_TIME_SHIFT	= 3,
> > +	UMAD_RMPP_NO_RESP_TIME		= 0x1F,
> > +
> > +	UMAD_RMPP_STATUS_SUCCESS	= 0,
> > +	UMAD_RMPP_STATUS_RESX		= 1,
> > +	UMAD_RMPP_STATUS_ABORT_MIN	= 118,
> > +	UMAD_RMPP_STATUS_T2L		= 118,
> > +	UMAD_RMPP_STATUS_BAD_LEN	= 119,
> > +	UMAD_RMPP_STATUS_BAD_SEG	= 120,
> > +	UMAD_RMPP_STATUS_BADT		= 121,
> > +	UMAD_RMPP_STATUS_W2S		= 122,
> > +	UMAD_RMPP_STATUS_S2B		= 123,
> > +	UMAD_RMPP_STATUS_BAD_STATUS	= 124,
> > +	UMAD_RMPP_STATUS_UNV		= 125,
> > +	UMAD_RMPP_STATUS_TMR		= 126,
> > +	UMAD_RMPP_STATUS_UNSPEC		= 127,
> > +	UMAD_RMPP_STATUS_ABORT_MAX	= 127
> > +};
> 
> Should RMPP be included here as it's not currently exposed to user space ?

I need to check the kernel code, but I believe that the RMPP header is exposed.

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
