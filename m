From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 05/10] IB/qib: Use rdmavt lid defines in qib
Date: Tue, 8 Dec 2015 18:19:41 -0500
Message-ID: <20151208231941.GD14221@phlsvsds.ph.intel.com>
References: <20151207204735.11219.68688.stgit@phlsvslse11.ph.intel.com> <20151207204911.11219.50129.stgit@phlsvslse11.ph.intel.com> <20151207205439.GA29576@obsidianresearch.com> <20151208192455.GB16976@phlsvsds.ph.intel.com> <20151208205511.GA14378@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20151208205511.GA14378-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "ira. weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Kamal Heib <kamalh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Dec 08, 2015 at 01:55:11PM -0700, Jason Gunthorpe wrote:
>On Tue, Dec 08, 2015 at 02:24:55PM -0500, ira.weiny wrote:
>> On Mon, Dec 07, 2015 at 01:54:39PM -0700, Jason Gunthorpe wrote:
>> > On Mon, Dec 07, 2015 at 03:49:12PM -0500, Dennis Dalessandro wrote:
>> > >  	/* A multicast address requires a GRH (see ch. 8.4.1). */
>> > > -	if (ah_attr->dlid >= QIB_MULTICAST_LID_BASE &&
>> > > -	    ah_attr->dlid != QIB_PERMISSIVE_LID &&
>> > > +	if (ah_attr->dlid >= be16_to_cpu(IB_MULTICAST_LID_BASE) &&
>> > > +	    ah_attr->dlid != be16_to_cpu(IB_LID_PERMISSIVE) &&
>> > 
>> > Uh cpu_to_be16 please..
>> 
>> But, the defines are big endian and the dlid here is cpu endian.
>
>Hurm, I can't even find the patch that adds IB_MULTICAST_LID_BASE..
>
>But I believe you, and think that is pretty gross to have the constant
>be BE when typical uses like this are CPU..

So what is the consensus here? Should we leave it alone for now and 
potentially go back and deal with this separately?  Just define the new one 
as LE and use it, even though it doesn't match the rest?  Something else 
entirely?

-Denny
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
