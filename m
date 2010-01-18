From: Bart Van Assche <bart.vanassche-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Reducing the number of IB interrupts caused by the SRP initiator
Date: Mon, 18 Jan 2010 13:29:00 +0100
Message-ID: <e2e108261001180429t47945679kc7782f28ba9add99@mail.gmail.com>
References: <201001172008.16461.bart.vanassche@gmail.com>
	 <4e6a6b3c1001180329n25e4257brc55fa037b97e0d18@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4e6a6b3c1001180329n25e4257brc55fa037b97e0d18-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Jan 18, 2010 at 12:29 PM, Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wr=
ote:
>
> On Sun, Jan 17, 2010 at 9:08 PM, Bart Van Assche
> <bart.vanassche-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> > Once I noticed that the SRP initiator triggers two IB interrupts pe=
r I/O (more
> > precise, per srp_queuecommand() call) I started looking at reducing=
 the number
> > of IB interrupts. The patch below didn't help. Does this mean that =
the patch
> > below isn't complete or is this because of the hw driver used durin=
g the test
> > (mlx4) ?
>
> When you say that the patch did not help, do you mean that it did not
> reduce the rate of interrupts?

Yes.

>=A0I also think that you have a race here
> since the head and tail operations are not protected (I don't know th=
e
> SRP driver I think locking should be done here).

The race was already present in the original SRP driver: tx_tail is
not consistently protected by target->scsi_host->host_lock. As far as
my analysis of the tx_tail access patterns is correct this race
doesn't hurt in the original SRP driver. But you are right, I should
carefully analyze whether this race is acceptable.

> It would be better if
> you'd choose a value that is a fraction of the queue size to request =
a
> completion so that you don't get to a situation where your queue is
> full and you the sender is waiting for it to be cleared. Also, you di=
d
> not touch the completion handler. Seems to me you should increment th=
e
> tail for each completion by the number of completions you skipped.
> Failing to do so will keep cause the completion to be requested each
> post after the first time it skipped queue len completions.

Thanks -- will have a look at this.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
