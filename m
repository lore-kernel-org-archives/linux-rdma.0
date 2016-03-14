From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH libmlx4 2/2] Update consumer index after resize CQ operation
Date: Mon, 14 Mar 2016 23:09:43 +0200
Message-ID: <CAJ3xEMiMMiMyZh2qgKudVYU_VKdFtFN0uA0707KjGCByFHn+qg@mail.gmail.com>
References: <1457956055-2593-1-git-send-email-noaos@mellanox.com>
	<1457956055-2593-3-git-send-email-noaos@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1457956055-2593-3-git-send-email-noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Abramonvsky <hagaya-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Mar 14, 2016 at 1:47 PM, Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
> From: Haggai Abramonvsky <hagaya-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>
> The resize CQ operation generates a special CQE to indicate that the
> resize is done. After consuming this CQE, we need to increment the
> consumer index and update the doorbell record in the hardware as well.
>
> Before this patch, we didn't update the doorbell record in the hardware,
> which could resulted in CQ overrun.
>
> Signed-off-by: Haggai Abramovsky <hagaya-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Someone impersonating the author? different family names?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
