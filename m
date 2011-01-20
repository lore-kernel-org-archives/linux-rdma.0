From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC 4/8] IB/srp: rework mapping engine to use multiple FMR entries
Date: Thu, 20 Jan 2011 12:04:57 +0200
Message-ID: <AANLkTim6H063ta0w2A+zo9QH0jY5qL5uu1OxN4iqMFEm@mail.gmail.com>
References: <1295411242-26148-1-git-send-email-dillowda@ornl.gov>
	<1295411242-26148-5-git-send-email-dillowda@ornl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1295411242-26148-5-git-send-email-dillowda-1Heg1YXhbW8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

> We up the minimum page size for the FMR pool, as it is rare that the
> kernel would send down a requests with scattered 512 byte fragments, and
> no HCA supports such a small FMR mapping in any case.


I believe you are wrong here as connectx support fmr-ing 512 byte
segments ("block lists") since firmware 2.6 or so

> # ibv_devinfo -v | grep -E "(page_size_cap|fw_ver)"
>         fw_ver:                         2.7.000
>         page_size_cap:                  0xfffffe00
Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
