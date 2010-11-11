From: Alekseys Senin <alekseys-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH V2 0/3] New RAW_PACKET QP type
Date: Thu, 11 Nov 2010 18:01:06 +0200
Message-ID: <1289491266.19225.25.camel@alst60.voltaire.com>
References: <4CD171F0.8020506@voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4CD171F0.8020506-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Moni Shoua <monis-hKgKHo2Ms0F+cjeuK/JdrQ@public.gmane.org>, Alex Rosenbaum <Alexr-smomgflXvOZWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, 2010-11-03 at 16:30 +0200, Aleksey Senin wrote:
> The following patches add a new QP type named RAW_PACKET.
> 
> This type of QP is used in Ethernet environment and intended for
> creation of a whole packet, including L2 headers, from userspace. In
> order to prevent regular user from creating malicious packets, at the
> time of QP creation, kernel will check if the process has necessary
> permissions. This examination areis done in uverbs layer and is general
> for all low level drivers.
> 

I've found small inaccuracies in the series and ask you not to apply it.
I'll resend a newer version.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
