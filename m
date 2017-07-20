From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: Re: CFP: RDMA Microconference - Call for presentations
Date: Thu, 20 Jul 2017 17:59:02 +0300
Message-ID: <ddcc4ea0-1df4-f954-973c-43f8e65b324b@grimberg.me>
References: <20170615050305.GF17846@mtr-leonro.local>
 <20170720040739.GU3259@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170720040739.GU3259-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tzahi Oved <tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hey All,

> REMINDER !!!!!!!

I won't be able to attend, but I'd be very happy if a group
of smart people can discuss some random topics I had in mind:

1. Adding NUMA hints to *all* rdma resources. Right now
there is no way to ask the core to allocate a queue-pair on
a specific numa-node. Some drivers use the device home node
for memory allocation but application locality will usually be
much much better (sq/rq/cq spinlock cost *a lot* more if accessed
across numa nodes for example).

Applications that don't care can simply skip the hint (or pass
NUMA_NO_NODE) and then drivers can do whatever they want.

In just about any kernel driver, resource setup and IO path run on 
different contexts, so numa locality is pretty much always wrong
(or right by accident). Its also true for a lot of user-space
applications.

I also wander what is the least intrusive way to add it.


2. SRQ sizing. No one knows what is a correct SRQ size. This leads
to magic random numbers for SRQ sizes (often copied) pretty much
anywhere used (usually crazy deep). Can the drivers hint applications
what is a "reasonable" size? Can it know? What if I want SRQ per core
or per numa-node?


3. Adaptive interrupt moderation. In order to effectively use irq-poll
(or any other napi-like functionality), interrupt moderation is
important, but its pretty useless if its not adaptive (always too early 
or too late). IMO It would be very useful to have, But before drivers
can start implementing it, we need a good core framework in place.
Does anyone think this is useful to have?


4. I wander if there is any interest to have a striding receive queue
core API? It would be *very* useful to just about any existing kernel
ULP. Who wouldn't like to reduce the frequency of post receive
operations.


Cheers,
Sagi.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
