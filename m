From: Alan Cook <acook-osxm6dDZNBBZx8iatJs59jGjJy/sRE9J@public.gmane.org>
Subject: Re: Problem Pinning Physical Memory
Date: Thu, 2 Dec 2010 11:09:11 -0500
Message-ID: <AANLkTinu=GVHUpBJhP5yN4ToiEM1XTeVzBDYarKXXk2f@mail.gmail.com>
References: <loom.20101122T192618-795@post.gmane.org>
	<20101124135507.GA23230@mtldesk30>
	<20101124174245.GA25325@obsidianresearch.com>
	<4CF3DE7D.4060105@opengridcomputing.com>
	<4CF3DF49.8000605@opengridcomputing.com>
	<loom.20101130T160950-109@post.gmane.org>
	<4CF55DF2.1030507@opengridcomputing.com>
	<loom.20101201T162410-279@post.gmane.org>
	<4CF7487C.3080209@voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4CF7487C.3080209-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Dec 2, 2010 at 2:19 AM, Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org> wrote:
> Alan, kernel patches posted to this mailing list are against the mainline (upstream) Linux kernel

Thanks for pointing me to the correct kernel.

I found Tom's patch from July, but was unsure if that was the patch in
question or not.  It seems that he will have an updated version with
ibv_reg_mr() and not ibv_reg_io_mr() doing the registration, so I will
just wait for the update.

-- Alan
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
