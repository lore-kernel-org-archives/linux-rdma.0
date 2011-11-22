From: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Subject: Re: [PATCH] mlx4_core: enable changing HCA default max resource limits
Date: Tue, 22 Nov 2011 12:30:03 -0800
Message-ID: <CAL1RGDXBwDoXs-cRD4b+8WrS0eRzwAaVn4g4+_14YSAsxpkNbw@mail.gmail.com>
References: <20111108173940.GA23912@mellanox.com> <4ECBDE16.5040200@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4ECBDE16.5040200-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Nov 22, 2011 at 9:38 AM, Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
> Do you have any chance to look at this patch?

Yeah, I guess it's sort of OK.  But is there really no better way to
handle this than making users deal with 7 more module parameters?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
