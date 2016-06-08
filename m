From: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH rdma-next 00/29] Soft RoCE driver
Date: Wed, 8 Jun 2016 11:49:15 +0300
Message-ID: <CAG9sBKN9HQKhRgXWZ8JJwwUdEBaP9VnGwr790C=q4w0XDxkbtw@mail.gmail.com>
References: <1464886657-14258-1-git-send-email-monis@mellanox.com> <20160603052539.GB31196@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160603052539.GB31196-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, leon-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Jun 3, 2016 at 8:25 AM, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wrote:
> Do you have a changelog compred to the last version?
>

- Moved from drivers/staging/rdma/rxe to drivers/infiniband/hw/rxe
- Rebase to newer kernel (was 4.4-rc6)
- Removed support in phys. MR
- Removed memory window codes (buggy)
- Mind  IS_ENABLED(CONFIG_IPV6)
- Dispatch IB event on port UP/DOWN
- Validate ICRC in receive
- Validate dgid in receive
- Scatter IPv4 header to right place for UD QP
- Other bug fixes
- Copyright dates were updated in file headers


> How well do FRWRs work, does this include Sagi's work in that area?
FRWR is not supported yet
> How well does posting of fenced WRs work?
We ran successfully some simple tests with IBV_SEND_FENCE

> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
