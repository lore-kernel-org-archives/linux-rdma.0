From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: OpenSM "port is down" logging too verbose
Date: Fri, 30 Sep 2011 11:28:59 -0400
Message-ID: <4E85E03B.6020108@dev.mellanox.co.il>
References: <CAL1RGDU9TMN4P5SFZf5x-YXKsx794CLsM4iNfHYYL6pb4DyXXw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAL1RGDU9TMN4P5SFZf5x-YXKsx794CLsM4iNfHYYL6pb4DyXXw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Roland,

On 9/29/2011 1:18 PM, Roland Dreier wrote:
> Hi!
> 
> We have a setup where a system has an IB interface that is sort of
> optional... ie it won't always be connected but we want the SM always
> running and ready to bring up the ports if/when they are connected.
> 
> But in this case opensm logs stuff every 10 seconds:
> 
> Sep 28 13:41:57 PURE-B18 OpenSM[838]: SM port is down#012
> Sep 28 13:41:57 PURE-B18 OpenSM[836]: SM port is down#012
> Sep 28 13:42:07 PURE-B18 OpenSM[838]: SM port is down#012
> Sep 28 13:42:07 PURE-B18 OpenSM[836]: SM port is down#012
> Sep 28 13:42:17 PURE-B18 OpenSM[838]: SM port is down#012
> Sep 28 13:42:17 PURE-B18 OpenSM[836]: SM port is down#012
> Sep 28 13:42:27 PURE-B18 OpenSM[838]: SM port is down#012
> Sep 28 13:42:27 PURE-B18 OpenSM[836]: SM port is down#012
> Sep 28 13:42:37 PURE-B18 OpenSM[838]: SM port is down#012
> Sep 28 13:42:37 PURE-B18 OpenSM[836]: SM port is down#012
> 
> which junks up the syslog quite a bit.  It appears this message is
> emitted at level OSM_LOG_SYS so there's no way to turn it off at
> runtime (or am I misunderstanding the logging code?).
> 
> In any case would it be reasonable to print this log message once and
> then the next time we check the port, not print it again if the port
> was down last time?

Yes, that seems totally reasonable to me. Patch for this to follow shortly.

-- Hal

>  - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
