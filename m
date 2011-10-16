From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 3/5] net/mlx4_core: remove module param controlling the
 vlan table size
Date: Sun, 16 Oct 2011 10:32:56 +0200
Message-ID: <4E9A96B8.7020801@mellanox.com>
References: <alpine.LRH.2.00.1110101047420.10901@ogerlitz.voltaire.com> <alpine.LRH.2.00.1110101055050.11243@ogerlitz.voltaire.com> <CAG4TOxNaQicA6ExuNsw8V95mJPD+AQX5Wrfg+rCoBxdr2E+2ww@mail.gmail.com> <4E93EF38.5040707@mellanox.com> <CAL1RGDVk2EOmgWU_iZQWQqKJFPNYN4o_5_14Qbr_6wUzTJ1bOg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAL1RGDVk2EOmgWU_iZQWQqKJFPNYN4o_5_14Qbr_6wUzTJ1bOg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 10/11/2011 7:28 PM, Roland Dreier wrote:
> No, I think we need to switch to ignoring the parameter and printing a 
> warning if someone sets it, and then we can remove it in a year or so

done, I sent you V1 of patch 3/5 which fixes that,  any other comment 
for the rest of the series?

Or.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
