From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH RFC 0/2] Indirect Fast Memory registration support
Date: Mon, 13 Oct 2014 14:18:12 +0300
Message-ID: <543BB4F4.8090203@dev.mellanox.co.il>
References: <1412693281-6161-1-git-send-email-sagig@mellanox.com> <543AD9CD.80803@mellanox.com> <543B91E2.70206@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <543B91E2.70206-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 10/13/2014 11:48 AM, Bart Van Assche wrote:
> On 10/12/14 21:43, Or Gerlitz wrote:
>> Sean, Bart - any comment on the API before Sagi sits down to code the
>> iSER changes?
>
> Hello Or,

Hey Bart,

>
> Will this API ever be supported by other Mellanox RDMA drivers than
> mlx5, e.g. mlx4 ?

Well, unfortunately mlx4 micro-architecture does not support
indirect memory registration. IMHO, simulating it in SW/FW is
not feasible.

> Will this API ever be supported by a Mellanox HCA that
> supports RoCE ?

Yes, mlx5 will support RoCE in the future. Moreover AFAIK future
Mellanox HCAs will keep supporting this technology as it is useful
for other use-cases as well.

> Additionally, do you perhaps know whether any other RDMA
> vendors have plans to implement this API for their RDMA HCA's ?

I can't comment on other vendors plans...
Maybe once this feature is included they will consider it... ;)

> Drivers like the iSER and SRP initiator and target drivers have been implemented
> on top of the RDMA API and support all hardware that implements the RDMA
> API. Since this patch series adds support for the indirect fast memory
> registration API for mlx5 only this means that adding support for this
> API in block storage drivers also means adding a fall-back path for RDMA
> drivers that do not have support for this API. That will make these
> block storage drivers harder to maintain, which is something I would
> like to avoid.

I agree with you on that,

But state-of-the-art devices can introduce new functionality which
sometimes isn't supported in older/other devices. So while keeping
a fall-back logic is a pain, we should strive to adopt new features.

As you know, the problem this feature is solving is even more painful
in iSER than in SRP (only a single rkey per-cmd is allowed) and while
the BB memcopy work-around will not be removed from the code completely,
at least it can hide under some abstraction and be avoided when this
feature is supported.

Cheers,
Sagi.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
