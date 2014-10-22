From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: Can someone help me understand the reason for this code in ib_isert.c?
Date: Wed, 22 Oct 2014 12:02:34 +0300
Message-ID: <544772AA.7060003@mellanox.com>
References: <462EF229174FDB4D92ACE4656EA5610051E2EEF9@CMEXMB1.ad.emulex.com>	 <CAJ3xEMjmmt1guJO8rF6ChnTq-ZQbt9dpb_hwsNQCR65C79waRQ@mail.gmail.com> <1413954397.30983.33.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1413954397.30983.33.camel-XoQW25Eq2zviZyQQd+hFbcojREIfoBdhmpATvIKMPHk@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>, Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Chris Moore <Chris.Moore-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 10/22/2014 8:06 AM, Nicholas A. Bellinger wrote:
> On Tue, 2014-10-21 at 00:13 +0300, Or Gerlitz wrote:
>> On Mon, Oct 20, 2014 at 6:29 PM, Chris Moore <Chris.Moore-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org> wrote:
>>> The following code is in isert_conn_setup_qp() in ib_isert.c:
>>>
>>>           /*
>>>             * FIXME: Use devattr.max_sge - 2 for max_send_sge as
>>>             * work-around for RDMA_READ..
>>>             */
>>>           attr.cap.max_send_sge = device->dev_attr.max_sge - 2;
>>>
>>> It's not clear from the comment what this is a work-around for, and I wasn't able
>>> to figure it out from looking at logs.
>> I believe this refers to some IBTA spec corner case which comes into
>> play with the max_sges advertized by mlx4, Eli, can you shed some
>> light (IBTA pointer) on that? is this the case (i.e dev_attr.max_sge
>> isn't always achievable) with mlx5 too?
>>
> It's for ConnectX-2 reporting max_sge=31 during development, while the
> largest max_send_sge for stable large block RDMA reads was (is..?) 29
> SGEs.
>
>>> In trying to get isert working with ocrdma I ran into a problem where the code
>>> thought there was only 1 send SGE available when in fact the device has 3.
>>> Then I found the above work-around, which explained the problem.
>> Nic, any reason for attr.cap.max_send_sge = 1 not to work OK?
>>
> IIRC, pre fastreg code supported max_send_sge=1 by limiting the transfer
> size per RDMA read, and would issue subsequent RDMA read + offset from
> completion up to the total se_cmd->data_length.
>
> Not sure how this works with fastreg today.  Sagi..?
>

While on fastreg mode, for RDMA reads  we use only one SGE, talking to 
Sagi he explained me that the problem with creating the QP with 
max_send_sge = 1 has to do with other flows where two or even three SGEs 
are needed, e.g when the iscsi/iser header (doesn't exist in RDMA ops) 
is taken from one spot of the memory and the data (sense) taken from 
another one?

Nic, we need to see what is the minimum needed by the code (two?) and 
tweak that line to make sure it gets there as long as the device 
supports it, SB, makes sense?


diff --git a/drivers/infiniband/ulp/isert/ib_isert.c 
b/drivers/infiniband/ulp/isert/ib_isert.c
index 0bea577..24abbb3 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -115,9 +115,10 @@ isert_conn_setup_qp(struct isert_conn *isert_conn, 
struct rdma_cm_id *cma_id,
         attr.cap.max_recv_wr = ISERT_QP_MAX_RECV_DTOS;
         /*
          * FIXME: Use devattr.max_sge - 2 for max_send_sge as
-        * work-around for RDMA_READ..
+        * work-around for RDMA_READ.. still need to make sure to
+        * have at least two SGEs for SCSI responses.
          */
-       attr.cap.max_send_sge = device->dev_attr.max_sge - 2;
+       attr.cap.max_send_sge = max(2, device->dev_attr.max_sge - 2);
         isert_conn->max_sge = attr.cap.max_send_sge;

         attr.cap.max_recv_sge = 1;


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
