From: Jeff Squyres <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: bug 1918 - openmpi broken due to rdma-cm changes
Date: Fri, 5 Feb 2010 12:57:55 -0500
Message-ID: <9DF91723-A8F3-49BB-83C9-C61AA45F30FA@cisco.com>
References: <58D723FE08DC6A4398E6596E38F3FA170566DA@XMB-RCD-205.cisco.com>
	<4B6C4460.3050908@opengridcomputing.com>
Mime-Version: 1.0 (Apple Message framework v1077)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
In-Reply-To: <4B6C4460.3050908-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
List-Unsubscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ewg>,
	<mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.openfabrics.org/pipermail/ewg>
List-Post: <mailto:ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Help: <mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=help>
List-Subscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ewg>,
	<mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=subscribe>
Sender: ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
Errors-To: ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, ewg-G2znmakfqn7U1rindQTSdQ@public.gmane.org, "Roland Dreier (rdreier)" <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Feb 5, 2010, at 11:16 AM, Steve Wise wrote:

> > Note that it is highly unlikely that we will release open mpi 1.4.2 in
> > time for ofed 1.5.1.
> 
> Jeff, there is no way to handle high priority bug fixes in the current
> released stream?

We have 1.4.2 cooking, but it's not ready yet.  

I'll take it back to the OMPI community to see if they want to do a high-priority release, but I'm not excited about it (see below).

> > Also note that trying to bind rdma cm to all interface ip addresses
> > was the way that we were advised by openfabrics to figure out which
> > devices are rdma-capable.
> >
> > As such, it is highly desirable to get the fix transparently in rdmacm
> > and preserve the old semantic. More specifically, it seems undesirable
> > to change this semantic in a minor ofed point release.
> 
> I agree that we should probably not allow 127.0.0.1 binds in ofed-1.5.1
> at all because it regresses OpenMPI.  Even with IB systems, if the bind
> to 127.0.0.1 succeeds, then OpenMPI assumes 127.0.0.1 is bound to that
> rdma interface and advertises this address to its peer as an address
> to-which that peer can rdma connect!  This will break IB clusters too,
> not just T3/iWARP cluster.   While I think OpenMPI needs to skip
> 127.0.0.1 in its logic, I think we should probably defer allowing
> 127.0.0.1 binds until ofed-1.6.

I agree that Open MPI should not advertise 127.0.0.1 to peers.  However, the logic that we were advised to use was to try to RDMA CM bind to each IP address.  If the bind succeeds, then it's an RDMA-capable device and therefore it's advertisable.  The rationale was that 127.0.0.1 (really, any loopback address) is *not* an RDMA device and therefore the RDMA CM bind should *never* succeed on it.  Hence, it wasn't necessary to add a "is this a loopback address?" check in the logic.

I guess I don't understand why that rationale is now incorrect -- 127.0.0.1 is still not an RDMA-capable device, right?

> But Jeff, note that if someone uses the upstream kernel and OpenMPI, its
> busted...
> 
> So I recommend:
> 
> 1) Don't allow 127.0.0.1 binds in ofed-1.5.1
> 
> 2) Fix OpenMPI ASAP to never advertise 127.0.0.1 as a valid rdma-cm
> connect address (get it in ofed-1.5.2 or ofed-1.6).

We can add this logic (because I understand that some upstream kernels now allow binding to loopback addresses), but I'm still confused (in principle) as to why it should be necessary.

Can you clarify what kernel versions allow binding LOOPBACK addresses with RDMA CM?

-- 
Jeff Squyres <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cisco.com - http://www.cisco.com

For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/
