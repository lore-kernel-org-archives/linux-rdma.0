From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: opensm/main.c: foce stdout to be line-buffered
Date: Tue, 23 Mar 2010 18:37:08 +0200
Message-ID: <20100323163708.GI4808@me>
References: <4B8E1D46.4090106@dev.mellanox.co.il>
 <20100323103733.GD4808@me>
 <4BA8B33E.8000003@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4BA8B33E.8000003-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 14:25 Tue 23 Mar     , Yevgeny Kliteynik wrote:
> 
> I'm running "opensm > somefile", and I don't see SM's stdout
> (such as "SUBNET UP" message, or new cached options after SIGHUP),
> because when stdout is assigned to file and not terminal, it is
> handled differently. Instead of flushing on printing '\n',
> it becomes buffered, which means that you don't control when
> is this buffer flushed.
> My fix forces stdout to always flush stdout when printing '\n'.
> It has no effect when stdout is assigned to terminal, and it
> changes buffering when SM's stdout is redirected.
> 
> More details about stdout/stderr buffering:
> 
> http://www.pixelbeat.org/programming/stdio_buffering/

There you can find couple of ways to workaround this issue, for example:

  stdbuf -o L opensm > somefile

I would prefer to not change an external settings so the program would
work as expected.

Sasha
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
