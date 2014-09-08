From: Sreedhar Kodali <srkodali-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH v2 3/4] rsockets: distribute completion queue vectors
 among multiple cores
Date: Mon, 08 Sep 2014 19:57:23 +0530
Message-ID: <a8ac21f3c9d7c802ab089bc0d432e40b@imap.linux.ibm.com>
References: <f028f54b9900ee34fcd1abd1d90d10e6@imap.linux.ibm.com>
 <5409DB0D.6080103@acm.org>
 <850a2835b5917f6da62af3d1ea0288fd@imap.linux.ibm.com>
 <540D50E9.5050709@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <540D50E9.5050709-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, pradeeps-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Bart,

Thanks for your insights.  Your suggestion of having a separate
vector per process is really useful when multiple processes are
simultaneously running in the same environment.  At the implementation
level this requires an extended configuration file format. Can't
we possibly think of this as a next iteration?

Thank You.

- Sreedhar

On 2014-09-08 12:17, Bart Van Assche wrote:
> On 09/06/14 05:06, Sreedhar Kodali wrote:
>> The provided patch only covers equal distribution of completion 
>> vectors
>> among the specified cores.  But, it is not generic enough to cover
>> the scenario you have suggested.  If it were to be the case, then
>> we need to
>> 
>> a) alter the configuration file format to recognize cpu sockets
>> b) or introduce separate configuration files for each cpu socket
>> c) alter the distribution logic to recognize socket based grouping
>> 
>> This definitely increases the complexity of the code.  Not sure
>> whether this is necessary to cover most of the general use cases.
>> If so, then we can target it.
> 
> Hello Sreedhar,
> 
> Sorry if I wasn't clear enough. What I meant is that I think that it
> would be useful to be able to configure a different completion vector
> mask per process instead of one global completion vector mask for all
> processes that use the rsockets library. Being able to configure one
> completion vector mask per process would make it possible to avoid
> that one busy process negatively impacts the performance of another
> process that uses RDMA.
> 
> Bart.
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" 
> in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
