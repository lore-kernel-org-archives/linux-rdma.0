From: Vladislav Bolkhovitin <vst-d+Crzxg7Rs0@public.gmane.org>
Subject: RDMA power failure write atomicity
Date: Thu, 10 Mar 2016 15:45:56 -0800
Message-ID: <56E20734.4030208@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hello,

I'm currently considering to use NVDIMM behind RDMA and wonder what is RDMA power
failure write atomicity? I mean, what is minimal size and alignment guaranteed to be
written atomically in face of power failure (or some other similar failure), i.e.
either written in full, or not written at all?

For memory writes on Intel it is 8 bytes with 8 bytes alignment. Is there anything like
this for RDMA? Or different vendors/implementation have so different expectations and
promises, so you can not assume anything >1 byte?

I can't find such info anywhere.

Thanks,
Vlad
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
