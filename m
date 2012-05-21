From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH for-next 5/6] net/mlx4: Adjust initial value of vl_cap
 in mlx4_SET_PORT
Date: Mon, 21 May 2012 13:15:19 +0300
Message-ID: <4FBA15B7.80906@mellanox.com>
References: <1336681689-16668-1-git-send-email-ogerlitz@mellanox.com> <1336681689-16668-6-git-send-email-ogerlitz@mellanox.com> <CAL1RGDUjNrRnU2_cfbdJd790K9oLD+rRFQDOyR6eX-3R1tWbQA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAL1RGDUjNrRnU2_cfbdJd790K9oLD+rRFQDOyR6eX-3R1tWbQA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Aviad Yehezkel <aviadye-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 5/19/2012 3:40 AM, Roland Dreier wrote:
> This really doesn't look maintainable as different devices with 
> different limits come along.

okay, so lets hold off with this patch for a while until we find 
something which is more maintainable

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
