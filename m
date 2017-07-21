From: Nicolas Morey-Chaisemartin <NMoreyChaisemartin-l3A5Bk7waGM@public.gmane.org>
Subject: perftest proprietary files
Date: Fri, 21 Jul 2017 10:29:11 +0200
Message-ID: <2411a5c0-84f8-124e-83ce-1ee587dcf4ce@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: fr-xx-classique+reforme1990
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, zoharb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi,

While packaging perftest for SUSE, I discovered that some files have headers
 declaring the software as Mellanox proprietary while the COPYING declares LGPL/BSD.

The files are:
* Makefile.am
* Makefile.in
* configure.ac

Should these headers be dropped ?

(I pinged zoharb about this already without much luck. Figured it might be worth a shot here)

Nicolas

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
