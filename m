From: Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [RFC ABI 0/8] Netlink-based IOCTLs RDMA ABI
Date: Thu, 26 May 2016 18:18:02 +0300
Message-ID: <CAAKD3BA3fxgHwSXg__9LAPo7E4-7NY7h7Gea5+1GCg11ydn2kQ@mail.gmail.com>
References: <1464100526-31730-1-git-send-email-leonro@mellanox.com>
	<1828884A29C6694DAF28B7E6B8A82373AB05004F@ORSMSX109.amr.corp.intel.com>
	<20160524210132.GB7950@obsidianresearch.com>
	<1828884A29C6694DAF28B7E6B8A82373AB0501E2@ORSMSX109.amr.corp.intel.com>
	<20160524214951.GC7950@obsidianresearch.com>
	<1828884A29C6694DAF28B7E6B8A82373AB05023F@ORSMSX109.amr.corp.intel.com>
	<20160524223052.GI7950@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160524223052.GI7950-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, May 25, 2016 at 1:30 AM, Jason Gunthorpe
<jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
> On Tue, May 24, 2016 at 09:59:46PM +0000, Hefty, Sean wrote:
>> > Your patch didn't explore how to encode the arguments to the
>> > operations - what did you want to do? (ie the stuff that trails the urdma_ioctl)
>>
>> I hadn't considered that aspect yet.  I planned to look at the
>> netlink proposal as a first step, but as an API it looks painful.
>
> I agree.
>
> If we are using SGL for the response then why not use SGL for
> everything? We've already lost the advantage of the packet-like
> encoding netlink uses.
>
> eg:
>
> struct urdma_ioctl {
>         u64     flags;
>         u16     domain;
>         u8      object_count;
>         u8      in_arg_count;
>         u8      out_arg_count;
>         u8      reserved[3];
>         // union urdma_object objects[object_count];
>         // struct arg_sgl in_args[in_arg_count];
>         // struct arg_sgl out_args[out_arg_count];
> };
>
> union urdma_object {
>       struct urdma_obj_id obj_id;
>       u64 data;
> };
>
> struct urdma_arg_sgl {
>       void *ptr;
>       u32 id;
>       u32 length;
> };
>
> (same comment goes for Mellanox's version)
>
> This looks like it would make the decode and validation steps simpler
> and avoid some of those ugly memory allocations in the Mellanox patch
> as well...
>
> This would also address your concern about hard-wiring the libibverbs
> 1.0 needs, and meet mellanox's concern to have a 0 copy path for the
> compat udata/etc.
>
> The user caller then uses the simplifed on-stack setup I was
> suggesting:
>
> int ibv_open_device(...)
> {
>     struct xxx resp;
>     struct kern_call
>     {
>         struct urdma_ioctl hdr;
>         struct urdma_arg common_out;
>         struct urdma_arg udata_out;
>     } call = {
>        .hdr = {.domain = URDMA_DEVICE, .out_arg_count = 2},
>        .common_out = {.ptr = &resp, id = CREATE_DEVICE_COMMON_RESP, .length = sizeof(resp)},
>        .udata_out = {.ptr = &udata_resp, id = CREATE_DEVICE_MLX4_UDATA_RESP, .length = sizeof(udata_resp)},
>     };
>
>     ioctl(fd, URDMA_IOCTL_OPEN, &kern_call);
>
>     // Kernel 0's the resp ID when it writes so user space knows it was supported
>     if (call.common_out.id != 0)
>        return EINVAL;
> }
>
> This outline is a mash up of ideas from both patches.
>

The proposal treat every pointer as a typed pointer (which pretty much
resembles the netlink style of doing things, but instead of
serializing it into the buffer, we just scatter it to multiple
buffers). I'm not sure it makes the parsing and validations easier.
Actually, I was thinking about ditching the common response buffer and
just overwriting the command buffer. The typed pointers are now only
used for the vendor part, as we want to retain comparability with old
user-space drivers (with zero copy). We could allow inlined vendor
data in the future.

> Jason

Matan

> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
