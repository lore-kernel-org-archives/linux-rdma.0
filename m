From: Or Gerlitz <ogerlitz-hKgKHo2Ms0FWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH V2 5/5] RDMA CM: Netlink Client
Date: Tue, 30 Nov 2010 14:34:59 +0200
Message-ID: <4CF4EF73.6060406@Voltaire.com>
References: <1291047399-430-1-git-send-email-nirm@voltaire.com>	<1291047399-430-6-git-send-email-nirm@voltaire.com> <20101129191136.GC16788@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101129191136.GC16788-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Nir Muchtar <nirm-smomgflXvOZWk0Htik3J/w@public.gmane.org>, rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, monis-smomgflXvOZWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Jason Gunthorpe wrote:
> struct ib_nl_qp
>         // String names for IB devices was a mistake, don't perpetuate it.
>         __u32 ib_dev_if;

Jason,

Do you have a concrete suggestion and/or sketch for a patch
someone can work on to make this enumeration to take place? 

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
