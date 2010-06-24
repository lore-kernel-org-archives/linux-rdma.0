From: Liran Liss <liranl-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Subject: RE: When IBoE will be merged to upstream?
Date: Thu, 24 Jun 2010 18:42:41 +0300
Message-ID: <E113D394D7C5DB4F8FF691FA7EE9DB4439A78AFE88@MTLMAIL.mtl.com>
References: <AANLkTikXzoaRl61ivsc7fm8EdO9Ucz4iGGfclFOQl3kK@mail.gmail.com>
	<adabpb1s58c.fsf@roland-alpha.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <adabpb1s58c.fsf-BjVyx320WGW9gfZ95n9DRSW4+XlvGpQz@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Aleksey Senin <aleksey-192fA4vuk7xBDLzU/O5InQ@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "monis-smomgflXvOZWk0Htik3J/w@public.gmane.org" <monis-smomgflXvOZWk0Htik3J/w@public.gmane.org>, "alekseys-smomgflXvOZWk0Htik3J/w@public.gmane.org" <alekseys-smomgflXvOZWk0Htik3J/w@public.gmane.org>, "yiftahs-smomgflXvOZWk0Htik3J/w@public.gmane.org" <yiftahs-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Tziporet Koren <tziporet-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, "alexr-smomgflXvOZWk0Htik3J/w@public.gmane.org" <alexr-smomgflXvOZWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Regarding GID to Eth mappings, we discussed using the standard create_ah() Verb for this.
In the kernel, create_ah() will call a generic address resolution function in the cma.
The returned information will be copied back to user-space in a device-specific structure (since address handles are device-specific).

This eliminates adding a new get_eth_l2_addr() ABI call (device-specific or not).
In fact, this approach eliminates adding new ABIs for any kind of address translation...

Does this seem reasonable?
--Liran


-----Original Message-----
From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Roland Dreier
Sent: Thursday, June 24, 2010 2:24 AM
To: Aleksey Senin
Cc: linux-rdma; monis-smomgflXvOZWk0Htik3J/w@public.gmane.org; alekseys-smomgflXvOZWk0Htik3J/w@public.gmane.org; yiftahs-smomgflXvOZWk0Htik3J/w@public.gmane.org; Tziporet Koren; alexr-smomgflXvOZWk0Htik3J/w@public.gmane.org
Subject: Re: When IBoE will be merged to upstream?

 > This is actually a continue of the RAW_ET(XXXX)  issue. We want to  > make a submition  of the patches to the upstream, but there is not  > support for IB transport in Ethernet devices, and the mlx4_en drivers  > version  is a bit outdated 1.4.1.1 in upstream and 1.5.1 in the OFED  > There is also missing VLAN support that already present in the OFED.
 > When do you planning to submit changes from OFED to upstream?

 - I do not search for more things to merge upstream.  I have enough
   work reviewing things that are sent to me.  So I will never look
   through OFED for changes.

 - I do not handle the mlx4_en driver.  Changes for mlx4_en should go to
   netdev and Dave Miller.

 - I will try to get back to the IBoE changes when I have time, and I
   will admit that my time to spend as RDMA maintainer is nowhere near
   full time and less than it was in the past.

 - I did allocate a fair amount of time to spend on IBoE recently but
   unfortunately the patches were not really in a suitable state to
   merge, and I exhausted that time slice before we reached the end.
   When patch sets sit outside of the upstream kernel and are shipped in
   OFED for months and years, it would probably make upstream merging
   easier if that time was used to fix the patch set.

 - Specifically for the IBoE patches, shouldn't someone have realized
   that having a device-specific interface to do the standard mapping of
   GID to Ethernet address makes no sense?
--
Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org> || For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
