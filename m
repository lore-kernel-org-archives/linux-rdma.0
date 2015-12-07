From: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH libibverbs] init.c: increase sysfs read buffer size to 16
Date: Mon, 7 Dec 2015 15:27:28 +0200
Message-ID: <56658940.5040506@mellanox.com>
References: <1449184181-25676-1-git-send-email-jsquyres@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1449184181-25676-1-git-send-email-jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Squyres <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Xuyang Wang <xuywang-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 12/04/2015 01:09 AM, Jeff Squyres wrote:
> The default value of 8 is too small to read
> /sys/class/infiniband/usnic_x/node_type, which contains "6: usNIC
> UDP".  Per a7a73a8c1b39362f1701256bc772d82847832f9c, the too-small
> buffer causes a stderr warning to be emitted from ibv_devinfo when
> reading usNIC devices.
> 
> This commit therefore increases the buffer size to 16, which is long
> enough to read the usNIC node_type value.

Reviewed-by: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
