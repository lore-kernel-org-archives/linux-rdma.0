From: Jeff Squyres <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [ewg] rdma/cm: disallow loopback address for iwarp devices
Date: Mon, 8 Feb 2010 17:11:12 -0500
Message-ID: <B424F78C-07E8-4DAE-9AA7-5F4D0780130F@cisco.com>
References: <B41CA82E76BB439B892B4874D38EA652@amr.corp.intel.com> <79BAA34231304F1E84C5A5A53C50A207@amr.corp.intel.com> <4B6FFB1B.40905@mellanox.co.il> <4B701FE6.60302@opengridcomputing.com> <adawrynwtz9.fsf@roland-alpha.cisco.com> <20100208191927.GU16490@obsidianresearch.com> <4B706DED.9080403@opengridcomputing.com> <C8A2C57AD5FA4141860DBFF60BFDE2DC@amr.corp.intel.com> <4B707F2D.3030508@opengridcomputing.com> <41CC15C4-0200-4C9E-9E10-3D2A9B76D16B@cisco.com> <20100208220903.GW16490@obsidianresearch.com>
Mime-Version: 1.0 (Apple Message framework v1077)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100208220903.GW16490-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Roland Dreier (rdreier)" <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Tziporet Koren <tziporet-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Linux RDMA List <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, ewg-G2znmakfqn7U1rindQTSdQ@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Feb 8, 2010, at 5:09 PM, Jason Gunthorpe wrote:

>> DESCRIPTION
>>       Associates a source address with an rdma_cm_id.  The  address  may  be
>>       wildcarded.   If  binding  to a specific local address, the rdma_cm_id
>>       will also be bound to a local RDMA device.
> This statement is trying to say that if a source address is given then
> the rdma_cm_id will be bound to a device.

Which device is bound to if you specify 127.0.0.1 as the source address?  (which is what OMPI is doing)  Is it possible to assign 127.0.0.1 to an RDMA device?

-- 
Jeff Squyres
jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org

For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
