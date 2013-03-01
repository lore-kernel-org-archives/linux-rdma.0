From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: Re: [PATCH] libibumad: add string functions for various enums
Date: Fri, 1 Mar 2013 14:08:11 -0800
Message-ID: <20130301140811.99423e66848a1509e08bc5ec@llnl.gov>
References: <20130301114034.85fdbe136d503d803cb167ae@llnl.gov>
	<51311E07.8070209@dev.mellanox.co.il>
	<20130301133305.29edc9171b3a264b277e34ed@llnl.gov>
	<1828884A29C6694DAF28B7E6B8A823736F3561BF@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A823736F3561BF-P5GAC/sN6hmkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, 1 Mar 2013 22:05:00 +0000
"Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:

> > Exactly, to "ignore" them we should mask off those bits and not expect them to
> > be 0 as is currently implemented.
> 
> Your proposed implementation for umad_common_mad_status_str() looks reasonable to me.  What changes were you thinking of?

Just what Hal and I discussed.

If those reserve fields are either A) not correctly set to 0 or B) are used for some future status this function will fail.  Since the spec says to ignore them I would do something like.

	status = ntohs(status);
	status &= 0x001F;

With a #define'd mask for 1F of course...  ;-)

Ira

> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
Ira Weiny
Member of Technical Staff
Lawrence Livermore National Lab
925-423-8008
weiny2-i2BcT+NCU+M@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
