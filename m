From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH for-next] IB/usnic: Expose flows via debugfs
Date: Sun, 22 Dec 2013 12:23:43 +0200
Message-ID: <52B6BDAF.6030407@mellanox.com>
References: <6F4F8D2C-F10F-4697-ABD5-552D2E696361@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <6F4F8D2C-F10F-4697-ABD5-552D2E696361-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Upinder Malhi (umalhi)" <umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "<roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> Dreier" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 20/12/2013 23:37, Upinder Malhi (umalhi) wrote:
> This patch depends onhttp://www.spinics.net/lists/linux-rdma/msg18193.html

Why use proprietary debugfs code  to display flows? you can (and should) 
use the rdma subsystem netlink infrastructure for that, see these
two commits


753f618 RDMA/cma: Add support for netlink statistics export
b2cbae2 RDMA: Add netlink infrastructure


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
