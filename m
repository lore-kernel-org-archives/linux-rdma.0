From: oulijun <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: The qeustion for XRC debug and ex verbs
Date: Fri, 9 Feb 2018 15:38:29 +0800
Message-ID: <cc34799b-100f-d518-1044-2e7c14bd3db4@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="gbk"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linuxarm <linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi, all
  I am debugging for XRC feature on hns roce and have a question for help.
  I am use perftest tool. use the cmd as follows:
  server: ./ib_send_bw -n 5 -c XRC
  client: ./ib_send_bw -n 5 -c XRC ip

  when run into the ctx_xrc_srq_create interface, it will call ibv_create_srq_ex function and
  enter into the libibverbs library. However, the ibv_create_srq_ex will not be entered in verbs.h

  I doubt that I have an incorrect configurtion for using uapi xx_xx_ex.
  others may give some help for me.
  note: My rdma-core version is rdma-core-v15.

thanks
Lijun Ou

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
