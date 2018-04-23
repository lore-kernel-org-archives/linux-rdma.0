From: "Wan, Kaike" <kaike.wan@intel.com>
Subject: RE: hrtimer (rdmavt RNR timer) was lost
Date: Mon, 23 Apr 2018 13:22:11 +0000
Message-ID: <3F128C9216C9B84BB6ED23EF16290AFB634C9420@CRSMSX101.amr.corp.intel.com>
References: <3F128C9216C9B84BB6ED23EF16290AFB634C8C87@CRSMSX101.amr.corp.intel.com>
 <alpine.DEB.2.21.1804231355570.2077@nanos.tec.linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.21.1804231355570.2077@nanos.tec.linutronix.de>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Thomas Gleixner <tglx@linutronix.de>
Cc: "Marciniszyn, Mike" <mike.marciniszyn@intel.com>, "Dalessandro, Dennis" <dennis.dalessandro@intel.com>, "Weiny, Ira" <ira.weiny@intel.com>, "Fleck, John" <john.fleck@intel.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org



> -----Original Message-----
> From: Thomas Gleixner [mailto:tglx@linutronix.de]
> Sent: Monday, April 23, 2018 8:53 AM
> To: Wan, Kaike <kaike.wan@intel.com>
> Cc: Marciniszyn, Mike <mike.marciniszyn@intel.com>; Dalessandro, Dennis
> <dennis.dalessandro@intel.com>; Weiny, Ira <ira.weiny@intel.com>; Fleck,
> John <john.fleck@intel.com>; linux-kernel@vger.kernel.org; linux-
> rdma@vger.kernel.org
> Subject: Re: hrtimer (rdmavt RNR timer) was lost
> 
> On Fri, 20 Apr 2018, Wan, Kaike wrote:
> 
> Please do not send html mail. It's rejected by the list server.
> 
> >           <idle>-0     [001] d.h. 3598473310671: hrtimer_start:
> hrtimer=00000000708914d7 function=rvt_rc_rnr_retry [rdmavt]
> expires=712172295802 softexpires=712172295802mode=REL
> base=0000000066dda1ea next=0000000039cae92b
> >           <idle>-0     [001] d.h. 3598473311561: hrtimer_post_add:
> hrtimer=00000000708914d7 function=rvt_rc_rnr_retry [rdmavt]
> base=0000000066dda1ea next=0000000039cae92b
> >
> 
> > --> The target was first added. The expires was 712172295802. The call
> >     was made from cpu 1 while the timer base was on cpu 3.
> 
> >           <idle>-0     [003] dn.. 3598605305357: hrtimer_start:
> hrtimer=0000000004346740 function=tick_sched_timer
> expires=716767000000 softexpires=716767000000mode=ABS|PINNED
> base=0000000066dda1ea next=00000000708914d7
> >           <idle>-0     [003] dn.. 3598605305781: hrtimer_post_add:
> hrtimer=0000000004346740 function=tick_sched_timer
> base=0000000066dda1ea next=00000000708914d7
> >
> > --> the target timer was the next one to trigger. The call was from cpu 3.
> >
> >           <idle>-0     [003] dN.. 3598605306604: hrtimer_pre_remove:
> hrtimer=0000000004346740 function=tick_sched_timer
> base=0000000066dda1ea next=00000000708914d7
> >           <idle>-0     [003] dN.. 3598605306802: hrtimer_post_remove:
> hrtimer=0000000004346740 function=tick_sched_timer
> base=0000000066dda1ea next=00000000708914d7
> >
> > --> The tick_sched_timer was removed
> >
> >           <idle>-0     [003] dN.. 3598605307236: hrtimer_start:
> hrtimer=0000000004346740 function=tick_sched_timer
> expires=712171000000 softexpires=712171000000mode=ABS|PINNED
> base=0000000066dda1ea next=00000000708914d7
> >           <idle>-0     [003] dN.. 3598605307601: hrtimer_post_add:
> hrtimer=0000000004346740 function=tick_sched_timer
> base=0000000066dda1ea next=0000000004346740
> >
> > --> The tick_sched_timer was added again with a new expires
> > --> (712171000000
> >     < 716767000000), which replaced the target (712172295802) as the
> >     head->next.
> >
> >           <idle>-0     [002] d.h. 3598605313255: hrtimer_start:
> hrtimer=00000000662d2dd8 function=rvt_rc_rnr_retry [rdmavt]
> expires=712172915662 softexpires=712172915662mode=REL
> base=0000000066dda1ea next=0000000004346740
> >           <idle>-0     [002] d.h. 3599538740786: hrtimer_post_add:
> hrtimer=00000000662d2dd8 function=rvt_rc_rnr_retry [rdmavt]
> base=0000000066dda1ea next=00000000662d2dd8
> >
> >
> > --> A new hrtimer (00000000662d2dd8) was added (from cpu 2). Its
> > --> expires
> >     (712172915662) was larger than the target's (712172295802). How could
> >     it become the next hrtimer to trigger??? The next pointer was not set
> >     properly here.
> 
> I have no idea how that can happen assumed that you did not strip anything
> from the trace. If you stripped stuff, please send me the full trace or upload
> it somewhere.
> 
> Can you apply the following debug patch and enable the hrtimer_start trace
> point and send me the full trace or upload it somewhere?

The original trace was about 29GB and I filtered it with  "0000000066dda1ea" (the offending base) to generate a 1.4GB  file that I could open and investigate.  I am not sure how I can send them to you. Do you have somewhere I can upload to?

I can try your debug patch and again I am anticipating a big trace file.

Kaike

> 
> Thanks,
> 
> 	tglx
> 
> 8<-------------------------
> --- a/lib/timerqueue.c
> +++ b/lib/timerqueue.c
> @@ -57,6 +57,10 @@ bool timerqueue_add(struct timerqueue_he
>  	rb_link_node(&node->node, parent, p);
>  	rb_insert_color(&node->node, &head->head);
> 
> +	trace_printk("head %p next %p next->exp %llu node %p node-
> >exp %llu\n",
> +		     head, head->next, head->next ? head->next->expires :
> 0ULL,
> +		     node, node->expires);
> +
>  	if (!head->next || node->expires < head->next->expires) {
>  		head->next = node;
>  		return true;
> @@ -84,6 +88,11 @@ bool timerqueue_del(struct timerqueue_he
> 
>  		head->next = rb_entry_safe(rbn, struct timerqueue_node,
> node);
>  	}
> +
> +	trace_printk("head %p next %p next->exp %llu node %p node-
> >exp %llu\n",
> +		     head, head->next, head->next ? head->next->expires :
> 0ULL,
> +		     node, node->expires);
> +
>  	rb_erase(&node->node, &head->head);
>  	RB_CLEAR_NODE(&node->node);
>  	return head->next != NULL;
