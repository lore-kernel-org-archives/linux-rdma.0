From: Vladimir Sokolovsky <vlad-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: unable to clone latest management git
Date: Mon, 27 Sep 2010 15:07:29 +0200
Message-ID: <4CA09711.7020504@dev.mellanox.co.il>
References: <4CA07EA8.5080508@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4CA07EA8.5080508-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Eli Dorfman (Voltaire)" <dorfman.eli-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 09/27/2010 01:23 PM, Eli Dorfman (Voltaire) wrote:
> Hi,
>
> I'm trying to clone management git and get a version from Mar 2009
>
> # git clone git://git.openfabrics.org/~sashak/management.git
>
> # git log
> commit 2ddba79eaa8de790d06d0281b5f2d3643a44905d
> Author: Hal Rosenstock<hnrose-Wuw85uim5zDR7s880joybQ@public.gmane.org>
> Date:   Tue Mar 24 13:44:48 2009 -0500
>
>      opensm: Remove some __ prefixes
>
>      Signed-off-by: Hal Rosenstock<hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>      Signed-off-by: Sasha Khapyorsky<sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
>
> Please advise.
>
> Thanks,
> Eli


Hi Sasha,
There is a new OFA server.
Please update your git tree on the new server.

Note:
- old server IP: 69.55.239.13
- new server IP: 69.55.231.68

Regards,
Vladimir

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
