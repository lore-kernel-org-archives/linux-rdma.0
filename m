From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2 19/20] IB/rdmavt, IB/qib, IB/hfi1: Make percpu refcount
 optional for user MRs
Date: Wed, 5 Apr 2017 15:46:48 -0400
Message-ID: <f008c532-340e-01f2-80e6-4bea74175e3e@intel.com>
References: <20170321001900.28538.38175.stgit@scvm10.sc.intel.com>
 <20170321002631.28538.2121.stgit@scvm10.sc.intel.com>
 <1491417489.2923.6.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1491417489.2923.6.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 04/05/2017 02:38 PM, Doug Ledford wrote:
> On Mon, 2017-03-20 at 17:26 -0700, Dennis Dalessandro wrote:
>> +static unsigned int hfi1_no_user_mr_percpu;
>> +module_param_named(no_user_mr_percpu, hfi1_no_user_mr_percpu, uint,
>> +                  S_IRUGO);
>> +MODULE_PARM_DESC(no_user_mr_percpu,
>> +                "Avoid percpu refcount for user MRs (default 0)");
>> +
>
> Does this have to be a module parameter?  Those are frowned upon now a
> days...
>

Yeah I don't like it either really, but there is a pretty big tradeoff 
between memory deregistration improvement and cost to the data path. 
Most use cases care about the data path but some uses register and 
deregister memory a lot and this helps them.

Is there a another way we should be looking at for setting things like this?

-Denny
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
