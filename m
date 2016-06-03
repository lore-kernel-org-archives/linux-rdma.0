From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 0/6] Various fixes for warnings reported by static source code
 analysis tools
Date: Fri, 3 Jun 2016 12:07:11 -0700
Message-ID: <86c06ca1-753c-6b45-3f65-f9a19f7693cf@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hello Doug,

The following patches are what I came up with after having analyzed the 
output of sparse and smatch for Linux RDMA kernel code:

0001-RDMA-core-Fix-indentation.patch
0002-IB-mad-Fix-indentation.patch
0003-IB-rdmavt-Annotate-rvt_reset_qp.patch
0004-IB-hfi1-Fix-indentation.patch
0005-IB-hfi1-Use-bit-0-instead-of-bit-1.patch
0006-IB-hfi1-Suppress-sparse-warnings.patch

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
