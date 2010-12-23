From: Or Gerlitz <ogerlitz-hKgKHo2Ms0FWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH V3 5/6] RDMA CM: Save Owning PID
Date: Thu, 23 Dec 2010 14:21:07 +0200
Message-ID: <4D133EB3.7030409@Voltaire.com>
References: <1292257370-24391-1-git-send-email-nirm@voltaire.com>	<1292257370-24391-6-git-send-email-nirm@voltaire.com>	<20101214183458.GD2506@obsidianresearch.com>	<1292769382.2369.2145.camel@nirm-desktop>	<20101220215433.GB12090@obsidianresearch.com>	<1292943950.2369.3198.camel@nirm-desktop> <20101221181043.GD12090@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101221181043.GD12090-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Nir Muchtar <nirm-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Andy Grover <andy.grover-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Jason Gunthorpe wrote:
> Nir Muchtar wrote:
> It is tied to the ucma_fops FD (ie /dev/rdma_cm, aka the event
> channel), which when closed calls ucma_free_ctx which calls rdma_destroy_id. 
> Processes that can access that FD can control the RDMA CM IDs associated with it.
> The only case where this is not true is in the kernel, and in that
> instance the PID is meaningless - you'd be much better off exporting
> the name of the module that allocated the RDMA CM ID.

Jason,

I'd like to strengthen the point Nir was trying to make with real-life examples

1. the Linux iscsi initiator - has a daemon named iscsid which opens all the iscsi connections where a connection is over specific transport - e.g iscsi/tcp, iser, iscsi offloads etc. iscsid is talking with the kernel iscsi stack through netlink (...) and in that framework iser connections are started from the **kernel** i.e directly with the rdma-cm and not through librdmacm. With Nir's patches we'd like to be able to track these connections, e.g now I can see through the iscsi tools that I have four sessions (=connections), two of them with iscsi/tcp and two with iser, but I must use a dedicated tool/stack (the iscsi one) for that, wheres if I had a way generic way to track all the connections  made through the rdma-cm things will be much easier.

> # netstat -ntp
> Proto Recv-Q Send-Q Local Address               Foreign Address             State       PID/Program name
> tcp        0      0 192.168.20.1:45858          192.168.20.222:3260         ESTABLISHED 26793/iscsid
> tcp        0      0 192.168.20.1:45859          192.168.20.222:3260         ESTABLISHED 26793/iscsid

no sign for the iser connections, has to use dedicated tool

> # iscsiadm -m session
> iser: [76] 192.168.20.222:3260,1 iqn.iser.A
> tcp: [77] 192.168.20.222:3260,1 iqn.tcp.D
> iser: [79] 192.168.20.222:3260,1 iqn.iser.B
> tcp: [80] 192.168.20.222:3260,1 iqn.tcp.C

2. sdp - the code runs in the kernel, same story, the connections are not tracked, a dedicated "sdpnetstat" tool has to be used. Connections (sockets) are tied to processes and will be best if reported through generic netlink interface

3. rds - again, kernel level rdma-cm, here connections are not tied to processes, but no reporting as of today and dedicated "rds-info" tool has to be used.

I'm sure there are (nfs rdma) and will be more examples for kernel level usage of the rdma-cm for which the pid field is helpful, 

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
