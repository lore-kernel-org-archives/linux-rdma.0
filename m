From: Marcel Apfelbaum <marcel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: Proposal for the 2nd RDMA microconference (LPC 2017)
Date: Mon, 26 Jun 2017 17:46:54 +0300
Message-ID: <ede53223-8158-4e93-2707-47271e54831f@redhat.com>
References: <20170626052117.GX1248@mtr-leonro.local>
 <20170626053841.GZ1248@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170626053841.GZ1248-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 26/06/2017 8:38, Leon Romanovsky wrote:
> On Mon, Jun 26, 2017 at 08:21:17AM +0300, Leon Romanovsky wrote:
>> David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
>> Bcc:
>> Subject: Re: Proposal for the 2nd RDMA microconference (LPC 2017)
>> Reply-To:
>> In-Reply-To: <786f10f7-6253-c95b-49e2-a89010a43781-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>>
>> On Sun, Jun 25, 2017 at 11:43:35AM +0300, Marcel Apfelbaum wrote:
>>> Hi Leon,
>>>
>>> Here is our proposal for the coming conference.
>>
>> Thanks Marcel for sending proposal, I'm looking forward to see you and
>> Yuval there.
>>

Hi Leon,
We will do our best to get there :).

>> In the meantime, I'm adding David who is our LPC POC and would like to
>> ask some questions.
>>

Hi David, thanks for the interest.

>>>
>>> Abstract
>>> --------
>>> QEMU's limited RDMA support leaves it behind other modern hypervisors.
>>> Marcel and/or Yuval will present the implementation of an emulated RDMA
>>> device, analyze its performance and usability, and finally talk about future
>>> plans for a possible virtio-rdma device.
>>
>> How are you implementing different fabrics?

See below.

  Does it completely SW
>> implementation and/or it requires HW beneath like prvdma?

The pvrdma implementation does not require RDMA hardware,
it only needs an IB interface. It can be exposed by a
software device (e.g. a SoftRoCE instance on top of a macvtap interface)
or an phys RDMA device (RoCE or IB).

>> Namespaces, migration?
>>

This is where we might need some help on design. At first we thought
about using virtual Gids/QPs/CQs... ids and implement some discovery
protocol to find the "other side". However it will not work with
bare-metal nodes or even with VMware's pvrdma devices and
the usability would be limited.

A newer direction is to use "real" Gids,Qps,... ids, but find a way
to partition the resources per MAC/GID so we can be sure
we can continue with the same ids on the destination. If we
have RDMA hw, we would need obviously hw support in passing
the resources state to destination.

>> What are the expectations from the community?
>>

The community may help with the design and may raise
concerns we didn't think of.

Besides the above,an interesting topic would be performance,
the current implementation exits to host per "post_send"
which may be not optimal.
Finally, in a non-RDMA network we need to think how to
improve the software based backend (e.g. SoftRoCe),
for example faster loopback for "VM-VM on same host"
scenario.

Thanks,
Marcel




>>>
>>> Audience
>>> --------
>>> The audience is developers interested in device emulation / RDMA.
>>> They can expect an interesting discussion on what are the difficulties to
>>> work with RDMA in Virtual Machines and they will be welcomed to share their
>>> ideas.
>>>
>>> Benefits to the Ecosystem
>>> -------------------------
>>> Knowing how to tackle RDMA on virtualization may give developers an easier
>>> start on adding RDMA support to QEMU, which in turn will leverage the modern
>>> RDMA cards on virtualized environments.
>>>
>>>
>>> Thanks,
>>> Marcel & Yuval
> 
> 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
