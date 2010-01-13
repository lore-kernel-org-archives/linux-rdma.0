From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH] rdma_cm.h: Fix SCTP protocol ID
Date: Wed, 13 Jan 2010 13:11:52 -0800
Message-ID: <7E10F17E68C24836BE68F8F22B64862B@amr.corp.intel.com>
References: <20100113192454.GA17655@comcast.net> <adaska9n2d3.fsf@roland-alpha.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <adaska9n2d3.fsf-BjVyx320WGW9gfZ95n9DRSW4+XlvGpQz@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Roland Dreier' <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hnrose-Wuw85uim5zDR7s880joybQ@public.gmane.org>
Cc: rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

>The old wrong value has been there since we first merged this.  So
>changing it means anything using this in userspace would be broken.  But
>is PS_SCTP exported to userspace?  And as far as I can tell PS_SCTP is
>not implemented (this line is the only reference to RDMA_PS_SCTP in the
>whole kernel).  So would it make more sense to delete this enum value entirely?

Technically, I believe it's available to userspace, though the librdmacm doesn't
define it.  I'd be surprised if anything uses it.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
