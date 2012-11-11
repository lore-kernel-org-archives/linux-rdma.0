From: Joseph Glanville <joseph.glanville-2MxvZkOi9dvvnOemgxGiVw@public.gmane.org>
Subject: Re: RDMA in command pipeline
Date: Mon, 12 Nov 2012 00:09:47 +1100
Message-ID: <CAOzFzEh3Cb4Y2Dz4_bUBW1jVoxgq+7f6PvEATaiKmo+XUZikpA@mail.gmail.com>
References: <7B15327CDAFA6946913A74B184E11390068C8244@CFWEX01.americas.cray.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <7B15327CDAFA6946913A74B184E11390068C8244-aOe8g7e11MUSZAcGdq5asVgOPcOSbvolAL8bYrjMMd8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David McMillen <mcmillen-WVYJKLFxKCc@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 11 November 2012 11:35, David McMillen <mcmillen-WVYJKLFxKCc@public.gmane.org> wrote:
>
> I would like to use the speed of RDMA when doing pipelines, especially those over a network that might support RDMA.  For example, right now I'd like to do the following:
>
> dd if=/dev/sdd bs=1024k | ssh othersystem dd bs=1024k of=/dev/sde
>
> If those two dd commands could connect standard out and standard in with RDMA over a FDR infiniband, the disks would have to do 6 GB/s to keep up.
>
> I see two problems to overcome:
>
>  1) The normal pipes in most systems are much slower than RDMA transfers, so just creating a RDMA enabled replacement for ssh in that command does not solve the problem.

Pipes are actually quite fast especially on Linux. The biggest problem
you might have encountered is that they don't have a very large
buffer.

It would be reasonably trivial to use rsockets to implement an RDMA
version of nc (netcat) in fact from memory there is some example code
in the librdmacm repo that does 90% of that. All you would need to add
is data reading / writing to stdin/stdout.

>
>  2) Creating a replacement for ssh is a difficult task, and given what I want to do probably compromises ssh too much to be a reasonable option to add.

I wouldn't replace SSH. I would use SSH to launch the server side of a
RDMA netcat application.

>
> Maybe I am not being creative enough?
>
> At the moment, I am leaning toward custom versions of programs that could use the speed, like tar and dd.  I would add something that would change their use of standard in and standard out to instead use RDMA functionality.  Any thoughts on how that syntax might be included are appreciated.
>
> I still would like to use ssh as the basic mechanism to reach out to another node and authenticate.  However, it is impossible to see the underlying socket that the two ends of ssh are using, since the commands in the pipeline only see some form of local pipe.  Any bright ideas on how to sort this out?  I haven't even figured out a way to get a list of RDMA enabled endpoints that are on a node, at least in a form suitable for a call to rdma_bind_addr() or some predecessor to rdma_connect() needs.

Use SSH to exec your application with a appropriate command line args
before connecting with your client application. Something along the
lines of this:

ssh user@server "rdmaserver -s -p port > /path/to/file"
dd if=infile bs=1M | rdmaclient -c rdmaserver -p port

Something along the lines of that.

>
> It seems like this would be a useful capability to have. If there is something out there, please point me to it.  Otherwise, I am going to have to do something on my own.   I'd be willing to make sure it is suitable for general use if I get some comments back about what that would be.
>
> Thanks,
>     Dave McMillen
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
CTO | Orion Virtualisation Solutions | www.orionvm.com.au
Phone: 1300 56 99 52 | Mobile: 0428 754 846
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
