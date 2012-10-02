From: Bang Nguyen <bang.nguyen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: APM support for IPoIB
Date: Mon, 01 Oct 2012 17:02:09 -0700
Message-ID: <506A2F01.8000605@oracle.com>
References: <506A17EA.8080400@oracle.com> <20121001235303.GH22342@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20121001235303.GH22342-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Richard Frank <richard.frank-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

  On 10/1/2012 4:53 PM, Jason Gunthorpe wrote:
> On Mon, Oct 01, 2012 at 03:23:38PM -0700, Bang Nguyen wrote:
>
>> Adding APM support for IPoIB seems like something worthwhile and
>> we're thinking about it..but are wondering why has hasn't been done
>> already..any comments/suggestions?
> I've been quite supportive of APM in the past, IMHO I think it is
> something unique to IB that should be exploited as often as possible.
>
> Improving the RDMA-CM to setup APM at all would be a great first step,
> but some SM work is also ultimately needed to get sufficiently
> independent/redundant paths.
Our version of OFED has full support of APM in RDMA-CM and it's being 
used by SDP and RDS..
IPoIB is using CM instead of RDMA CM so we can not leverage it..IPoIB 
APM will need to have its own implementation..
> I would like to see the full APM support eventually implemented - this
> would be fail over across adaptor ports, where each port is on a
> seperate subnet - so you get full redundancy of cabling, switching and
> management software.
>
> Jason

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
