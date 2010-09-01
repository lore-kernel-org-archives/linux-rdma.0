From: James A Simmons <uja-1Heg1YXhbW8@public.gmane.org>
Subject: Re: Patch for rpm and --without-depcheck
Date: Wed, 01 Sep 2010 13:38:57 -0400
Message-ID: <1283362737.14487.90.camel@bohr.ornl.gov>
References: <1283355839.14487.88.camel@bohr.ornl.gov>
Reply-To: simmonsja-1Heg1YXhbW8@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-reply-to: <1283355839.14487.88.camel-TbGF127JXZUcvh0c176lvQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: OFED <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, 2010-09-01 at 11:44 -0400, James A Simmons wrote:
> This patch passes --nodeps to rpmbuild when --without-depcheck is set.
> Sorry I don't know who the maintainer of install.pl is.

One note. The patch is against OFED-1.5.2-daily for Sept 1.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
