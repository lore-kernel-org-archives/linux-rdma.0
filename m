From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: Re: [PATCH 2/3] infiniband-diags: libibnetdisc Allow a DR Path
 partial fabric query starting at a CA
Date: Fri, 22 Jul 2011 15:00:49 -0700
Message-ID: <20110722150049.ba8e592f.weiny2@llnl.gov>
References: <20110720161655.1ed38052.weiny2@llnl.gov>
	<20110720233451.GL18090@obsidianresearch.com>
	<4E297949.2000607@dev.mellanox.co.il>
	<20110722172945.GP18090@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110722172945.GP18090-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, 22 Jul 2011 10:29:46 -0700
Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:

> On Fri, Jul 22, 2011 at 09:21:13AM -0400, Hal Rosenstock wrote:
> > On 7/20/2011 7:34 PM, Jason Gunthorpe wrote:
> > > Also, there is a bug, you can't DLID route to the local HCA and then
> > > use that as a source of a DR path, even though intuitively that should
> > > work.
> > 
> > Just the local xCA or any xCA ?
> 
> Well both, but I was under the impression that latter was specified
> behavior, but I haven't looked it up.

I agree it would be nice if one could issue a combined path and "scan through"
any xCA on the fabric.  However, I don't think it is allowed, nor correct to
do so.

The informative text on pg 805 ln 23 specifically states that the initial LID
routing is from "source node to source switch".

Furthermore, C14-7 (continued on pg 809, first bullet)  specifically indicates
that the DLID for an initial LID routed DR SMP "shall be set to the LID of the
source switch in the DR part."
       ^^^^^^

Even if this is considered vague there would be a problem a xCA was allowed.

C14-9 "case 1" would allow an SM to "scan through" a xCA to another subnet.
Or actually it would result in the SMP being "lost" in the other subnet.

For example take the following:

        "Local subnet"                       "Other subnet"
     xCA1 ----> switch ----> xCA2 p1 : xCA2 p2 ----> switch -> ...
LIDs  2           3            4         1            2

If I issue the SMP from xCA1 with DrSLID = 3 and a DR path of 0,2.  xCA2 will
alter the fields as per C14-9 and issue the SMP out port 2.

Then, when the response comes back to xCA2 p2, it will attempt to
send the packet to LID 2 (DrSLID == 2 from the original query) and the SMP
will end up at the switch on the right in "other subnet", _not_ at xCA1

So although I don't see a specific compliance (and I agree it would be nice) I
think it is safe to say that it should be restricted.

Would it be more clear for C14-9 to specifically exclude this case?

Ira

> 
> Jason


-- 
Ira Weiny
Math Programmer/Computer Scientist
Lawrence Livermore National Lab
925-423-8008
weiny2-i2BcT+NCU+M@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
