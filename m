From: Vivek Kashyap <kashyapv-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: Re: rsockets and other performance
Date: Thu, 14 Jun 2012 23:48:09 -0700 (PDT)
Message-ID: <alpine.LRH.2.00.1206142336220.13728@oc4747053027.ibm.com>
References: <4FDA0233.6090409@linux.vnet.ibm.com> <20120614172245.GC6552@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120614172245.GC6552-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Pradeep Satyanarayana <pradeeps-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, sri-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



On Thu, 14 Jun 2012, Jason Gunthorpe wrote:

> On Thu, Jun 14, 2012 at 08:24:35AM -0700, Pradeep Satyanarayana wrote:
>
>> With these minimal changes IPoIB throughput reached between
>> 19-20Gb/s with just 2 threads. This was really unexpected. Given
>> that, we wanted to revisit the usage of checksums in IPoIB.
>> So, it looks worthwhile to allow for 'checksum-less' IPoIB-CM within
>> a cluster on a single subnet. From a checksum perspective, this
>> would be no different from RDMA. What are your thoughts?
>
> There have been discussions around a 'checksum-less' IPoIB operation
> for a little while.
>
> The basic notion was to enable the checksum offload mechanism, pass
> the information from Linux for offload straight through to the other
> side (eg via an extra header or something), have the other side
> reconstruct the offload indication on RX and inject back to into the
> net stack.
>
> This would be similar to the way checksum bypass works in
> virtualization (Xen/KVM) where the virtualized net TX just packages
> the offload data and sends it to the hyperviser kernel which then RX's
> it and restores the very same checksum offload information.
>
> During the CM process this feature would be negotiated.
>
> I don't think anyone ever made patches for this, but considering the
> performance delta you see it really seems worthwhile.

How about something like below? Basically the the 'checksum-less' operation 
is only between hosts that both support it by extending  the existing IB
connection setup mechanism. The following also keeps the
changes confined to ipoib-cm module.


- add a  sysctl variable csum_simulate
- In ipoinb-cm module
 	if (csum_simulate)
 		advertize hardware checksum offload capabilities



- when a QP is created to a remote host it checks csum_simulate.
 	if (csum_simulate)
 		include CSUM_SIMULATE command in RC private data when
 		setting up the connection
 		Note: the RFC 4755  utilizes this private data to exchange
 		the receive MTU and UD QP. We just add another parameter to it.

 		If accepted by the other end during connection negotiation,
 		then set csum_simulate_on  = 1 (For the QP)

- when a QP connection request is received
 	if (csum_simulate)
 		look for CSUM_SIMULATE field in the private data
 		if present respond with CSUM_SIMULATE else zero it in response
 		set csum_simulate_on flag = 1  for the QP


In the above two steps one would also want to check that the peer is a 
directly connected host.

- when sending data
 	if (csum_simulate_on)
 		send the data over ipoib-cm link normally (no data checksum
 		added)
 	else /* sending over a QP not enabled for checksum offload */
 		calculate the overall checksum
 		send data

- when receiving data
 	if (csum_simulate_on)
 		set CSUM_UNNECESSARY indicating csum has been validated


thanks
Vivek

>
> Jason
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
