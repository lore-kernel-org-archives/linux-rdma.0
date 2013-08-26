From: Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>
Subject: Re: Helps to Decode rpc_debug Output
Date: Mon, 26 Aug 2013 09:22:49 -0400
Message-ID: <521B56A9.9090003@talpey.com>
References: <CABgxfbGFHv2n5=78_irkxXnX9BFDFPzZvqgs_iDn64AR_3cf5w@mail.gmail.com> <520CCDBB.1020501@talpey.com> <CABgxfbFixDTUy4e1EQty86dvNeisG7+hd2QdVSQvv4T2tokFoQ@mail.gmail.com> <CABgxfbH3uA2WzQ2DgOgRrCMhcJ1J6E2NCh13FtDfRzDWje9vWQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CABgxfbH3uA2WzQ2DgOgRrCMhcJ1J6E2NCh13FtDfRzDWje9vWQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Wendy Cheng <s.wendy.cheng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 8/21/2013 11:55 AM, Wendy Cheng wrote:
> On Thu, Aug 15, 2013 at 11:08 AM, Wendy Cheng <s.wendy.cheng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> On Thu, Aug 15, 2013 at 5:46 AM, Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org> wrote:
>>> On 8/14/2013 8:14 PM, Wendy Cheng wrote:
>>>>
>>>> Longer version of the question:
>>>> I'm trying to enable NFS-RDMA on an embedded system (based on 2.6.38
>>>> kernel) as a client. The IB stacks are taken from OFED 1.5.4. NFS
>>>> server is a RHEL 6.3 Xeon box. The connection uses mellox-4 driver.
>>>> Memory registration is "RPCRDMA_ALLPHYSICAL". There are many issues so
>>>> far but I do manage to get nfs mount working. Simple file operations
>>>> (such as "ls", file read/write, "scp", etc) seem to work as well.
>>>
>
> Yay ... got this up .. amazingly on a uOS that does not have much of
> the conventional kernel debug facilities.

Congrats!

> One thing I'm still scratching my head is that ... by looking at the
> raw IOPS, I don't see dramatic difference between NFS-RDMA vs. NFS
> over IPOIB (TCP).

Sounds like your bottleneck lies in some other component. What's the
storage, for example? RDMA won't do a thing to improve a slow disk.
Or, what kind of IOPS rate are you seeing? If these systems aren't
generating enough load to push a CPU limit, then shifting the protocol
on the same link might not yield much.

> However, the total run time differs greatly. NFS
> over RDMA seems to take a much longer time to finish (vs. NFS over
> IPOIB). Not sure why is that .... Maybe by the constant
> connect/disconnect triggered by reestablish_timeout ? The connection
> re-establish is known to be expensive on this uOS.

Um, yes, of course. Fix that before drawing any conclusions.

Tom.
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
