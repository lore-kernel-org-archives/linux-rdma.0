From: "Paul Grun" <pgrun-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>
Subject: RE: APM support for IPoIB
Date: Tue, 2 Oct 2012 09:53:17 -0700
Message-ID: <009101cda0be$6d8cb220$48a61660$@com>
References: <506A17EA.8080400@oracle.com> <20121001235303.GH22342@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20121001235303.GH22342-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Jason Gunthorpe' <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, 'Bang Nguyen' <bang.nguyen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, 'Richard Frank' <richard.frank-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Jason - Like your idea for full APM support especially across subnets, but
wouldn't that require some sort capability that lives above the subnet level
and is able to query both SMs/SAs?  Sounds vaguely router-ish?
-Paul

> -----Original Message-----
> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-
> owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Jason Gunthorpe
> Sent: Monday, October 01, 2012 4:53 PM
> To: Bang Nguyen
> Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Richard Frank
> Subject: Re: APM support for IPoIB
> 
> On Mon, Oct 01, 2012 at 03:23:38PM -0700, Bang Nguyen wrote:
> 
> > Adding APM support for IPoIB seems like something worthwhile and we're
> > thinking about it..but are wondering why has hasn't been done
> > already..any comments/suggestions?
> 
> I've been quite supportive of APM in the past, IMHO I think it is
> something unique to IB that should be exploited as often as possible.
> 
> Improving the RDMA-CM to setup APM at all would be a great first step, but
> some SM work is also ultimately needed to get sufficiently
> independent/redundant paths.
> 
> I would like to see the full APM support eventually implemented - this
> would be fail over across adaptor ports, where each port is on a seperate
> subnet - so you get full redundancy of cabling, switching and management
> software.
> 
> Jason
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org More majordomo info at
> http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
