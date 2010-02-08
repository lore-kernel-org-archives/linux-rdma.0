From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: [ewg] [PATCH] [for-2.6.33] rdma/cm: disallow loopback address
 for iwarp devices
Date: Mon, 08 Feb 2010 14:02:53 -0600
Message-ID: <4B706DED.9080403@opengridcomputing.com>
References: <58D723FE08DC6A4398E6596E38F3FA170566DA@XMB-RCD-205.cisco.com> <0D5487526204477AA2ABED06E46768E2@amr.corp.intel.com> <4B6C498F.3060708@opengridcomputing.com> <38B735478FE94F40BBA3E8BFD794B10F@amr.corp.intel.com> <4B6D9948.6040007@opengridcomputing.com> <B41CA82E76BB439B892B4874D38EA652@amr.corp.intel.com> <79BAA34231304F1E84C5A5A53C50A207@amr.corp.intel.com> <4B6FFB1B.40905@mellanox.co.il> <4B701FE6.60302@opengridcomputing.com> <adawrynwtz9.fsf@roland-alpha.cisco.com> <20100208191927.GU16490@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100208191927.GU16490-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, tziporet-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ewg-G2znmakfqn7U1rindQTSdQ@public.gmane.org, Jeff Squyres <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Jason Gunthorpe wrote:
> On Mon, Feb 08, 2010 at 08:52:10AM -0800, Roland Dreier wrote:
>   
>>  > This patch doesn't solve the openmpi/IB regression.   So for OFED,
>>  > IMO, we need a different patch...
>>
>> If this doesn't solve the regression the we should have a different
>> patch for upstream too.  The goal for 2.6.33 should be to keep open mpi
>> working, even if that requires us to go back to old breakage.
>>     
>
> Steve, I thought you said earlier in the thread that the rdmacm OMPI
> method is not used that often with IB - and the other IB connect
> methods work fine.
>
>   

Maybe Jeff can chime in here, but he mentioned to me that Sandia Labs 
were using IB/rdmacm.

> This really is a bug in OMPI, how long do you think this new feature
> should remain outside the upstream kernel? Is someone going to commit
> to fixing OMPI soon if the patch is removed?
>
>   
IMO 127.0.0.1 should be for SW loopback, not HW RDMA loopback. 

But I believe Jeff asked at least that we pull it from 2.6.33 and let 
OMPI get its next release out with the OMPI fix.  Then you can push it 
into 2.6.34 if we really want this feature.

I will commit to get the fix in openmpi asap.

Steve.


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
