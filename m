From: Jeff Squyres <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [ewg] rdma/cm: disallow loopback address for iwarp devices
Date: Mon, 8 Feb 2010 17:17:04 -0500
Message-ID: <44864D85-03D1-412E-906C-D6FF904157C8@cisco.com>
References: <58D723FE08DC6A4398E6596E38F3FA170566DA@XMB-RCD-205.cisco.com> <0D5487526204477AA2ABED06E46768E2@amr.corp.intel.com> <4B6C498F.3060708@opengridcomputing.com> <38B735478FE94F40BBA3E8BFD794B10F@amr.corp.intel.com> <4B6D9948.6040007@opengridcomputing.com> <B41CA82E76BB439B892B4874D38EA652@amr.corp.intel.com> <79BAA34231304F1E84C5A5A53C50A207@amr.corp.intel.com> <4B6FFB1B.40905@mellanox.co.il> <4B701FE6.60302@opengridcomputing.com> <adawrynwtz9.fsf@roland-alpha.cisco.com> <20100208191927.GU16490@obsidianresearch.com> <4B706DED.9080403@opengridcomputing.com> <C8A2C57AD5FA4141860DBFF60BFDE2DC@amr.corp.intel.com> <4B707F2D.3030508@opengridcomputing.com> <41CC15C4-0200-4C9E-9E10-3D2A9B76D16B@cisco.com> <7CC17592BE414EFCA00A1CB6033D047A@amr.corp.intel.com>
Mime-Version: 1.0 (Apple Message framework v1077)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <7CC17592BE414EFCA00A1CB6033D047A-Zpru7NauK7drdx17CPfAsdBPR1lH4CV8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "Roland Dreier (rdreier)" <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Tziporet Koren <tziporet-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Linux RDMA List <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, ewg-G2znmakfqn7U1rindQTSdQ@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Feb 8, 2010, at 5:13 PM, Sean Hefty wrote:

> Are you certain that rdma_bind_addr does NOT work with 127.0.0.1, and that this
> is now the problem?
> 
> It does appear to work on OFED 1.4 and on 2.6.26 based on ucmatose.  Is the
> problem really with rdma_bind_addr succeeding, or with rdma_connect, which now
> works, or rdma_bind_addr now assigning a device?

On my OFED 1.4.1 RHEL4u6 systems, rdma_bind_addr() fails when attempting to bind to 127.0.0.1 per the email I sent Friday:

    http://www.spinics.net/lists/linux-rdma/msg02568.html

I have not checked any other combinations; Steve was saying that he saw it rdma_bind_addr() succeeding on his machines with OFED 1.5.1rcwhatever (I don't recall the OS he said he was using).

-- 
Jeff Squyres
jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org

For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
