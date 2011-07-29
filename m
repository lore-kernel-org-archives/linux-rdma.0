From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [Patch infiniband-diags:perfquery] Loop through all local HCAs/ports
Date: Fri, 29 Jul 2011 18:14:07 -0400
Message-ID: <4E3330AF.9050208@redhat.com>
References: <4E332CE5.3010706@redhat.com> <20110729220912.GL18090@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110729220912.GL18090-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 07/29/2011 06:09 PM, Jason Gunthorpe wrote:
> On Fri, Jul 29, 2011 at 05:57:57PM -0400, Doug Ledford wrote:
>> The -a mode of perfquery is intended to loop through all ports on a
>> single HCA and provide aggregated output across all ports.
>>
>> The -l mode is intended to loop through all ports of a single HCA
>> and output non-aggregated data.
>
> Actually, none of these modes are intended to support HCA scenarios,
> they are all only for switches.

Well, they attempt to work on local HCAs if you don't specify a switch 
lid to query.  So, intended or not, they are already being attempted to 
be used in this fashion out in the field.

> Not sure what I think of this, is dumping counters on all local HCA
> ports really that interesting? Would this be better done by doing
> something fancy with nodeGUID so at least all ports on remote HCAs can
> be dumped too?

The request came in from one of our partners who wanted it for tracking 
performance stats specifically on the local machine.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
