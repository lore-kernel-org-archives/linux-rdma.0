From: Or Gerlitz <ogerlitz-hKgKHo2Ms0FWk0Htik3J/w@public.gmane.org>
Subject: Re: root owned writeable files under /sys
Date: Mon, 07 Jun 2010 07:56:10 +0300
Message-ID: <4C0C7BEA.6040200@Voltaire.com>
References: <4C082598.8000809@oracle.com> <4C0B2B24.6020304@Voltaire.com> <4C0BC819.1060201@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4C0BC819.1060201-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sumeet Lahorani <Sumeet.Lahorani-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Sumeet Lahorani wrote:
> Thanks. I realized that my earlier find command didn't capture all the
> files I was looking for. After your patch, the following still need to
> be addressed (all are mlx4 files)

&& all are not part of the mainline kernel, as such, you should approach the ofed maintainers or make a comment when the relevant code is submitted upstream.

Or.

> /sys/class/infiniband/mlx4_0/diag_counters/clear_diag
> /sys/devices/pci0000:00/0000:00:04.0/0000:13:00.0/port_trigger
> /sys/devices/pci0000:00/0000:00:04.0/0000:13:00.0/mlx4_port2
> /sys/devices/pci0000:00/0000:00:04.0/0000:13:00.0/mlx4_port1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
