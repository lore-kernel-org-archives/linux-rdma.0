From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] replace (long*)(long) casting with transportable data
 type (uintptr_t)
Date: Tue, 7 Dec 2010 14:43:38 +0200
Message-ID: <20101207124338.GB11898@me>
References: <3D555CA8351C471B84CD9D6432AFC6D0@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <3D555CA8351C471B84CD9D6432AFC6D0-Zpru7NauK7drdx17CPfAsdBPR1lH4CV8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Stan C. Smith" <stan.smith-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: 'Sasha Khapyorsky' <sashakvolt-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 15:55 Mon 06 Dec     , Stan C. Smith wrote:
> 
> Hello,
>   Your suggestion of removing extra casts does operate correctly under windows x64/x86 variants.
> Windows compilers have improved.
> 
> thanks,
> 
> Stan.
> 
> Signed-off-by: stan smith <stan.smith-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Applied. Thanks.

Sasha
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
