From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 1/3] ib core: Make device counter infrastructure dynamic
Date: Wed, 16 Mar 2016 13:45:35 -0400
Message-ID: <20160316174535.GC26530@phlsvsds.ph.intel.com>
References: <20160315155441.222586021@linux.com> <20160315155455.173645653@linux.com> <20160316154738.GA26530@phlsvsds.ph.intel.com> <alpine.DEB.2.20.1603161213560.15010@east.gentwo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.20.1603161213560.15010-wcBtFHqTun5QOdAKl3ChDw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Steve Wise <swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, alonvi-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Mar 16, 2016 at 12:17:23PM -0500, Christoph Lameter wrote:
>On Wed, 16 Mar 2016, Dennis Dalessandro wrote:
>
>> > +	return sprintf(buf, "%llu\n", stats.value[index]);
>> > +}
>>
>> This works fine when there are few counters, but if there are lots? What about
>> changing things to include the index in the get_protocol_stats() call so that
>> we just grab the single item we are looking for?
>
>Right now there is a limiting in the source to a max of 128 counters. In
>practice all users use less than 30 counters at this point. So we have
>some space to go until we may need a better solution. We could also save
>the stats we have retrieved so it can be used for multiple counters.
>
>But I think this something for the future.

Fair enough. The only thing I would add is it would be easier now since you 
already change the only 2 drivers which use it, and are adding it to the Mlx 
drivers for the first time. 

Just throwing the idea out. I'm not totally against the current patch.

-Denny
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
