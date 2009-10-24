From: Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [ofa-general][PATCH 3/4] SRP fail-over faster
Date: Sat, 24 Oct 2009 00:35:48 -0700
Message-ID: <4AE2AE54.5020004@mellanox.com>
References: <4AD3B453.3030109@mellanox.com> <ada1vl5alqh.fsf@cisco.com> <4AD63681.6080901@mellanox.com> <adaljjd8zrj.fsf@cisco.com> <4AD63DB1.3060906@mellanox.com> <adahbu18uf5.fsf@cisco.com> <1255570760.13845.4.camel@obelisk.thedillows.org> <4AD74C88.8030604@mellanox.com> <1255634715.29829.9.camel@lap75545.ornl.gov> <20091015213512.GW5191@obsidianresearch.com> <4AE0E71E.20309@mellanox.com> <1256254394.1579.86.camel@lap75545.ornl.gov> <1256254459.1579.87.camel@lap75545.ornl.gov> <1256254692.1579.89.camel@lap75545.ornl.gov> <4AE0F309.5040201@mellanox.com> <1256256984.1579.105.camel@lap75545.ornl.gov> <4AE0F7DA.20100@mellanox.com> <1256258049.1598.8.camel@lap75545.ornl.gov> <4AE1DEEF.5070205@mellanox.com> <1256335698.10273.62.camel@lap75545.ornl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1256335698.10273.62.camel-FqX9LgGZnHWDB2HL1qBt2PIbXMQ5te18@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Cc: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Linux RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Bart Van Assche <bart.vanassche-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

David Dillow wrote:
> On Fri, 2009-10-23 at 12:50 -0400, Vu Pham wrote:
>   
>> David Dillow wrote:
>> I don't know much about multipath in ALUA mode.
>> How would multipath driver (in ALUA mode) to switch path? (ie. basing on 
>> what criteria?)
>>     
>
> ALUA sets the priority of each path, and generally multipath is set to
> round-robin among all paths of the same priority. So, paths going to the
> primary controller of a LUN get the best priority and are used
> preferentially over the backup paths. Once no more paths in a priority
> group are active, the round-robin selector will fall back to the next
> highest priority path group.
>
> The multipath core will immediately fail a path if the lower layers
> propagate an error up to it, such that an I/O request completes in
> error. If it has failed the path, it will start sending requests down
> alternate paths without waiting for the queue to drain on the first one.
>
>   

Thanks for explaining.
Without these patches, it will take ~3-5 minutes before srp driver 
propagate errors up so that dm-multipath can switch path. You need these 
patches - test them and you'll see.

> ALUA is not like RDAC -- in ALUA, all paths are valid to use, but some
> paths will give better performance. You do not necessarily need to give
> the array a command to move the LUN to another controller, so there's no
> reason to wait for a queue to drain.
>
> At least that is the way I understand things, having picked my way
> through the block layer, multipath core, and device handlers.
>
>   
>> Can you switch path manually in user mode (while there are commands 
>> stucked in current active path)?
>>     
>
> I've not tried, but give the above I don't see why not.
>
>   
>> Without this patch, all outstanding I/Os have to go thru error recovery 
>> before being returned with error code so that dm-multipath fail-over.
>>     
>
> I think we're talking about two separate things here -- I agree that the
> idea of failing IO early when we've lost our local connection, or know
> the target is not in the fabric, is a good one. I want a fast failure so
> that I can immediately start using my alternate paths. I'll have to deal
> with the timeouts on the requests in flight at some point, but they
> don't hold back independent requests.
>   

We talk about the same thing here. Like I said above, these patches are 
needed so that errors can be propagated up faster. Without them, you 
have to wait 3-5 minutes.

> The difference of opinion seems to be in how long to wait after being
> notified of a connection loss -- or the target leaving the fabric --
> before we start kicking back errors at the SRP command dispatch handler.
> I agree that it makes sense to wait a moment before forcing an RDAC path
> change, as they seem to be slow. But I also want it to get out of the
> way for my case, when I don't incur much of a penalty to immediately
> light up my backup path.
>
>   
Both RDAC & ALUA need errors propagated up sooner. With the introducing 
of device_loss_timeout, srp satisfy both RDAC and ALUA modes. You can 
set device_loss_tmo=1 and RDAC can set to 60s or so.

>> If you want to failing requests right away, you can just set 
>> device_loss_timeout=1, others don't want dm-multipath to switch path 
>> right away. That's a whole idea of these patches that I submitted
>>     
>
> The thing is, I don't want to wait even 1 second to use my backup path,
> and I don't want all of those requests going into a black hole for that
> time, forcing me to wait for the SCSI timeout on requests that could
> have been immediately processed. On our system, 1 second is up to 1500
> MB of data transferred over this one connection, and waiting around
> twiddling our thumbs for a single second can potentially cost 1.3
> thousand trillion operations.
>   
It's a big improvement from 3-5 minutes cutting down to 1s and now you 
talk about device_loss_timeout=0
I'll look at the trade-off to have it; however, to receive and process 
the async event (port error) already cost you a fair amount of cycles.


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
