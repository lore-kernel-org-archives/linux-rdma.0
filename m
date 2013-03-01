From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH] libibumad: add string functions for various enums
Date: Fri, 1 Mar 2013 22:28:02 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A823736F35620C@ORSMSX101.amr.corp.intel.com>
References: <20130301114034.85fdbe136d503d803cb167ae@llnl.gov>
	<51311E07.8070209@dev.mellanox.co.il>
	<20130301133305.29edc9171b3a264b277e34ed@llnl.gov>
	<1828884A29C6694DAF28B7E6B8A823736F3561BF@ORSMSX101.amr.corp.intel.com>
 <20130301140811.99423e66848a1509e08bc5ec@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130301140811.99423e66848a1509e08bc5ec-i2BcT+NCU+M@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Cc: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> If those reserve fields are either A) not correctly set to 0 or B) are used for
> some future status this function will fail.  Since the spec says to ignore them
> I would do something like.
> 
> 	status = ntohs(status);
> 	status &= 0x001F;
> 
> With a #define'd mask for 1F of course...  ;-)

Your proposed implementation already ignores those bits.  I'm confused.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
