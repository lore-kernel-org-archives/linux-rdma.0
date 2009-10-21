From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH] librdmacm: fix race initializing library
Date: Wed, 21 Oct 2009 09:32:54 -0700
Message-ID: <E1BA2D14C6C44EF4A83562D04EF544C4@amr.corp.intel.com>
References: <OF77296F68.F34EB189-ONC225764C.003E31BE-C225764C.003F7FF9@il.ibm.com> <70A923FFB18B4139984C5F6D2DE67C51@amr.corp.intel.com> <OF32AE4B60.BDB2AC2B-ONC2257656.0028FF56-C2257656.002B0027@il.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <OF32AE4B60.BDB2AC2B-ONC2257656.0028FF56-C2257656.002B0027-7z/5BgaJwgfQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Nir Naaman' <NAAMAN-7z/5BgaJwgfQT0dZR+AlfA@public.gmane.org>
Cc: 'linux-rdma' <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

>The way I see it this fix only reduces the probability of a race condition, but
>still leaves room for other threads to face an inconsistent memory. The
>probability of an error depends on the architecture; our experience is that
>you'll face a much greater risk on PowerPC compared to Intel.

Please explain what race condition you see in more detail.  cma_dev_cnt is only
changed under lock, and by the time it is set, all other initialization has
completed.

- Sean

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
