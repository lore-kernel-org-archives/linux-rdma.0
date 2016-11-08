From: Alaa Hleihel <alaa-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: rdma-core example spec file is broken
Date: Tue, 8 Nov 2016 16:47:21 +0200
Message-ID: <f807db01-c4c7-0f64-fe6b-476d02b686b3@dev.mellanox.co.il>
References: <0e831337-e404-8973-b7fe-e176b3d688e8@dev.mellanox.co.il>
 <20161107164415.GA8780@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161107164415.GA8780-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi

On 11/7/2016 18:44, Jason Gunthorpe wrote:
> On Sun, Nov 06, 2016 at 02:01:20PM +0200, Alaa Hleihel wrote:
>> Hi Jason,
>>
>> The example spec file is broken after commit ddd530be4622 ("Minor RPM spec file improvments").
>>
>> rpmbuild fails with the following error:
>>
>> Executing(%build): /bin/sh -e /var/tmp/rpm-tmp.7l0yoN
>> + umask 022
>> + cd /tmp/xxx/BUILD
>> + cd rdma-core-11
>> /var/tmp/rpm-tmp.7l0yoN: line 31: syntax error near unexpected token `post'
>> error: Bad exit status from /var/tmp/rpm-tmp.7l0yoN (%build)
>>
>> The issue is that the new "Requires" macros were added after the %prep and %build sections..
> Ah, interesting, in my test scripts the common spec file is
> superceeded by the version in redhat/ for systemd systems, which is
> why I did not notice it.
Yes, it happens with relatively new versions only..

> Jason
>
> From f2388d9d110ab43295d50d7345d5dda289a87a41 Mon Sep 17 00:00:00 2001
> From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
> Date: Mon, 7 Nov 2016 09:37:38 -0700
> Subject: [PATCH] Fix common rdma-core.spec for systemd systems
>
> RPM needs the Requires lines for systemd to be earlier.
>
> Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
> ---
>  rdma-core.spec | 10 +++++++---
>  1 file changed, 7 insertions(+), 3 deletions(-)
>
> diff --git a/rdma-core.spec b/rdma-core.spec
> index 35186c3271b8..bea2a2267d1d 100644
> --- a/rdma-core.spec
> +++ b/rdma-core.spec
> @@ -46,6 +46,13 @@ BuildRequires: make
>  %endif
>  %endif
>  
> +# Detect if systemd is supported on this system
> +%if 0%{?_unitdir:1}
> +Requires(post): systemd-units
> +Requires(preun): systemd-units
> +Requires(postun): systemd-units
> +%endif
> +
>  %description
>  Temporary packaging
>  
> @@ -59,9 +66,6 @@ This is a simple example without the split sub packages to get things started.
>  # Detect if systemd is supported on this system
>  %if 0%{?_unitdir:1}
>  %define my_unitdir %{_unitdir}
> -Requires(post): systemd-units
> -Requires(preun): systemd-units
> -Requires(postun): systemd-units
>  %else
>  %define my_unitdir /tmp/
>  %endif

I tested this patch.
It resolves the issue.

Thanks,
Alaa
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
