From: Wendy Cheng <s.wendy.cheng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Helps to Decode rpc_debug Output
Date: Mon, 26 Aug 2013 10:08:19 -0700
Message-ID: <CABgxfbEkgH4f86G2K8SXXQuLsE_R6+Wk_jw294Kcu3vT8Y8WMg@mail.gmail.com>
References: <CABgxfbGFHv2n5=78_irkxXnX9BFDFPzZvqgs_iDn64AR_3cf5w@mail.gmail.com>
	<520CCDBB.1020501@talpey.com>
	<CABgxfbFixDTUy4e1EQty86dvNeisG7+hd2QdVSQvv4T2tokFoQ@mail.gmail.com>
	<CABgxfbH3uA2WzQ2DgOgRrCMhcJ1J6E2NCh13FtDfRzDWje9vWQ@mail.gmail.com>
	<521B56A9.9090003@talpey.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <521B56A9.9090003-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>
Cc: "linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Aug 26, 2013 at 6:22 AM, Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org> wrote:
> On 8/21/2013 11:55 AM, Wendy Cheng wrote:
>>
>> On Thu, Aug 15, 2013 at 11:08 AM, Wendy Cheng <s.wendy.cheng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> wrote:
>>>
>>> On Thu, Aug 15, 2013 at 5:46 AM, Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org> wrote:
>>>>
>>>> On 8/14/2013 8:14 PM, Wendy Cheng wrote:
>>>>>
>>>>>
>>>>> Longer version of the question:
>>>>> I'm trying to enable NFS-RDMA on an embedded system (based on 2.6.38
>>>>> kernel) as a client. The IB stacks are taken from OFED 1.5.4. NFS
>>>>> server is a RHEL 6.3 Xeon box. The connection uses mellox-4 driver.
>>>>> Memory registration is "RPCRDMA_ALLPHYSICAL". There are many issues so
>>>>> far but I do manage to get nfs mount working. Simple file operations
>>>>> (such as "ls", file read/write, "scp", etc) seem to work as well.
>>>>

>> One thing I'm still scratching my head is that ... by looking at the
>> raw IOPS, I don't see dramatic difference between NFS-RDMA vs. NFS
>> over IPOIB (TCP).
>
>
> Sounds like your bottleneck lies in some other component. What's the
> storage, for example? RDMA won't do a thing to improve a slow disk.
> Or, what kind of IOPS rate are you seeing? If these systems aren't
> generating enough load to push a CPU limit, then shifting the protocol
> on the same link might not yield much.

There is no kernel profiling tool with this uOS (yet) so it is hard to
identify the bottleneck. Looking from the surface, the slow down seems
to be from SUNRPC's Van Jacobson congestion control
(xprt_reserve_xprt_cong()) where it either creates a race condition
for the transmissions (write/commit) to miss their wake-up(s); or the
algorithm itself is not a right choice for this client system that
consists of many (244 on my system) slower cores (CPU).

Solid state drives are used on the RHEL server.

-- Wendy
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
