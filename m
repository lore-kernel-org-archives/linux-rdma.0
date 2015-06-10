From: Bob Ciotti <Bob.Ciotti-NSQ8wuThN14@public.gmane.org>
Subject: Re: rdmacm issue
Date: Wed, 10 Jun 2015 09:51:49 -0700
Message-ID: <55786B25.8050003@nasa.gov>
References: <5577986B.7070702@nasa.gov> <55783D21.1050104@dev.mellanox.co.il>
Reply-To: <Bob.Ciotti-NSQ8wuThN14@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <55783D21.1050104-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



On 06/10/2015 06:35 AM, Hal Rosenstock wrote:
> On 6/9/2015 9:52 PM, Bob Ciotti wrote:
>> We have an issue where lustre servers and clients cannot talk to each
>> other.
>> There are about 11,000 clients all trying to connect to a server that
>> just been rebooted
>> (nbp6-oss3 in this example)
>>
>> pfe21 is a lustre client thats trying to remount the filesystem from
>> nbp6-oss3.
>>
>> running rping server on pfe21 hangs and waits until the client tried to
>> connect, then it prints out
>> debug information up to cq_thread started. and hangs there, for a minute
>> or so until issuing the two UNREACHABLE errors:
>>
>> pfe21 ~ # rping -v -s -d -P -p2 -a 10.151.27.19
>> port 2
>> created cm_id 0x60e350
>> rdma_bind_addr successful
>> rdma_listen
>> cma_event type RDMA_CM_EVENT_CONNECT_REQUEST cma_id 0x60b620 (child)
>> child cma 0x60b620
>> created pd 0x60bd80
>> created channel 0x60bda0
>> created cq 0x60bdc0
>> created qp 0x60bf00
>> rping_setup_buffers called on cb 0x60b8c0
>> allocated & registered buffers...
>> accepting client connection request
>> cq_thread started.
>> cma_event type RDMA_CM_EVENT_UNREACHABLE cma_id 0x60b620 (child)
>> cma event RDMA_CM_EVENT_UNREACHABLE, error -110
>>
>>
>> The rping client is started below. As soon as it starts, it runs up to
>> the point
>> of cq_thread started. Hangs there and eventually times out as well,
>> issuing 4 error
>> messages:
>>
>> nbp6-oss3 ~ # rping -c -vp-d -S 30 -p 2 -a 10.151.27.19
>> size 30
>> port 2
>> created cm_id 0x60f640
>> cma_event type RDMA_CM_EVENT_ADDR_RESOLVED cma_id 0x60f640 (parent)
>> cma_event type RDMA_CM_EVENT_ROUTE_RESOLVED cma_id 0x60f640 (parent)
>> rdma_resolve_addr - rdma_resolve_route successful
>> created pd 0x60ab10
>> created channel 0x60ab30
>> created cq 0x60ab50
>> created qp 0x60ac60
>> rping_setup_buffers called on cb 0x6072e0
>> allocated & registered buffers...
>> cq_thread started.
>> cma_event type RDMA_CM_EVENT_UNREACHABLE cma_id 0x60f640 (parent)
>> cma event RDMA_CM_EVENT_UNREACHABLE, error -110
>> wait for CONNECTED state 4
>> connect error -1
>>
>>
>> Any ideas? The neighbor entries on both side were in a reachable state
>> before the test. And the two systems did manage to find one another.
>> Keep in mind that when this
>> is going on, 11,000+ clients are trying to connect to nbp6-oss3
>>
>> Normally lustre mounts fine and rping have no issues. We have noticed
>> some neighbor resolution issues and are considering ucast_solicit,
>> mcast_solicit, and unres_qlen changes
>> because we also occationally experience issues with icmp ping. Its
>> typically been the experience that changing these configs have little
>> effect.  Yes its probably the case that
>> unicast arp refresh has long failed and 11,000+ clients may be
>> multicasting for
>> for arp.
>>
>> Any help or insight greatly appreciated.
>
> RDMA_CM_EVENT_UNREACHABLE is indicated when there are timeouts in
> underlying CM protocol exchange. I suspect that the server is really
> busy and doesn't respond to the low level CM MADs in a timely manner.
> RDMA CM (and other kernel ULPs like IPoIB and SRP use hard coded local
> and remote response timeouts of 20 which is ~4.3 sec. This was discussed
> back in 2006 in
> http://comments.gmane.org/gmane.linux.drivers.openib/27664. In this
> scenario, the response took more than 30 seconds.  More recently, there
> was proposal to base RDMA CM response timeout on subnet timeout
> (http://permalink.gmane.org/gmane.linux.drivers.rdma/19969).
>
> HTH,
> Hal
>
>>
>> thx, bob
>>

Looking more carefully at our configuration, we dropped a module configuration parameter for ib_cm. In the past we set
/sys/module/ib_cm/parameters/max_timeout to 24

That change was dropped (maybe intentionally because we found it necessary), so will pick up the default of 21. Since rdma_cm
set this based on subnet timeout + 2 made this necessary for some time. Our subnet timeout value is 20, so rdma_cm adds +2 to that
value, getting it back to a value of 22 == 1.024 second, instead of the previous 4 seconds. Now, these values seem giant, but its
still possible that we could be seeing retry flooding because lustre is persistent. Since rdma_cm bases its timeouts on +2 over subnet,
then either we increase subnet timeout or change rdma_cm. This looks like another case where exponential backoff of retries could be
beneficial.

bob

(hal/sean - thanks!)
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
