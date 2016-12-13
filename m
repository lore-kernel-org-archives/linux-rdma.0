From: Joshua McBeth <joshua.mcbeth-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: SR-IOV with mlx4 on ConnectX-2 fails with DMAR errors
Date: Tue, 13 Dec 2016 13:36:42 -0500
Message-ID: <CAN27Ff7hEr4u5nyELjwRXb3W_t0TNefuuT4AzdjAoWWGRHqTFw@mail.gmail.com>
References: <CAN27Ff4RYh3y_45PUxxXhGuDvrrrjm8qe38fj5JPq7oV2QmdYA@mail.gmail.com>
 <CAN27Ff74Ov8bgsZP1QJJOwvWc5_KOW_U=PsP+=Z87AJz+VSAOw@mail.gmail.com> <20161213165441.GB11099@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161213165441.GB11099-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

I bisected the kernel between v4.1 and v4.3.1 by booting each build on
the SR-IOV host and attempting to "ping x.x.x.x" with x.x.x.x being
the IP address assigned to the Infiniband interface of a remote host

At 4be90bc's parent the SR-IOV host is able to ping the remote host,
but at 4be90bc the SR-IOV host is not able to ping the remote host
(destination host unreachable)

The DMAR errors occur in both the kernel built at 4be90bc (not passing
ping test) and its parent (passing ping test)

Reverting only the commit 4be90bc from a later kernel (4.8.x) does not
enable the SR-IOV host to ping the remote host, which to me suggests
that another commit after 4be90bc is also causing my test to fail.

On Tue, Dec 13, 2016 at 11:54 AM, Jason Gunthorpe
<jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
> On Mon, Dec 12, 2016 at 10:57:58PM -0500, Joshua McBeth wrote:
>> Regarding this issue, I discovered earlier kernels were working with
>> SR-IOV enabled and bisected to the commit
>> 4be90bc60df47f6268b594c4fb6c90f0ff2f519f ("IB/mad: Remove
>> ib_get_dma_mr calls").
>>
>> However, this commit seems to be part of a larger refactoring patch
>> set and reverting just this commit does not resolve the DMAR errors
>> nor enable the 'ib0' interface to function.
>
> ?? if you bisected correctly then reverting the ID'd patch should
> solve the problem.
>
> Jason
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
