From: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: opensm/main.c: foce stdout to be line-buffered
Date: Wed, 24 Mar 2010 09:09:45 +0200
Message-ID: <4BA9BAB9.5040800@dev.mellanox.co.il>
References: <4B8E1D46.4090106@dev.mellanox.co.il> <20100323103733.GD4808@me>
	<4BA8B33E.8000003@dev.mellanox.co.il> <20100323163708.GI4808@me>
	<4BA9344A.6010007@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4BA9344A.6010007-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 23/Mar/10 23:36, Yevgeny Kliteynik wrote:
> On 23/Mar/10 18:37, Sasha Khapyorsky wrote:
>> On 14:25 Tue 23 Mar , Yevgeny Kliteynik wrote:
>>>
>>> I'm running "opensm> somefile", and I don't see SM's stdout
>>> (such as "SUBNET UP" message, or new cached options after SIGHUP),
>>> because when stdout is assigned to file and not terminal, it is
>>> handled differently. Instead of flushing on printing '\n',
>>> it becomes buffered, which means that you don't control when
>>> is this buffer flushed.
>>> My fix forces stdout to always flush stdout when printing '\n'.
>>> It has no effect when stdout is assigned to terminal, and it
>>> changes buffering when SM's stdout is redirected.
>>>
>>> More details about stdout/stderr buffering:
>>>
>>> http://www.pixelbeat.org/programming/stdio_buffering/
>>
>> There you can find couple of ways to workaround this issue, for example:
>>
>> stdbuf -o L opensm> somefile
>
> This is not a usual shell command, nor some common
> tool that is used in Linux distros. It's just a tool
> that is provided in some package called "coreutils 7.5".

Correction: the coreutils package is common, stdbuf isn't -
it was added in coreutils 7.5.
For instance, RH 5.3 has version 5.97, SLES 11 has version
6.12

-- Yevgeny

>> I would prefer to not change an external settings so the program would
>> work as expected.
>
> IMHO, on the contrary - the expected behavior
> would be achieved with the patch.
>
> But in any case, what exactly seems problematic here?
>
> I can't see any impact on any aspect whatsoever.
> It is somehow related to performance (more flushes
> when the stream is line-buffered instead of just
> buffered), but we're talking about stdout here, not
> the log file, so the performance is not affected too.
>
> -- Yevgeny
>
>> Sasha
>>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at http://vger.kernel.org/majordomo-info.html
>

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
