From: Jeff Squyres <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: bug 1918 - openmpi broken due to rdma-cm changes
Date: Fri, 5 Feb 2010 17:20:03 -0500
Message-ID: <0AE28947-00E9-4E02-9570-97DAFA57F8D7@cisco.com>
References: <ada4olvefl4.fsf@roland-alpha.cisco.com> <324EFA68-12F6-46E9-B876-7F4847B53224@cisco.com> <4B6C6453.9090706@opengridcomputing.com> <20100205185616.GS16490@obsidianresearch.com> <E8FF8BD1-80AC-4AA7-BC2A-CE7547FB9ABA@cisco.com> <20100205211455.GT16490@obsidianresearch.com> <697C6107-13A9-48E3-B451-02529305100D@cisco.com> <4B6C9369.1070208@opengridcomputing.com>
Mime-Version: 1.0 (Apple Message framework v1077)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4B6C9369.1070208-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "Roland Dreier (rdreier)" <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ewg-G2znmakfqn7U1rindQTSdQ@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Feb 5, 2010, at 4:53 PM, Steve Wise wrote:

> There is still some inconsistency here.   Sean, you claimed binds to
> 127.0.0.1 succeed in ofed-1.4 for IB devices.  If so, then folks running
> IB/openmpi/rdmacm should be seeing issues.  We need to dig a little more...

FWIW, I can run Open MPI v1.4.2beta on my OFED 1.4.1 cluster over IB devices using RDMA CM with no problems.  

I added some debug statements in OMPI showing which rdma_cm_bind's it attempts, just to be sure.  Here's a run across 2 nodes, each with a single 2-port mthca (each port connected to a different IB subnet, not that that matters):

$ mpirun -np 2 --bynode --mca btl_openib_cpc_include rdmacm ring
[svbu-mpi025:05592] FAILED to bind to 127.0.0.1
[svbu-mpi025:05592] FAILED to bind to 172.29.218.165
[svbu-mpi025:05592] SUCCEEDED to bind to 10.10.30.165
[svbu-mpi025:05592] SUCCEEDED to bind to 10.10.20.165
[svbu-mpi026:05529] FAILED to bind to 127.0.0.1
[svbu-mpi026:05529] FAILED to bind to 172.29.218.166
[svbu-mpi026:05529] SUCCEEDED to bind to 10.10.30.166
[svbu-mpi026:05529] SUCCEEDED to bind to 10.10.20.166
...

The 172.x address is my gigE device (eth0).

-- 
Jeff Squyres
jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org

For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
