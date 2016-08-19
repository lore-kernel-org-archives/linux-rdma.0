From: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH perftest] perftest: make inline send on ocrdma work better
Date: Fri, 19 Aug 2016 17:12:42 -0400
Message-ID: <20160819211242.GY1916@redhat.com>
References: <1471633611-41155-1-git-send-email-jarod@redhat.com>
 <85f0801f-a78f-7091-7ae2-5febde6b19b6@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <85f0801f-a78f-7091-7ae2-5febde6b19b6-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Gil Rockah <gilr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Aug 19, 2016 at 03:45:57PM -0500, Steve Wise wrote:
> On 8/19/2016 2:06 PM, Jarod Wilson wrote:
> >The ocrdma driver supports a maximum inline send size of 224, while the
> >current code sets this size to 236. Add an ocrdma-specific check when
> >setting max inline size to eliminate the need to always pass -I 224 when
> >running ib_send_lat on ocrdma hardware.
> 
> <soap box>
> We really should fix the RDMA uAPI to allow querying the device to
> get the max inline size for various SQ WRs (it might vary for send
> vs write, for example), instead of requiring applications to guess
> or hardcoding benchmarks based on device name...
> </soap box>

This was a nice quick hack Friday afternoon hack to get it working
with existing kernels in our testing infra, but having a way to ask
the hardware would definitely be vastly superior.

-- 
Jarod Wilson
jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
