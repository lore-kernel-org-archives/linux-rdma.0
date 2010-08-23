From: "Yossi Etigin" <yosefe-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: RE: IPoIB: Broken IGMP processing
Date: Mon, 23 Aug 2010 22:50:50 +0300
Message-ID: <7E95F01E94AB484F83061FCFA35B39F801324A@exil.voltaire.com>
References: <alpine.DEB.2.00.1008231427130.12815@router.home><7E95F01E94AB484F83061FCFA35B39F8013249@exil.voltaire.com> <20100823194555.GN26549@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-class: urn:content-classes:message
In-Reply-To: <20100823194555.GN26549-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> 
> Simplest then is to check if byte 24 of the packet is 0xff.
> (ie IN6_IS_ADDR_MULTICAST)
> 
> No need to worry about if it is properly formed or anything, if it is
> a multicast DGID then it is a multicast packet at the link level.
> 

Sounds good to me

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
