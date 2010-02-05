From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: bug 1918 - openmpi broken due to rdma-cm changes
Date: Fri, 5 Feb 2010 14:15:10 -0800
Message-ID: <77E29960440B4806B112A7158F4FA1C4@amr.corp.intel.com>
References: <ada4olvefl4.fsf@roland-alpha.cisco.com>
	<324EFA68-12F6-46E9-B876-7F4847B53224@cisco.com>
	<4B6C6453.9090706@opengridcomputing.com>
	<20100205185616.GS16490@obsidianresearch.com>
	<E8FF8BD1-80AC-4AA7-BC2A-CE7547FB9ABA@cisco.com>
	<20100205211455.GT16490@obsidianresearch.com>
	<697C6107-13A9-48E3-B451-02529305100D@cisco.com>
	<4B6C9369.1070208@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
In-Reply-To: <4B6C9369.1070208-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
List-Unsubscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ewg>,
	<mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.openfabrics.org/pipermail/ewg>
List-Post: <mailto:ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Help: <mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=help>
List-Subscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ewg>,
	<mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=subscribe>
Sender: ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
Errors-To: ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
To: 'Steve Wise' <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Jeff Squyres <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Roland Dreier (rdreier)" <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, ewg-G2znmakfqn7U1rindQTSdQ@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

>There is still some inconsistency here.   Sean, you claimed binds to
>127.0.0.1 succeed in ofed-1.4 for IB devices.  If so, then folks running
>IB/openmpi/rdmacm should be seeing issues.  We need to dig a little more...

You can verify this by running ucmatose -b 127.0.0.1 and see if the test enters
the listening state.

Can you also try testing iwarp with the patch that I sent? 

- Sean
