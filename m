From: David Brean <David.Brean-UdXhSnd/wVw@public.gmane.org>
Subject: Re: strong ordering for data registered memory
Date: Thu, 12 Nov 2009 15:43:02 -0500
Message-ID: <4AFC7356.8060602@Sun.COM>
References: <4AF9CACE.8070700@Sun.COM> <adaskclvta4.fsf@roland-alpha.cisco.com>
 <4AFAFF7A.4090602@oracle.com> <4AFB3677.6050603@Sun.COM>
 <4AFB3E6B.3080606@oracle.com> <20091111231338.GZ1966@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII; format=flowed
Content-Transfer-Encoding: 7BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-reply-to: <20091111231338.GZ1966-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Richard Frank <richard.frank-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

See section 4 in the paper called "High Performance RDMA Based MPI Implementation over InfiniBand" on the MVAPICH web page for description of one implementation that polls on data buffers.  Specifically, look at text around the statement "Although the approach uses the in-order implementation of hardware for RDMA write which is not specified in the InfiniBand standard, this feature is very likely to be kept by different hardware designers."  Although this paper is describing a PCI-X implementation, the feature is also exists on PCIe.

It's assumed that the host memory interconnect complies with statements described in the "Update Ordering and Granularity Provided by a Write Transaction" of the PCI spec.  This particular application depends on PCI WRITE behavior, not READ.

Does this help?

Jason Gunthorpe wrote:
> On Wed, Nov 11, 2009 at 05:44:59PM -0500, Richard Frank wrote:
> 
>> Would anyone like to through out the list of HCAs that do this... I
>> can guess at a few...  and can ask the vendors directly.. if not.. .
>>
>> It would be much nicer to not hardcode names of adapters.. but that won't
>> stop us.. :)
> 
> Isn't it more complex than this? AFAIK the PCI-E standard does not
> specify the order which data inside a single transfer becomes visible,
> only how different transfers relate. To work on the most agressive
> PCI-E system the HCA would have to transfer the last XX bytes as a
> seperate PCI-E transaction without relaxed ordering.
> 
> This is the sort of thing that might start to matter on QPI and HT
> memory-interleaved configurations. A multi-cache line transfer will be
> split up and completed on different chips - it may not be fully
> coherent 100% of the time.
> 
> Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
