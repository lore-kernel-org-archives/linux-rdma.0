From: Sridhar Samudrala <sri-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: Re: rsockets and fork
Date: Tue, 14 Aug 2012 10:51:53 -0700
Message-ID: <502A9039.4090505@us.ibm.com>
References: <1344899557.2101.29.camel@oc1677441337.ibm.com> <1828884A29C6694DAF28B7E6B8A8237346A7DB36@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A8237346A7DB36-P5GAC/sN6hmkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 8/13/2012 4:39 PM, Hefty, Sean wrote:
>> I could not get fork enabled netperf to work with rsockets in the latest
>> librdmacm git repository.
>> After some debugging, i found that the child netserver process is blocked at
>> sem_wait() call in fork_passive().
>> It is not clear to me how this call is supposed to unblock as sem_post()
>> is done later in the same function.
> sem_open() should create the semaphore with an initial value of 1.  The sem_wait/sem_post calls serialize listening on the corresponding rsocket.  The name semaphore should remain until the system is rebooted.
Looks like a stale semaphore issue. I removed /dev/shm/sem.rsocket_fork 
and restarted netserver and it is working now.
>   
>> However, if i start another netperf instance while the other session is
>> still going on, it seems to hang and return with a very low throughput.
>> It looks as if the first session is starving all the other sessions.
>> The right behavior would be to have the available bw split across the
>> parallel instances.
> Can you verify that the second session is using rsockets and not falling back to a socket connection?
Yes. it is also using rsockets.
The second session always hangs after sending a fixed number of bytes 
(38469632).
rsend() blocks waiting for the CQ event.

Thanks
Sridhar
>
> You can try adjusting the polling time.  This can usually be done by writing a value (time in microseconds) to the following file:
>
> /etc/rdma/rsocket/polling_time
>
> By default, the value is 10.
>
> - Sean
>

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
