From: Yigal Korman <yigal-/8YdC2HfS5554TAoqtyWWQ@public.gmane.org>
Subject: Possible rdma-core header conflict
Date: Mon, 21 Aug 2017 12:24:14 +0300
Message-ID: <CACTTzNa3EzABie9=h2X-ONBefyaoWE1+RAT-T+uxJVvVij15Rg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linux RDMA Mailing List <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi,
Has anyone noticed that installing rdma-core (or older
librdmacm-devel) package and then installing kernel headers manually
(make headers_install) removes the librdmacm headers?
I actually see it in the make output:

make INSTALL_HDR_PATH=/usr headers_install
  CHK     include/generated/uapi/linux/version.h
  REMOVE  rdma_cma_abi.h rdma_verbs.h rdma_cma.h rsocket.h

Am I doing something wrong?
Sounds like the kernel rdma headers and librdmacm headers shouldn't
sit in the same directory...


Thanks,
Yigal
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
