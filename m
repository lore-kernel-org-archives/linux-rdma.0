From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH] IB/mlx4: Allow to always block UD multicast loopback
Date: Tue, 6 May 2014 20:20:43 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373992F8E07@ORSMSX109.amr.corp.intel.com>
References: <alpine.DEB.2.10.1404211308140.29240@gentwo.org>
 <53619638.48ae0e0a.2e40.ffffec09SMTPIN_ADDED_BROKEN@mx.google.com>
 <5361E5C7.5030805@mellanox.com>
 <1980561.1785.1398958457283.JavaMail.DougALedford@Phenom>
 <1828884A29C6694DAF28B7E6B8A82373992F869F@ORSMSX109.amr.corp.intel.com>
 <alpine.DEB.2.10.1405051754260.5069@gentwo.org>
 <1828884A29C6694DAF28B7E6B8A82373992F899C@ORSMSX109.amr.corp.intel.com>
 <alpine.DEB.2.10.1405061414460.4548@gentwo.org>
 <53693749.64db420a.500a.ffffe917SMTPIN_ADDED_BROKEN@mx.google.com>
 <alpine.DEB.2.10.1405061503550.5175@gentwo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.10.1405061503550.5175-gkYfJU5Cukgdnm+yROfE0A@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> Right the multicast blocking occurs at the socket level for regular
> networking (see IP_MULTICAST_LOOP socket options). Socket are owned
> by the application.
> 
> 
> A QP is roughly the equivalent thing at the RDMA level. So it seems to me
> that blocking needs to occur at the QP level and not at the multicast
> group level as suggested by Sean.

I was unaware of the IP_MULTICAST_LOOP option.  Given that it makes sense to apply this at the QP level.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
