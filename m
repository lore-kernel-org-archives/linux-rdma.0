From: torn5 <torn5-9AbUPqfR1/2XDw4h08c5KA@public.gmane.org>
Subject: Possible bug on SRP device delete
Date: Mon, 13 Dec 2010 17:32:01 +0100
Message-ID: <4D064A81.6000607@shiftmail.org>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hello all,
on the SCST-devel mailing list I posed the following question regarding 
the removal of mapped SRP disks.
I have been suggested to the RDMA mailing list as it might be an ib_srp bug:

>>         5) If I echo one line of ibsrpdm -c to
>>         /sys/class/infiniband_srp/srp-mthca0-1/add_target so to add a
>>         srp disk
>>         to my system, what happens is that another srp_host gets
>>         created. If I
>>         later remove the drive with "echo 1 >
>>         /sys/block/sdX/device/delete", the
>>         /sys/class/srp_hosts/srp_hostXY remains. Now after having
>>         remapped and
>>         deleted a few times the disk I am totally polluted of srp_host's.
>>         Another serious problem is that srp_daemon (from srptools)
>>         thinks the
>>         disk is still connected because it sees the previous
>>         srp_host, and won't
>>         reconnect it (won't recreate the sdX device).
>>         So what is the proper way to unmap a srp drive also deleting
>>         the srp_host?
>>
>>
>>     Seems like an ib_srp bug to me. Please report this on the
>>     linux-rdma mailing list
>>     (http://vger.kernel.org/vger-lists.html#linux-rdma).
>     Will do. What part seems a bug, the fact srp_hostXY does not go
>     away together with the device?
>
>
> Please keep in mind that with the SRP protocol multiple LUNs share one 
> RDMA channel. That RDMA channel won't be closed and reopened because a 
> single host is deleted. ib_srp however should reconnect the RDMA 
> channel if /eh_host_reset_handler/ is invoked on /ib_srp/.
> Notes:
> - IMHO ib_srp should be modified such that it reports SCSI commands as 
> failed as soon as an IB error completion has been received instead of 
> waiting until these commands time out. That would make ib_srp recover 
> much more quickly from cable reconnects or SRP target restarts.
> - Please don't use sg_reset on ib_srp, or you will hit this: 
> https://bugzilla.kernel.org/show_bug.cgi?id=13893.

I can't currently understand the whole explanation, but please have a 
look if you think there is a bug.

Also I would like to know, as per my original question, what was the 
correct procedure for also removing the srp_host. There should be some 
way to remove it, shouldn't it?

Thank you
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
