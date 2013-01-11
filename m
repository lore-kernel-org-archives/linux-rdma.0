From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH] IB/srp: disconnect to SRP target before removing SCSI
 host
Date: Fri, 11 Jan 2013 20:42:07 +0100
Message-ID: <50F06B0F.9090800@acm.org>
References: <1357394162-26316-1-git-send-email-dongsu.park@profitbricks.com> <50EAB2E1.7050702@acm.org> <20130111140706.GK7859@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130111140706.GK7859-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dongsu Park <dongsu.park-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 01/11/13 15:07, Dongsu Park wrote:
> However, that action will hang forever until the target machine comes up
> again. Precisely it's blocked on scsi_execute() directly after sending
> SYNCHRONIZE_CACHE command to the first target of the host. As IB stack
> is not able to give any response, further target remove cannot be done.

This is the part that needs further research. If a SCSI command is not 
yet finished after the SCSI timeout expired the SCSI error handler will 
try to abort the command. scsi_execute() should finish in time. If not, 
something is wrong either in the LLD (ib_srp), the SCSI core or in the 
block layer. It would help to know what exactly was going on.

Bart.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
