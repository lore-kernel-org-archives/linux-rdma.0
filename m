From: Vladislav Bolkhovitin <vst-d+Crzxg7Rs0@public.gmane.org>
Subject: Re: [ofa-general][PATCH 3/4] SRP fail-over faster
Date: Thu, 29 Oct 2009 21:42:46 +0300
Message-ID: <4AE9E226.10507@vlnb.net>
References: <4AD3B453.3030109@mellanox.com> <ada1vl5alqh.fsf@cisco.com> <4AD63681.6080901@mellanox.com> <adaljjd8zrj.fsf@cisco.com> <4AD63DB1.3060906@mellanox.com> <adahbu18uf5.fsf@cisco.com> <1255570760.13845.4.camel@obelisk.thedillows.org> <4AD74C88.8030604@mellanox.com> <1255634715.29829.9.camel@lap75545.ornl.gov> <20091015213512.GW5191@obsidianresearch.com> <4AE0E71E.20309@mellanox.com> <1256254394.1579.86.camel@lap75545.ornl.gov> <1256254459.1579.87.camel@lap75545.ornl.gov> <1256254692.1579.89.camel@lap75545.ornl.gov> <4AE0F309.5040201@mellanox.com> <1256256984.1579.105.camel@lap75545.ornl.gov> <4AE0F7DA.20100@mellanox.com> <1256258049.1598.8.camel@lap75545.ornl.gov> <4AE1DEEF.5070205@mellanox.com> <1256335698.10273.62.camel@lap75545.ornl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1256335698.10273.62.camel-FqX9LgGZnHWDB2HL1qBt2PIbXMQ5te18@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Cc: Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Linux RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Bart Van Assche <bart.vanassche-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

David Dillow, on 10/24/2009 02:08 AM wrote:
> On Fri, 2009-10-23 at 12:50 -0400, Vu Pham wrote:
>> David Dillow wrote:
>> I don't know much about multipath in ALUA mode.
>> How would multipath driver (in ALUA mode) to switch path? (ie. basing on 
>> what criteria?)
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
> ALUA is not like RDAC -- in ALUA, all paths are valid to use, but some
> paths will give better performance. You do not necessarily need to give
> the array a command to move the LUN to another controller, so there's no
> reason to wait for a queue to drain.
> 
> At least that is the way I understand things, having picked my way
> through the block layer, multipath core, and device handlers.

Unfortunately, it isn't always so simple. Sometimes there are 
dependencies between order of requests, so you have to drain the failed 
path before sending retries to the alternate path to make sure that the 
retries will not interfere with not yet aborted requests from the failed 
paths.

Just to make things more precise.

Vlad

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
