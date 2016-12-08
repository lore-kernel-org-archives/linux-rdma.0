From: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 10/28] bnxt_re: register with the NIC driver
Date: Thu, 8 Dec 2016 15:12:34 +0530
Message-ID: <CA+sbYW1H6D5G02+8SDEzz+vCg1VS8wmxPYKdSO9ShvdDCoWKuQ@mail.gmail.com>
References: <1480919912-1079-1-git-send-email-selvin.xavier@broadcom.com>
 <1480919912-1079-11-git-send-email-selvin.xavier@broadcom.com> <ad3d577c-760f-c003-394a-d80efe96400c@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <ad3d577c-760f-c003-394a-d80efe96400c-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: jtoppins-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Eddie Wai <eddie.wai-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Somnath Kotur <somnath.kotur-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Sriharsha Basavapatna <sriharsha.basavapatna-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Dec 8, 2016 at 4:51 AM, Jonathan Toppins <jtoppins-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> Where is this function ever used in the series?
>
> $ git log -1 --oneline
> 8b8b72dd6226 bnxt_re: Add QP event handling
> $ git grep "bnxt_re_netevent"
> drivers/infiniband/hw/bnxtre/bnxt_re_main.c:static inline const char
> *bnxt_re_netevent(unsigned long event)

this function is not used. Removing it in V2
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
