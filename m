From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 1/1] IB/iser: Remove hard coded values for cqe and send_wr
Date: Tue, 14 Oct 2014 09:50:46 +0200
Message-ID: <543CD5D6.1020506@mellanox.com>
References: <1412728888-13100-1-git-send-email-jkallickal@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1412728888-13100-1-git-send-email-jkallickal-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jay Kallickal <jayamohank-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Minh Tran <minhduc.tran-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Cc: michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jayamohan Kallickal <jayamohan.kallickal-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


On 10/8/2014 2:41 AM, Jay Kallickal wrote:
> This patch allows the underlying hardware to choose
> values other than  hard coded max values for cqe and send_wr
> while preventing them from exceeding max supported values.

These values are not "just" hard coded. If your HW driver (ocrdma?) 
can't support them, the way to fix that is
different e.g use smaller number of commands per session. I don't see 
the point to rebase the patch before
make a small design discussion here.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
