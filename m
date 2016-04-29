From: Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: RDMA Read: Local protection error
Date: Fri, 29 Apr 2016 13:34:55 -0400 (EDT)
Message-ID: <2015776375.32536550.1461951295911.JavaMail.zimbra@redhat.com>
References: <1A4F4C32-CE5A-44D9-9BFE-0E1F8D5DF44D@oracle.com> <57238F8C.70505@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <57238F8C.70505-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Just as an FYI

I went back and tested mlx4 srp as my customer mentioned on the older arrays he was able to set max_sectors_kb=4096.
The claim was that on mlx4 they did not get into the sg map failure issue when issuing 4MB buffered I/O to a file system backed by the SRP targets.
This made no sense to me because I know the issues we addressed in Bart's patch set were in ib_srp. 

I tested without Bart's latest SRP patch set (where we have the throttle back of the max_sectors_kb to avoid the issue) and 
I see the same sg map failures on mlx4 using using FDR not EDR.

So bottom line, with larger max_sectors_kb we will get into this issue on both mlx4 and mlx5 and for now we cannot sustain 4MB for max_sectors_kb with buffered I/O,

Laurence Oberman
Principal Software Maintenance Engineer
Red Hat Global Support Services

----- Original Message -----
From: "Bart Van Assche" <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
To: "Chuck Lever" <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "linux-rdma" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sent: Friday, April 29, 2016 12:45:00 PM
Subject: Re: RDMA Read: Local protection error

On 04/29/2016 09:24 AM, Chuck Lever wrote:
> I've found some new behavior, recently, while testing the
> v4.6-rc Linux NFS/RDMA client and server.
>
> When certain kernel memory debugging CONFIG options are
> enabled, 1MB NFS WRITEs can sometimes result in a
> IB_WC_LOC_PROT_ERR. I usually turn on most of them because
> I want to see any problems, so I'm not sure which option
> in particular is exposing the issue.
>
> When debugging is enabled on the server, and the underlying
> device is using FRWR to register the sink buffer, an RDMA
> Read occasionally completes with LOC_PROT_ERR.
>
> When debugging is enabled on the client, and the underlying
> device uses FRWR to register the target of an RDMA Read, an
> ingress RDMA Read request sometimes gets a Syndrome 99
> (REM_OP_ERR) acknowledgement, and a subsequent RDMA Receive
> on the client completes with LOC_PROT_ERR.
>
> I do not see this problem when kernel memory debugging is
> disabled, or when the client is using FMR, or when the
> server is using physical addresses to post its RDMA Read WRs,
> or when wsize is 512KB or smaller.
>
> I have not found any obvious problems with the client logic
> that registers NFS WRITE buffers, nor the server logic that
> constructs and posts RDMA Read WRs.
>
> My next step is to bisect. But first, I was wondering if
> this behavior might be related to the recent problems with
> s/g lists seen with iSER/SRP? ie, is this a recognized
> issue?

Hello Chuck,

A few days ago I observed similar behavior with the SRP protocol but 
only if I increase max_sect in /etc/srp_daemon.conf from the default to 
4096. My setup was as follows:
* Kernel 4.6.0-rc5 at the initiator side.
* A whole bunch of kernel debugging options enabled at the initiator
   side.
* The following settings in /etc/modprobe.d/ib_srp.conf:
   options ib_srp cmd_sg_entries=255 register_always=1
* The following settings in /etc/srp_daemon.conf:
   a queue_size=128,max_cmd_per_lun=128,max_sect=4096
* Kernel 3.0.101 at the target side.
* Kernel debugging disabled at the target side.
* mlx4 driver at both sides.

Decreasing max_sge at the target side from 32 to 16 did not help. I have 
not yet had the time to analyze this further.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
