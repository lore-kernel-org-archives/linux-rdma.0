From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: dapltest question
Date: Fri, 08 Jul 2011 11:38:19 -0500
Message-ID: <4E17327B.8050104@opengridcomputing.com>
References: <4E1720F1.5080201@opengridcomputing.com> <2DDE0F15AAFF91448E6F813C42EF4CBE022102@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <2DDE0F15AAFF91448E6F813C42EF4CBE022102-P5GAC/sN6hmkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Smith, Stan" <stan.smith-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 07/08/2011 11:14 AM, Smith, Stan wrote:
>> -----Original Message-----
>> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Steve Wise
>> Sent: Friday, July 08, 2011 8:23 AM
>> To: Davis, Arlin R
>> Cc: linux-rdma
>> Subject: dapltest question
>>
>> Hey Arlin,
>>
>> I have a dumb question:  Is dapltest designed to support multiple dapltest client processes running on multiple physical
>> systems to connect to a single dapltest server process/system?
>>
>> I'm running tests where we have 4 client nodes running dapltest transaction clients connecting to the same dapltest
>> server on a 5th node and I'm debugging a dapltest server hang.  I have more details if you're interested, but I just
>> wanna make sure dapltest is designed to support this mode.
>>
> Hi Steve,
>    Arlin is out for at least a week.
> 'dapltest' server is designed to service [1...n] dapltest clients and is routinely tested in this manner.

Ok thanks.  That's wanted to confirm.

> Send me your dapltest client/server invocations and I'll give them a try.
> Which DAPL provider are you using?
>
This is with OFED-1.5.3.1 dapl-2.0.32.

Here are the /etc/dat.conf entries:

chelsio1 u2.0 nonthreadsafe default libdaplofa.so.2 dapl.2.0 "eth10 0" ""
chelsio2 u2.0 nonthreadsafe default libdaplofa.so.2 dapl.2.0 "eth11 0" ""
chelsio3 u2.0 nonthreadsafe default libdaplofa.so.2 dapl.2.0 "eth12 0" ""
chelsio4 u2.0 nonthreadsafe default libdaplofa.so.2 dapl.2.0 "eth13 0" ""



The test is running 4 dapltest servers, each bound to a specific chelsio port.  Each port/interface is on its own IP 
network. There are 4 client nodes, each with 4 port cards connected.  Each client has 4 scripts looping running this 
dapltest client, one to each server via the appropriate dapl device:

# cat scripts/dapl_run.sh
host=$1
device=$2
while [ 1 ]
do
dapltest -T T -s ${host} -D ${device} -i 100000 -t 2 -w 2 \
         client SR 256                                      \
         server RW 4096                                     \
         server SR 256                                      \
         client SR 256                                      \
         server RW 4096                                     \
         server SR 256                                      \
         client SR 4096                                     \
         server SR 256                                      \
         client RW 4096 1 \
         server RW 2048 4 \
         client SR 1024 4   server  SR  4096  2 \
         client SR 1024 3 -f server SR 2048 1 -f server RR 8192 1  client RR
8192 1
sleep 5
done


The first issue we ran into was the dapltest server connection request EVD was overflowing.  Its hard coded to a depth 
of 8, so I bumped it up to 256. That alleviated over failures on the server.  With this patch, the clients ran longer, 
but eventually they all start failing and cannot connect to the servers anymore.  I got core dumps for the servers, and 
the master server thread, DT_cs_Server(), is stuck waiting on the current test threads to wake it up indicating they're 
ready to accept connections.  So its stuck at line 560 in an infinite wait.  After analysis of the core dump, I see the 
test threads that were created, have all exited, but never woke up the master server thread.  Most likely they bailed 
out due to some other error before waking up the server.  I'm continuing to debug.

Most likely there is some error in the RDMA provider that is causing these downstream issues.

So at this point, I think 2 changes might make dapltest more robust:

1) make the DT_cs_Server connection request EVD bigger.

2) Any test threads that start up should always wake up the synch_wait_object waiter no matter what.  -or- DT_cs_Server 
should have a timeout on the wait.

Steve.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
