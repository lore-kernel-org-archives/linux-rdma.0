From: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: Question on mlx4 log_num_mtt and log_mtt_per_seg setting
Date: Mon, 21 Jan 2013 18:57:14 +0200
Message-ID: <CAL3tnx4XSQ+iozQpH8btYoDVoYy+715mOJ9zundvdek0e4o6Qw@mail.gmail.com>
References: <50FCB147.7090303@vt.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <50FCB147.7090303-PjAqaU27lzQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bharath Ramesh <bramesh-PjAqaU27lzQ@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Bharath,

each MTT entry is used to cover a whole page. Assuming page size in
you system equals 4K, the max total of registered memory is 2^(12+24)
which is 64 GB.
The log_mtt_per_seg param denotes the granularity of the allocator
managing MTTs. So, in your case, MTTs are allocated in granularity of
2. So if you try to allocate 3 MTTs, you'll end up consuming 4.
Moreover, the MTT allocator is a buddy allocator that allocates power
of 2 MTT segments. So if you register memory that requires (2^15 + 1)
MTTs, you'll actually consume 2^16 MTTs!

In your case I would try to use 2^25 MTTs and log_mtt_per_seg=1. If
the driver fails to load (probably because the allocator fails to
allocate memory), try to use 2^24 and 2^2 etc.

I hope that helps.



On Mon, Jan 21, 2013 at 5:08 AM, Bharath Ramesh <bramesh-PjAqaU27lzQ@public.gmane.org> wrote:
> I am trying to find the correct setting for log_num_mtt and log_mtt_per_seg
> should be for our cluster. Each node has 64G of RAM. We are having issues
> when running MPI applications, the error is related to registering memory.
> The current setting log_num_mtt=24 and log_mtt_per_seg=1. There are lot of
> conflicting documentations available with regards how these settings should
> be changed. I was wondering if the community could explain how these
> settings works so that we can come up with the correct settings that will
> work in our environment. This document [1] specifically says that
> log_mtt_per_seg should always be 1. However, OpenMPI mailing list post [2]
> talks about different value. Any help on this is appreciated. I am not
> subscribed to the list so would really appreciate if I am copied in the
> replies.
>
> [1] http://www.open-mpi.org/faq/?category=openfabrics#ib-low-reg-mem
> [2] http://www.open-mpi.org/community/lists/users/2011/09/17222.php
>
> --
> Bharath
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
