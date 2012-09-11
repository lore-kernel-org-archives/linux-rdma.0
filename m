From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH RFC for-next] net/mlx4_core: Fix racy flow in the driver
 CQ completion handler
Date: Tue, 11 Sep 2012 10:50:11 +0300
Message-ID: <CAJZOPZKuh0nO_L6Eji9bCqdgtB=OXrOcZTVbgqSs+iio3gfF9g@mail.gmail.com>
References: <20549.47088.805176.786765@iinet.net.au>
	<201209101617.46581.jackm@dev.mellanox.co.il>
	<504DEAB7.2070101@mellanox.com>
	<201209110903.39789.jackm@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <201209110903.39789.jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Max Matveev <makc-puGfsi27rH1aa/9Udqfwiw@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Shlomo Pongratz <shlomop-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, dotanb-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Sep 11, 2012 at 9:03 AM, Jack Morgenstein
<jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:
> On Monday 10 September 2012 16:27, Or Gerlitz wrote:
>> I  took a look on the practice/wrapping used over the mm subsystem for
>> radix_tree_lookup calls, whose maintainer,
>> Andrew Morton is signed on the patch Roland pointed to, its just
>> rcu_read_lock/unlock, seems this is what to do as well.
>>
> In addition, need to do a synchronize_rcu when deleting

patch?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
