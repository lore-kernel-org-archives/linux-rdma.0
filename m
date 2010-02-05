From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: bug 1918 - openmpi broken due to rdma-cm changes
Date: Fri, 05 Feb 2010 13:01:55 -0600
Message-ID: <4B6C6B23.4010704@opengridcomputing.com>
References: <58D723FE08DC6A4398E6596E38F3FA170566DA@XMB-RCD-205.cisco.com>	<4B6C4460.3050908@opengridcomputing.com>
	<ada4olvefl4.fsf@roland-alpha.cisco.com>
	<3762D25FD9474444A4B3E2240EFB8D0E@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
In-Reply-To: <3762D25FD9474444A4B3E2240EFB8D0E-Zpru7NauK7drdx17CPfAsdBPR1lH4CV8@public.gmane.org>
List-Unsubscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ewg>,
	<mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.openfabrics.org/pipermail/ewg>
List-Post: <mailto:ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Help: <mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=help>
List-Subscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ewg>,
	<mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=subscribe>
Sender: ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
Errors-To: ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
To: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, 'Roland Dreier' <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, ewg-G2znmakfqn7U1rindQTSdQ@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Sean Hefty wrote:
>> Is the issue 6f8372b6 ("RDMA/cm: fix loopback address support")?  This
>> just went in for 2.6.33, which is still at -rc6, so if we can quickly
>> reach a consensus, there is still time to get a fix in for 2.6.33.
>>     
>
> That should be the patch in question.  I'm not sure about reaching consensus. :)
> If the other changes to the rdma_cm aren't closely tied to that change, we may
> be able to back that one patch out until we can get whatever other fix may be
> needed.
>   

I'd like to do this approach.  Then re-submit once we come to consensus...

> In my view, openmpi has a bug in that it can pass a loopback address to a remote
> peer and expect it to be used to establish a connection.  Steve seems to agree
> with this.
>
> My original intent was to allow the use of the loopback address with the
> rdma_cm.  I.e. 127.0.0.1 meant 'this host', and not 'software loopback'.  I just
> had Arlin run a quick test with OFED 1.4 over IB, and it allows binding to
> 127.0.0.1, but never forms connections.  I.e. ucmatose -b 127.0.0.1 succeeds in
> listening, but ucmatose -s 127.0.0.1 fails to connect because of a route error.
> (Hmm... I'm still confused about what openmpi is doing then.)
>   

But it must fail in OFED-1.4 if binding to an iwarp interface.   Maybe 
there was IB-only logic allowing 127.0.0.1 binds in OFED-1.4?   

The reason openmpi might still work on IB is that its not typical to use 
the rdma-cm for IB setups.  Its required for iwarp though.

 Jeff, what's the default CPC for IB devices?

> Even if an application were to use non-loopback IP addresses, there's no
> guarantee of forming a connection if those addresses map to an iwarp device.
> So, even if the rdma_cm fails binding to 127.0.0.1 unless there's some RDMA
> device (software or hardware - not sure why we care) capable of supporting it,
> an application would need to also deal with failures from rdma_resolve_addr.
>
> Indicating loopback through a device capability flag seems like the right
> approach, and the rdma_cm can use this to fail rdma_bind_addr/rdma_resolve_addr
> calls.  That's probably not a trivial patch however.
>
> - Sean
>   
