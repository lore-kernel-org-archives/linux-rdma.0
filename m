From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH v2 3/4] rsockets: distribute completion queue vectors
 among multiple cores
Date: Fri, 05 Sep 2014 17:47:25 +0200
Message-ID: <5409DB0D.6080103@acm.org>
References: <f028f54b9900ee34fcd1abd1d90d10e6@imap.linux.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <f028f54b9900ee34fcd1abd1d90d10e6-FJGp5E75HVmZamtmwQBW5tBPR1lH4CV8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sreedhar Kodali <srkodali-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, pradeeps-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 09/05/14 15:18, Sreedhar Kodali wrote:
> From: Sreedhar Kodali <srkodali-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
>      Distribute interrupt vectors among multiple cores while processing
>      completion events.  By default the existing mechanism always
>      defaults to core 0 for comp vector processing during the creation
>      of a completion queue.  If the workload is very high, then this
>      results in bottleneck at core 0 because the same core is used for
>      both event and task processing.
>
>      A '/comp_vector' option is exposed, the value of which is a range
>      or comma separated list of cores for distributing interrupt
>      vectors.  If not set, the existing mechanism prevails where in
>      comp vector processing is directed to core 0.

Shouldn't "core" be changed into "completion vector" in this patch 
description ? It is not possible to select a CPU core directly via the 
completion vector argument of ib_create_cq(). Which completion vector 
maps to which CPU core depends on how /proc/irq/<irq>/smp_affinity has 
been configured.

> +    if ((f = fopen(RS_CONF_DIR "/comp_vector", "r"))) {

Is it optimal to have a single global configuration file for the 
completion vector mask for all applications ? Suppose that a server is 
equipped with two CPU sockets, one PCIe bus and one HCA with one port 
and that that HCA has allocated eight completion vectors. If IRQ 
affinity is configured such that the first four completion vectors are 
associated with the first CPU socket and the second four completion 
vectors with the second CPU socket then to achieve optimal performance 
applications that run on the first socket should only use completion 
vectors 0..3 and applications that run on the second socket should only 
use completion vectors 4..7. Should this kind of configuration be 
supported by the rsockets library ?

Bart.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
