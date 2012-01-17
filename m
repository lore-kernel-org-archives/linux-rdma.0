From: Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: Re: IB/iSER problems with Linux 3.0
Date: Tue, 17 Jan 2012 11:26:58 +0100
Message-ID: <4F154CF2.7030504@profitbricks.com>
References: <CAJZOPZL=bV4SjdD2eakX9MhOhw=91xzCK=BEkirhRQd8oPA6bg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJZOPZL=bV4SjdD2eakX9MhOhw=91xzCK=BEkirhRQd8oPA6bg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 16/01/12 22:16, Or Gerlitz wrote:
> Sebastian, I asked for the **iser** (ib_iser) and not mlx4_core debug_level=2
>   

Yes, I did! I've enabled that additionally. And I've checked these
settings in /sys/module/*/parameters. They were set. The libiscsi from
OFED had only the option "debug_libiscsi" but this was too verbose, so
this was the only thing I didn't activate there.

> 1. yes, the logs (correct ones, please!) from success login on the
> very same kernel would help
>   
Yes, I've sent you the correct logs. The only difference is:
1. in-tree vs. ofa-kernel-modules from OFED-1.5.4
2. open-iscsi 2.0.872 vs. open-iscsi 2.0.869 from OFED

In the log from working iSER there is the RDMA mapping debug message at
the position of the error in the other log.

Cheers,

Sebastian
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
