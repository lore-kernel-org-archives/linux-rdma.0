From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 7/9] ib/pma: add include file for IBA performance
 counters definitions
Date: Wed, 15 Jun 2011 23:51:32 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A823730214C8@ORSMSX101.amr.corp.intel.com>
References: <alpine.LRH.2.00.1106151733410.15844@ogerlitz.voltaire.com>
	<alpine.LRH.2.00.1106151747390.15844@ogerlitz.voltaire.com>
	<1828884A29C6694DAF28B7E6B8A8237302148F@ORSMSX101.amr.corp.intel.com>
 <20110615164619.994a49a4.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110615164619.994a49a4.weiny2-i2BcT+NCU+M@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> PM is defined in the spec glossary to be "Partition Manager".  :-(
> Therefore I have refrained from using "PM" or "pm" in structs or defines.
> I would not mind settling on an abbreviation; "PMA" perhaps?

The spec also lists the glossary at the front... :P  I have no issues with PMA, I was more concerned being consistent with other areas of the code.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
