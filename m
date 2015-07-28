From: james harvey <jamespharvey20-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: How to disconnect a SRP (SCSI RDMA Protocol) drive after unmounting
Date: Tue, 28 Jul 2015 01:15:58 +0000
Message-ID: <CA+X5Wn5dH2iz0SJVFQfjfD-Z5dfnGY+x9_c7krUw8_NFQy-w9g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

I  have an InfiniBand network working with SRP sharing.

On the target system, I am running targetcli (the -fb free branch
version) and OpenFabric's srptools.

On the initiator system, I am running OpenFabric's srptools.

After I've gotten srp on the initiator to link a SRP target as a local
drive, mounted it, done whatever I wanted to with it, and unmounted
it... How do I make it go away as a local drive? i.e. If I wanted it
to not be accessible, if I want another machine to use it via SRP,
etc, or if I need to reboot the target system and want everything
clean beforehand. (I can run sync on the initiator, but I'd prefer a
way to disconnect it.)

Stopping srptools.service has no effect. In fact, I can still mount
and use the drive without it running. It seems to run as a daemon to
connect to new targets, but doesn't seem necessary to be running after
they're connected.

I've looked at ibsrpdm and srp_daemon themselves, and see no such functionality.

I've also tried commenting the entry in srp_daemon.conf, so it
defaults to disallowing the connection, and restarting srptools.

I see there's srp_remove_target, srp_disconnect_target, and
scsi_remove_host functions, but I'm not sure what program (if any)
exposes them to the cli.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
