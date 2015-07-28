From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: How to disconnect a SRP (SCSI RDMA Protocol) drive after
 unmounting
Date: Mon, 27 Jul 2015 21:00:53 -0700
Message-ID: <55B6FE75.6030204@sandisk.com>
References: <CA+X5Wn5dH2iz0SJVFQfjfD-Z5dfnGY+x9_c7krUw8_NFQy-w9g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CA+X5Wn5dH2iz0SJVFQfjfD-Z5dfnGY+x9_c7krUw8_NFQy-w9g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: james harvey <jamespharvey20-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 07/27/15 18:15, james harvey wrote:
> I  have an InfiniBand network working with SRP sharing.
>
> On the target system, I am running targetcli (the -fb free branch
> version) and OpenFabric's srptools.
>
> On the initiator system, I am running OpenFabric's srptools.
>
> After I've gotten srp on the initiator to link a SRP target as a local
> drive, mounted it, done whatever I wanted to with it, and unmounted
> it... How do I make it go away as a local drive? i.e. If I wanted it
> to not be accessible, if I want another machine to use it via SRP,
> etc, or if I need to reboot the target system and want everything
> clean beforehand. (I can run sync on the initiator, but I'd prefer a
> way to disconnect it.)
>
> Stopping srptools.service has no effect. In fact, I can still mount
> and use the drive without it running. It seems to run as a daemon to
> connect to new targets, but doesn't seem necessary to be running after
> they're connected.
>
> I've looked at ibsrpdm and srp_daemon themselves, and see no such functionality.
>
> I've also tried commenting the entry in srp_daemon.conf, so it
> defaults to disallowing the connection, and restarting srptools.
>
> I see there's srp_remove_target, srp_disconnect_target, and
> scsi_remove_host functions, but I'm not sure what program (if any)
> exposes them to the cli.

Hello James,

This might be what you are looking for:

echo 1 > /sys/class/srp_remote_ports/${port}/delete

The above command deletes all SCSI devices that are associated with a 
particular SRP port. It is important to sync and umount these devices 
before running the above command because all I/O requests that are 
submitted after that command has been run will fail.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
