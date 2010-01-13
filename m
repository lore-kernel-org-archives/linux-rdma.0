From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] rdma_cm.h: Fix SCTP protocol ID
Date: Wed, 13 Jan 2010 13:04:08 -0800
Message-ID: <adaska9n2d3.fsf@roland-alpha.cisco.com>
References: <20100113192454.GA17655@comcast.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100113192454.GA17655-Wuw85uim5zDR7s880joybQ@public.gmane.org> (Hal Rosenstock's message of
	"Wed, 13 Jan 2010 14:24:54 -0500")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hnrose-Wuw85uim5zDR7s880joybQ@public.gmane.org>
Cc: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


 > -	RDMA_PS_SCTP  = 0x0183
 > +	RDMA_PS_SCTP  = 0x0184

The old wrong value has been there since we first merged this.  So
changing it means anything using this in userspace would be broken.  But
is PS_SCTP exported to userspace?  And as far as I can tell PS_SCTP is
not implemented (this line is the only reference to RDMA_PS_SCTP in the
whole kernel).  So would it make more sense to delete this enum value entirely?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
