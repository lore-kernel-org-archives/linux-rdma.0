From: Jeff Squyres <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [ewg] rdma/cm: disallow loopback address for iwarp devices
Date: Mon, 8 Feb 2010 16:56:23 -0500
Message-ID: <41CC15C4-0200-4C9E-9E10-3D2A9B76D16B@cisco.com>
References: <58D723FE08DC6A4398E6596E38F3FA170566DA@XMB-RCD-205.cisco.com> <0D5487526204477AA2ABED06E46768E2@amr.corp.intel.com> <4B6C498F.3060708@opengridcomputing.com> <38B735478FE94F40BBA3E8BFD794B10F@amr.corp.intel.com> <4B6D9948.6040007@opengridcomputing.com> <B41CA82E76BB439B892B4874D38EA652@amr.corp.intel.com> <79BAA34231304F1E84C5A5A53C50A207@amr.corp.intel.com> <4B6FFB1B.40905@mellanox.co.il> <4B701FE6.60302@opengridcomputing.com> <adawrynwtz9.fsf@roland-alpha.cisco.com> <20100208191927.GU16490@obsidianresearch.com> <4B706DED.9080403@opengridcomputing.com> <C8A2C57AD5FA4141860DBFF60BFDE2DC@amr.corp.intel.com> <4B707F2D.3030508@opengridcomputing.com>
Mime-Version: 1.0 (Apple Message framework v1077)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4B707F2D.3030508-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "Roland Dreier (rdreier)" <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Tziporet Koren <tziporet-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Linux RDMA List <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, ewg-G2znmakfqn7U1rindQTSdQ@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Sorry -- I missed many of these mails today due to mail filtering (don't ask).

FWIW:

- I'm not opposed to adding LOOPBACK checks into OMPI to avoid this problem (I'm waiting for a patch, actually).  I'm just saying that we're not going to get a release out immediately with this fix.  Our next release was scheduled to be 1.4.2, and it is still at least several weeks away.  So allowing this in 2.6.33 would be Bad because a) we know it breaks OMPI, and b) OMPI can't get a release out immediately to fix the issue.

- There are customers who are using RDMA CM with IB (e.g., Sandia with their Mesh/IB routing stuff).

- I see the following in rdma_bind_addr(3):

-----
DESCRIPTION
       Associates a source address with an rdma_cm_id.  The  address  may  be
       wildcarded.   If  binding  to a specific local address, the rdma_cm_id
       will also be bound to a local RDMA device.
-----

What RDMA device is bound to when you use 127.0.0.1?  I'm not 100% sure, but I think that this might be where we got the rationale that we didn't need additional LOOPBACK tests in OMPI...  (if anyone else agrees with this interpretation, then it's at least one argument that allowing binding to LOOPBACK devices *is* a change in semantics, and therefore should be treated extremely carefully)


On Feb 8, 2010, at 4:16 PM, Steve Wise wrote:

> 
> Sean Hefty wrote:
> >> IMO 127.0.0.1 should be for SW loopback, not HW RDMA loopback.
> >>    
> >
> > I disagree, but what does it matter?  So, we add a 'software' loopback that uses
> > 127.0.0.1.  Openmpi still wouldn't work.
> >
> >  
> 
> I guess that's true.
> 
> >> I will commit to get the fix in openmpi asap.
> >>    
> >
> > If we don't care if the fix is in the kernel or user space, then we could add an
> > a 'disable-loopback-support' build option to librdmacm, which can fail any
> > attempt to bind to a loopback address.
> >
> >  
> 
> I'd rather see it removed from 2.6.33 kernel before it shipts, and then
> we fix openmpi, and then re-submit 127.0.0.1 support once openmpi
> publishes a release with its fix.  See my other email that submits a
> potential commit to remove 127.0.0.1 support for 2.6.33.
> 
> Steve.
> 


-- 
Jeff Squyres
jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org

For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
