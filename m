From: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH V7 libibverbs 0/7] Add extension and XRC QP support
Date: Mon, 15 Jul 2013 15:40:47 +0300
Message-ID: <51E3EDCF.2050007@dev.mellanox.co.il>
References: <1373555063-31790-1-git-send-email-yishaih@mellanox.com> <20130711170710.GB27357@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130711170710.GB27357-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org, tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Jason,

Let me clarify the place holder reservation mentioned in the cover lett=
er.
The entries I was referring to are not proprietary vendor verbs but=20
rather user space
verbs who are on their way to be submitted upstream for inclusion in=20
libibverbs/libmlx4.
Two of these verbs are the userspace API for Flow-Steering whose kernel=
=20
part (as you know)
is under review in linux-rdma. These verbs are=20
ibv_create_flow/ibv_destroy_flow which
serve to attach and detach a QPs to/from flows, using flow=20
specification. The third
verb deals with registration of shared-memory, details below.
Each verb consumes two pointers, one for the verbs library code and one=
=20
for provider
specific library implementation, total of six pointers.
I think we all agree that the current milestone to meet w.r.t to verbs=20
extensions is
to have the basic extensions mechanism AND XRC patches merged.
On the other hand, RAW Ethernet QPs are merged upstream (kernel + user=20
space) but without
upstream mechanism to actually receive traffic on them which makes them=
=20
pretty much useless.
So in that respect, it would make sense for us as vendor to provide=20
customers through
mellanox ofed the means to use them. What asked now is to reserve the=20
pointers, no more.
As for the Shared-MR, indeed it would have been fair to require=20
submitting this
code prior to the pointer reservation, so for next time...

To sum up, we think it would be constructive step to continue with this=
=20
series while reserving the six pointers,
or if this really helps submit for review the libibverbs part of those=20
verbs along with the basic verbs extensions patches.

What do you think ?
By the way I'm OOO for a week starting 16/7.

Yishai

New verb, "Register Shared Memory Region=94: this verb is defined in th=
e=20
IB spec, section 11.2.8.8.

=93Given an existing Memory Region, a new independent Memory Region=20
associated with the same physical memory locations is created by that=20
new verb.
Through repeated calls to the Verb, an arbitrary number of Memory=20
Regions can potentially share the same physical memory locations.
The memory region created by this verb behaves identically to memory=20
regions created by the other memory registration verbs.=94

In general sharing MR involves 2 steps:
1) Using the regular mechanism to create a Memory Region, application=20
can mention that MR should be created with a later option to be shared.=
=20
The application will supply the allowed sharing access to that MR.
2) Using the =93Register Shared MR=94 to register to the pre-allocated=20
shared MR.

On 7/11/2013 8:07 PM, Jason Gunthorpe wrote:
> On Thu, Jul 11, 2013 at 06:04:16PM +0300, Yishai Hadas wrote:
>
>> ABI support with OFED release, added place holder for 6 function poi=
nters
>>   in verbs_context to enable ABI compatibility with OFED release tha=
t already
>>   used 6 extended verbs before XRC.
> WTF !?!
>
> The extension mechanism is NOT A TOY.
>
> IT IS NOT FOR VENDORS TO USE.
>
> Extension ids must be allocated at upstream, by Roland.
>
> If you deviate from upstream you *MUST* change the ibverbs SONAME.
>
> PERIOD.
>
> What version of OFA OFED did this? This is a violation of the new
> upstream first policy at OFA!
>
> So, I'm going to NAK this. It sets an exceedingly bad precedent going
> forward.
>
> Jason
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
