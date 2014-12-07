From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: IB_CQ_VECTOR_LEAST_ATTACHED
Date: Sun, 7 Dec 2014 15:08:11 -0500
Message-ID: <A1DD5C9B-ED0E-42D1-A20C-710C7DAB514B@oracle.com>
References: <54809030.6090107@oracle.com> <5480AB49.1080209@acm.org> <5480B8CE.3080704@oracle.com> <54842A05.9070207@dev.mellanox.co.il>
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <54842A05.9070207-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Shirley Ma <shirley.ma-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


On Dec 7, 2014, at 5:20 AM, Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:

> On 12/4/2014 9:41 PM, Shirley Ma wrote:
>> On 12/04/2014 10:43 AM, Bart Van Assche wrote:
>>> On 12/04/14 17:47, Shirley Ma wrote:
>>>> What's the history of this patch?
>>>>     http://lists.openfabrics.org/pipermail/general/2008-May/050813.html
>>>> 
>>>> I am working on multiple QPs workload. And I created a similar approach
>>>> with IB_CQ_VECTOR_LEAST_ATTACHED, which can bring up about 17% small I/O
>>>> performance. I think this CQ_VECTOR loading balance should be maintained
>>>> in provider not the caller. I didn't see this patch was submitted to
>>>> mainline kernel, wonder any reason behind?
>>> 
>>> My interpretation is that an approach similar to IB_CQ_VECTOR_LEAST_ATTACHED is useful on single-socket systems but suboptimal on multi-socket systems. Hence the code for associating CQ sets with CPU sockets in the SRP initiator. These changes have been queued for kernel 3.19. See also branch drivers-for-3.19 in git repo git://git.infradead.org/users/hch/scsi-queue.git.
>> 
>> What I did is that I manually controlled IRQ and working thread on the same socket. The CQ is created when mounting the file system in NFS/RDMA, but the workload thread might start from different socket, so per-cpu based implementation might not apply. I will look at SRP implementation.
>> 
> 
> Hey Shirley,
> 
> Bart is correct, in general the LEAST_ATTACHED approach might not be
> optimal in the NUMA case. The thread <-> QP/CQ/CPU assignment is
> addressed by the multi-channel approach which to my understanding won't
> be implemented in NFSoRDMA in the near future (right Chuck?)

As I understand it, the preference of the Linux NFS community is that
any multi-pathing solution should be transparent to the ULP (NFS and
RPC, in this case). mp-tcp is ideal in that the ULP is presented with
a single virtual transport instance, but under the covers, that instance
can be backed by multiple active paths.

Alternately, pNFS can be deployed. This allows a dataset to be striped
across multiple servers (and networks). There is a rather high bar to
entering this arena however.

Speculating aloud, multiple QPs per transport instance may require
implementation changes on the server as well as the client. Any
interoperability dependencies should be documented via a standards
process.

And note that an RPC transport (at least in kernel) is shared across
many user applications and mount points. I find it difficult to visualize
an intuitive and comprehensive administrative interface where enough
guidance is provided to place a set of NFS applications and an RPC
transport in the same resource domain (maybe cgroups?).

So for the time being I prefer staying with a single QP per client-
server pair.

A large NFS client can actively use many NFS servers, however. Each
client-server pair would benefit from finding "least-used" resources
when QP and CQs are created. That is something we can leverage today.


> However, the LEAST_ATTACH vector hint will revive again in the future
> as there is a need to spread applications on different interrupt
> vectors (especially for user-space).
> 
> CC'ing Matan who is working on this, perhaps he can comment on this as
> well.

-- 
Chuck Lever
chuck[dot]lever[at]oracle[dot]com




--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
