From: Talat mellanox <talatb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH rdma-core 00/10] Provide a compat infiniband/arch.h
Date: Wed, 15 Feb 2017 15:51:05 +0200
Message-ID: <CAB1oGZeJNvwwcii+z7VYQzZK3LJcToZ4uRF=_waA6WAboJueCg@mail.gmail.com>
References: <1486677212-3188-1-git-send-email-jgunthorpe@obsidianresearch.com> <20170215051511.GK6989@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170215051511.GK6989-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Talat mellanox <talat.mellanox-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Jason,

Building a debian package failed with [1].

We should add arch.h to debian/libibverbs-dev.install .
i'll generate a patch and send it.

[1]
dh_install: usr/include/infiniband/arch.h exists in debian/tmp but is
not installed to anywhere.

Thanks,
Talat

On Wed, Feb 15, 2017 at 7:15 AM, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> On Thu, Feb 09, 2017 at 02:53:22PM -0700, Jason Gunthorpe wrote:
>> Prior commits made arch.h into a private header, but there are several places
>> out there that include it to get htonll. Provide a dummy compat header that
>> will let such places continue to compile, but with warnings.
>>
>> To do this we need to move the internal tree to use util/udma_barrier.h for
>> the barrier macros to free up the header file name and in the process replace
>> more of the crazy mix of byteswapping macros with endian.h equivalents.
>>
>> To make sure that everything remains working travis also learns to
>> compile-test all the header files.
>>
>> Jason Gunthorpe (10):
>>   Have check-build confirm that every public header is standalone
>>   Remove uses of htonll
>>   Remove uses of ntohll
>>   Do not use kernel byteswap macros
>>   Remove extraneous byteswap.h include
>>   mlx4: Remove include of asm/unistd.h
>>   rdmacm: Remove dangling cpu_to_be64 definitions
>>   umad: Replace htonll macros with proper inlines and mark deprecated
>>   Move the now private infiniband/arch.h to util/udma_barrier.h
>>   verbs: Add a compatibility arch.h
>>
>
> Thanks, applied.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
