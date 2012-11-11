From: David McMillen <mcmillen-WVYJKLFxKCc@public.gmane.org>
Subject: RDMA in command pipeline
Date: Sun, 11 Nov 2012 00:35:51 +0000
Message-ID: <7B15327CDAFA6946913A74B184E11390068C8244@CFWEX01.americas.cray.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


I would like to use the speed of RDMA when doing pipelines, especially those over a network that might support RDMA.  For example, right now I'd like to do the following:

dd if=/dev/sdd bs=1024k | ssh othersystem dd bs=1024k of=/dev/sde

If those two dd commands could connect standard out and standard in with RDMA over a FDR infiniband, the disks would have to do 6 GB/s to keep up.

I see two problems to overcome:

 1) The normal pipes in most systems are much slower than RDMA transfers, so just creating a RDMA enabled replacement for ssh in that command does not solve the problem.

 2) Creating a replacement for ssh is a difficult task, and given what I want to do probably compromises ssh too much to be a reasonable option to add.

Maybe I am not being creative enough?

At the moment, I am leaning toward custom versions of programs that could use the speed, like tar and dd.  I would add something that would change their use of standard in and standard out to instead use RDMA functionality.  Any thoughts on how that syntax might be included are appreciated.

I still would like to use ssh as the basic mechanism to reach out to another node and authenticate.  However, it is impossible to see the underlying socket that the two ends of ssh are using, since the commands in the pipeline only see some form of local pipe.  Any bright ideas on how to sort this out?  I haven't even figured out a way to get a list of RDMA enabled endpoints that are on a node, at least in a form suitable for a call to rdma_bind_addr() or some predecessor to rdma_connect() needs.

It seems like this would be a useful capability to have. If there is something out there, please point me to it.  Otherwise, I am going to have to do something on my own.   I'd be willing to make sure it is suitable for general use if I get some comments back about what that would be.

Thanks,
    Dave McMillen

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
