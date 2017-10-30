From: SF Markus Elfring <elfring-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Subject: Re: IB/mlx4: Use common error handling code in
 __mlx4_ib_create_flow()
Date: Mon, 30 Oct 2017 09:04:36 +0100
Message-ID: <e2febce9-4b80-a40e-024e-5c24964301ac@users.sourceforge.net>
References: <0bcea3cf-91e3-01d5-8d80-34cd6b611fb1@users.sourceforge.net>
 <70843f43-03c5-8295-643a-4f228ff2e907@intel.com>
 <0c92fc8e-ecb8-c7ed-0b4c-721752297222@users.sourceforge.net>
 <20171027193601.GI16127@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171027193601.GI16127-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Content-Language: en-GB
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

>>> I mean you aren't really making the code any smaller
>>
>> Would anybody like to check corresponding effects in more detail
>> after a specific function call was replaced by a goto statement?
> 
> You are supposed to do it and not "anybody".

I can offer another bit of information for this software development discussion.

The following build settings were active in my “Makefile” for this Linux test case.

…
HOSTCFLAGS   = -Wall -Wmissing-prototypes -Wstrict-prototypes -O0 -fomit-frame-pointer -std=gnu89
…


The affected source file can be compiled for the processor architecture “x86_64”
by a tool like “GCC 6.4.1+r251631-1.3” from the software distribution
“openSUSE Tumbleweed” with the following command example.

my_cc=/usr/bin/gcc-6 \
&& my_module=drivers/infiniband/hw/mlx4/main.o \
&& git checkout next-20171009 \
&& make -j4 CC="${my_cc}" HOSTCC="${my_cc}" allmodconfig "${my_module}" \
&& size "${my_module}" \
&& git checkout next_fine-tuning_in_mlx4_1 \
&& make -j4 CC="${my_cc}" HOSTCC="${my_cc}" allmodconfig "${my_module}" \
&& size "${my_module}"


Do you find the following details useful for further clarification?

text: -32
data: 0
bss:  0

Regards,
Markus
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
