From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH for-next 0/8] Add Mellanox mlx5 driver for Connect-IB devices
Date: Fri, 28 Jun 2013 16:23:55 +0300
Message-ID: <CAJZOPZK9MvDB-uoZF65OPbzaDR7Ue+_B-u5B6HvUuo54kEHBcQ@mail.gmail.com>
References: <1371384149-24558-1-git-send-email-eli@dev.mellanox.co.il>
	<CAJZOPZ+NQa3CWnw3rZQh2UuwdrNhiwtVSyuk9D9YtwfQQ9e1XA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJZOPZ+NQa3CWnw3rZQh2UuwdrNhiwtVSyuk9D9YtwfQQ9e1XA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Jun 28, 2013 at 4:20 PM, Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> On Sun, Jun 16, 2013 at 3:02 PM, Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:
>>
>> From: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>>
>> The patches that follow constitute the driver for Mellanox's 5th
>> generation
>> of HCAs named Connect-IB.
>>
>> The driver is comprised of two kernel modules: mlx5_ib and mlx5_core. This
>> partitioning resembles what we have for mlx4 with the substantial
>> difference
>> that mlx5_ib is the pci device driver and not mlx5_core.
>
>
> Hi Roland,
>
> We're on 3.10-rc7 && soon on -rc8, so things warm up for 3.11... today will
> mark two working weeks since the mlx5 driver was posted here, and no
> comment, its marked as new in your patchwork. Is this safe for 3.11?  any
> comments or fixes we have to apply? As you probably saw, I posted V1 which
> is essentially almost the same as V0 but with netdev copied, to see if there
> are rejections/comments from there, so far nothing. Dave said he wants to
> see this posted to netdev inorder to decide if he's OK for the core driver
> to be pushed through your tree too.

If this helps, the patches are here
git://beany.openfabrics.org/~eli/connect-ib.git branch mlx5-v1-int
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
