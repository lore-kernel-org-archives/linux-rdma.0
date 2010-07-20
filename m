From: Liran Liss <liranl-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Subject: RE: When IBoE will be merged to upstream?
Date: Tue, 20 Jul 2010 23:50:36 +0300
Message-ID: <E113D394D7C5DB4F8FF691FA7EE9DB443B38E3C5DC@MTLMAIL.mtl.com>
References: <E113D394D7C5DB4F8FF691FA7EE9DB4439BA54B70E@MTLMAIL.mtl.com>
	<adak4pcnw3c.fsf@roland-alpha.cisco.com>
	<E113D394D7C5DB4F8FF691FA7EE9DB443A8E048000@MTLMAIL.mtl.com>
	<4C32D0BD.3030902@Voltaire.com>
	<E113D394D7C5DB4F8FF691FA7EE9DB443A8E2E552A@MTLMAIL.mtl.com>
	<4C3417FA.7000600@Voltaire.com>
	<E113D394D7C5DB4F8FF691FA7EE9DB443AAB6D59C0@MTLMAIL.mtl.com>
	<20100711043449.GA31404@obsidianresearch.com>
	<E113D394D7C5DB4F8FF691FA7EE9DB443AACB08EA5@MTLMAIL.mtl.com>
	<adatyo4xuqx.fsf@roland-alpha.cisco.com>
	<20100713193828.GB12614@obsidianresearch.com>
	<ada8w5fxenn.fsf@roland-alpha.cisco.com>
	<E113D394D7C5DB4F8FF691FA7EE9DB443ABB321050@MTLMAIL.mtl.com>
	<adalj9cveyd.fsf@roland-alpha.cisco.com>
	<7E95F01E94AB484F83061FCFA35B39F87A7D2C@exil.voltaire.com>
	<ada1vb4v7fl.fsf@roland-alpha.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <ada1vb4v7fl.fsf-BjVyx320WGW9gfZ95n9DRSW4+XlvGpQz@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Alex Rosenbaum <Alexr-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, AlekseySenin <aleksey-192fA4vuk7xBDLzU/O5InQ@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Moni Shoua <monis-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Aleksey Senin <alekseys-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Yiftah Shahar <yiftahs-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Tziporet Koren <tziporet-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

>  > Small correction needed regarding the multicast forwarding.
>  > Since we are talking about IPv6 multicast groups, which 
> translate to  > 33:33:xx:xx:xx:xx MAC address, the router 
> listener notification protocol  > is going to be MLD and not 
> IGMP. Still there are switches which support  > MLD 
> forwarding to prevent the network flooding.
> 
> Well as I said the mapping of IBoE MGID to Ethernet address 
> is not specified.  However I agree that using the same 
> mapping as IPv6 so we end up with 33:33:... addresses makes sense.

Agreed.

> 
> Yes, you are right that MLD snooping is the mechanism for 
> switches to discover IPv6 multicast group membership.  
> However for the IBoE case there is no requirement that IPv6 
> multicast group membership corresponds in any way to the IBoE 
> multicast group membership for the interface (and indeed as 
> far as I can tell from the IBoE spec, there is no requirement 
> that any IPv6 interface be configured on an IBoE port).
> 
> Furthermore, even if an IBoE interface sends MLD messages for a given
> IPv6 group, there is no requirement that a switch use the 
> membership information for that group to forward multicast 
> packets with a non-IPv6 ethertype.

Right. Initially there can be flooding within the VLAN. In the future we can
evolve to use a group-membership protocol when customers that care about
the efficiency drive their switch vendors to support it.

Are there any other issues that you would like us to address before updating the patches?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
