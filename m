From: Liran Liss <liranl-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Subject: RE: When IBoE will be merged to upstream?
Date: Thu, 15 Jul 2010 14:00:49 +0300
Message-ID: <E113D394D7C5DB4F8FF691FA7EE9DB443ABB32101E@MTLMAIL.mtl.com>
References: <20100624203701.GA4630@obsidianresearch.com>
	<E113D394D7C5DB4F8FF691FA7EE9DB4439A78B0042@MTLMAIL.mtl.com>
	<20100625155755.GC4630@obsidianresearch.com>
	<E113D394D7C5DB4F8FF691FA7EE9DB4439BA54B70E@MTLMAIL.mtl.com>
	<adak4pcnw3c.fsf@roland-alpha.cisco.com>
	<E113D394D7C5DB4F8FF691FA7EE9DB443A8E048000@MTLMAIL.mtl.com>
	<4C32D0BD.3030902@Voltaire.com>
	<E113D394D7C5DB4F8FF691FA7EE9DB443A8E2E552A@MTLMAIL.mtl.com>
	<4C3417FA.7000600@Voltaire.com>
	<E113D394D7C5DB4F8FF691FA7EE9DB443AAB6D59C0@MTLMAIL.mtl.com>
	<20100711043449.GA31404@obsidianresearch.com>
	<E113D394D7C5DB4F8FF691FA7EE9DB443AACB08EA5@MTLMAIL.mtl.com>
	<adatyo4xuqx.fsf@roland-alpha.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <adatyo4xuqx.fsf-BjVyx320WGW9gfZ95n9DRSW4+XlvGpQz@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Or Gerlitz <ogerlitz-hKgKHo2Ms0FWk0Htik3J/w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Aleksey Senin <aleksey-192fA4vuk7xBDLzU/O5InQ@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "monis-smomgflXvOZWk0Htik3J/w@public.gmane.org" <monis-smomgflXvOZWk0Htik3J/w@public.gmane.org>, "alekseys-smomgflXvOZWk0Htik3J/w@public.gmane.org" <alekseys-smomgflXvOZWk0Htik3J/w@public.gmane.org>, "yiftahs-smomgflXvOZWk0Htik3J/w@public.gmane.org" <yiftahs-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Tziporet Koren <tziporet-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, "alexr-smomgflXvOZWk0Htik3J/w@public.gmane.org" <alexr-smomgflXvOZWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

>  > But, we can't mandate an overload of the GID in a way that 
> it  > prevents its use as a true L3 address (eventually routable).
> 
> Actually I'm beginning to think that the only possible way we 
> can use the GID in IBoE is as a link-local IPv6 addresses 
> containing an Ethernet address.  Trying to hide neighbour 
> discovery or ARP below the verbs doesn't seem workable -- 
> being forced to change the locking rules we've had for the 
> past 5+ years about create_ah is just the beginning.  We get 
> further problems if a remote address should ever change and 
> I'm probably missing other issues.
> 

We believe the problems are workable. But let us stop arguing for a while and
make progress with link local addressees since we all seem to agree with that.
We can get back to non-local GIDs later

> So the best solution I can see is to declare that an IBoE GID 
> must be an
> IPv6 address coming from an EUI-64 Ethernet address for the 
> corresponding port; for MGIDs I guess we use the standard 
> IPv6 mapping to Ethernet address 33:33:xx:xx:xx:xx.
> 
> I'm not sure how we want to handle IPv4 -- presumably unicast 
> ARP can be done within the RDMA CM, which will then create a 
> DGID with the appropriate Ethernet address.  However it's not 
> clear to me whether we need a way to create IPv4 
> (01:00:5e:xx:xx:xx) multicast addresses.
> 
> Also, since there is no way to map a link-local IPv6 address 
> to a particular interface, then I guess we need a way to pass 
> in the VLAN tag to be used -- presumably we can steal some 
> other field for the 12 bits.
> (The fact that the IBoE annex does not mention VLANs or 
> 802.1q a single time is just another thing that shows how 
> rushed and incomplete it is)
> 
> With all this said, I think it means we do not need to do the 
> mapping from GID to Ethernet address in the kernel for IBoE 
> user verbs, since it is so simple -- we can simply add a 
> fairly trivial helper to libibverbs.
> 
>  - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
