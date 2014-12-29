From: Just Floaterions <floaterions-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: RDMA atomic operations fail
Date: Sun, 28 Dec 2014 20:26:48 -0500
Message-ID: <CAJRcJr0DCsyNYVUAieUbkfSE6od22wL=XAn4MNXTyDt5ZVnxrA@mail.gmail.com>
References: <loom.20141224T040342-951@post.gmane.org>
	<20141228101335.GC1806@mtldesk30>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20141228101335.GC1806@mtldesk30>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Thank you both for your replies. I have a few follow-up questions:

1- How do I know which driver library I'm using (libmlx4, libmlx5,
..)? Also, how can I find out what version of libmlx5 is installed on
my machine?

2- Assuming that I'm using mlx5, how can I install those patches you
mentioned? As far as I know, all libraries on the cluster which I'm
working on are always kept up-to-date.

3- The atomic tests in Perftest benchmarking tool run successfully.
Does this mean the problem is not with the installed libraries? If so,
then what do you think might be the reasons that my code doesn't get
through?

Thank you

On Sun, Dec 28, 2014 at 5:13 AM, Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:
> On Wed, Dec 24, 2014 at 03:08:45AM +0000, floaterions wrote:
>> When I try to submit an RDMA FETCH_AND_ADD or CMP_AND_SWAP ,
>> the ibv_post_send() function fails, with Errno set to "Invalid argument".
>> I have no such problems with RDMA READ/WRITE.
>>
>> I developed my entire code using RDMA CM (so no manual QP transitioning).
>> The queue pair is RC, and Atomic is enabled at the responder queue pair,
>> and the memory regions are registered with atomic access.
>>
>> I suspected that there might be the source of this problem,
>> so I wrote a small program using libibcm where I transition the QPs manually
>> and set the flags fro atomic operations:
>> qp_attr->qp_access_flags = IBV_ACCESS_REMOTE_ATOMIC;
>> qp_attr->max_rd_atomic = <something greater than zero>;
>> qp_attr->max_dest_rd_atomic = <something greater than zero>;
>>
>> But still, the same error (invalid argument).
>>
>
> Hi,
> the current code in upstream does not support atomic operations.
> Patches were sent already that will allow to use atomic operations
> over mlx5 supported devices.
>
> For now, if you query the HCA capabilites you should get ATOMIC_NONE
> at the atomic_cap field when you query the device capabilites.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
